# Выгрузка конфигурации МИС из базы в Git:
# проверка клона -> git pull -> выгрузка в файлы (инкрементально) -> синхронизация в клон ->
# статистика + предохранитель -> ветка export/... -> коммит -> push -> ссылка на PR
#
# Запуск: export_mis.bat            (интерактивно)
#         export_mis.bat /nopause   (без вопросов: при превышении порога - отказ)
#         powershell -File export_mis.ps1 -Message "Описание изменений"

param(
    [string]$Message = '',
    [switch]$NonInteractive
)

$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [Text.Encoding]::UTF8

# ===================== НАСТРОЙКИ =====================
# Папка с клоном репозитория (где лежит Configuration.xml)
$Repo   = 'E:\Дима\MIS360_Claude_GIT'

# Путь к платформе 1С
$V8     = 'C:\Program Files\1cv8\8.5.1.1302\bin\1cv8.exe'

# Тип базы: S - серверная, F - файловая
$IBType = 'S'
# Для S: 'сервер\имя_базы'   Для F: 'C:\Базы\МИС'
$IBPath = 'localhost:2541\mis_85_2'

# Пользователь 1С с административными правами
$User   = 'Администратор'
# Пароль берётся из переменной окружения MIS_1C_PASS (задать один раз: setx MIS_1C_PASS "пароль").
# Если переменной нет - скрипт спросит пароль при запуске.
$Pass   = $env:MIS_1C_PASS

# Код разрешения, если сеансы заблокированы через консоль кластера (иначе пусто)
$UC     = ''

# Куда складывать логи и промежуточную выгрузку (та же папка, что у update_mis.ps1)
$Work   = 'E:\Дима\MIS360_Claude_GIT_Backup'

# Основная ветка репозитория
$MainBranch = 'main'

# Предохранитель: если изменилось больше файлов, чем указано, скрипт остановится и спросит
$MaxChangedFiles = 300

# Открыть страницу создания PR в браузере после push
$OpenBrowser = $true
# =====================================================

$ts     = Get-Date -Format 'yyyy-MM-dd_HH-mm'
$Branch = "export/$ts"
$Stage  = "$Work\dump"                 # полная копия выгрузки базы (здесь живёт ConfigDumpInfo.xml для -update)
$State  = "$Work\db_commit.txt"        # коммит, которому соответствует конфигурация базы
New-Item -ItemType Directory -Force -Path "$Work\logs", $Stage | Out-Null
$Log = "$Work\logs\export_$ts.log"

function Log([string]$msg) {
    Write-Host $msg
    Add-Content -Path $Log -Value $msg -Encoding UTF8
}

# git с выводом в лог; возвращает строки вывода, код в $script:GitRC
function Git {
    $out = & git -c core.quotepath=false -c core.autocrlf=false @args 2>&1 | ForEach-Object { "$_" }
    $script:GitRC = $LASTEXITCODE
    return $out
}

function GitOrThrow([string]$What) {
    $rest = $args
    $out = Git @rest
    $out | ForEach-Object { Log $_ }
    if ($script:GitRC -ne 0) { throw "$What завершился с ошибкой (git $($rest -join ' '))" }
    return $out
}

function Invoke-1C([string]$Step, [string]$Params) {
    Log "=== $Step ==="
    $out = "$Work\logs\last_1c.txt"
    Remove-Item $out -ErrorAction SilentlyContinue

    $line = "DESIGNER /$IBType`"$IBPath`" /N`"$User`" /P`"$Pass`""
    if ($UC) { $line += " /UC`"$UC`"" }
    $line += " /DisableStartupDialogs /DisableStartupMessages $Params /Out `"$out`""

    $p = Start-Process -FilePath $V8 -ArgumentList $line -PassThru
    $null = $p.Handle
    $p.WaitForExit()
    if (Test-Path $out) { Get-Content $out | ForEach-Object { Log $_ } }
    if ($p.ExitCode -ne 0) { throw "Шаг «$Step» завершился с ошибкой (код $($p.ExitCode))" }
}

function Ask([string]$Question) {
    if ($NonInteractive) { Log "$Question -> нет (запуск без вопросов)"; return $false }
    $a = Read-Host "$Question (y/N)"
    Log "$Question -> $a"
    return ($a -match '^(y|д|yes|да)$')
}

# Коммит, которому соответствует база: берём самое свежее из
#  - db_commit.txt (пишет этот скрипт после выгрузки)
#  - MIS_<дата>_<коммит>.cf (пишет update_mis.ps1 после загрузки)
function Get-DbCommit {
    $cands = @()
    if (Test-Path $State) {
        $cands += [pscustomobject]@{ Commit = (Get-Content $State -TotalCount 1).Trim(); Time = (Get-Item $State).LastWriteTime; Src = 'db_commit.txt' }
    }
    $cf = Get-ChildItem "$Work\cf\MIS_*_*.cf" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($cf -and $cf.BaseName -match '_([0-9a-f]{7,40})$') {
        $cands += [pscustomobject]@{ Commit = $Matches[1]; Time = $cf.LastWriteTime; Src = $cf.Name }
    }
    foreach ($c in ($cands | Sort-Object Time -Descending)) {
        $null = Git cat-file -e "$($c.Commit)^{commit}"
        if ($script:GitRC -eq 0) { return $c }
        Log "Коммит $($c.Commit) из $($c.Src) не найден в репозитории - пропускаю"
    }
    return $null
}

$StartBranch   = $null
$BranchCreated = $false
$Committed     = $false

try {
    Log "[$ts] Начало выгрузки"
    if (-not (Test-Path $V8)) { throw "Не найдена платформа 1С: $V8" }
    if (-not (Test-Path "$Repo\Configuration.xml")) { throw "В папке $Repo нет Configuration.xml - проверьте путь" }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Не найден git в PATH" }
    if (-not $Pass) {
        if ($NonInteractive) { throw "Не задан пароль: установите переменную окружения MIS_1C_PASS" }
        $sec  = Read-Host "Пароль пользователя 1С '$User'" -AsSecureString
        $Pass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
    }
    Set-Location $Repo

    # 1. Рабочее дерево должно быть чистым
    Log "=== Проверка рабочего дерева ==="
    $dirty = Git status --porcelain
    if ($script:GitRC -ne 0) { throw "git status завершился с ошибкой" }
    if ($dirty) {
        $dirty | Select-Object -First 30 | ForEach-Object { Log $_ }
        throw "В клоне есть незакоммиченные изменения ($(@($dirty).Count) шт.). Закоммитьте или отмените их и запустите снова"
    }
    $StartBranch = ((Git rev-parse --abbrev-ref HEAD) | Select-Object -First 1).Trim()
    Log "Текущая ветка: $StartBranch"

    # 2. Свежая версия из Git
    Log "=== git fetch / pull ==="
    $null = GitOrThrow 'git fetch' fetch origin --prune
    if ($StartBranch -ne $MainBranch) { $null = GitOrThrow 'git checkout' checkout $MainBranch }
    $null = GitOrThrow 'git pull' pull --ff-only origin $MainBranch
    $mainHead = ((Git rev-parse --short HEAD) | Select-Object -First 1).Trim()
    Log "$MainBranch = $mainHead"

    # 3. От какого коммита ветвиться: от того, который сейчас загружен в базу.
    #    Тогда в PR попадут только изменения, сделанные в Конфигураторе, а чужие коммиты
    #    из main не будут «откачены» выгрузкой.
    $db = Get-DbCommit
    if ($db) {
        $base = $db.Commit
        Log "База соответствует коммиту $base (по $($db.Src) от $($db.Time))"
        $behind = ((Git rev-list --count "$base..$MainBranch") | Select-Object -First 1).Trim()
        if ($behind -ne '0') {
            Log "ВНИМАНИЕ: в $MainBranch есть $behind коммит(ов), которых нет в базе. Ветка выгрузки будет от $base, слияние с ними - в PR."
        }
    } else {
        Log "ВНИМАНИЕ: не удалось определить, какому коммиту соответствует база (нет db_commit.txt и cf от update_mis)."
        Log "Ветка будет создана от $MainBranch ($mainHead). Если в main есть изменения, которых нет в базе, выгрузка покажет их как удалённые."
        if (-not (Ask "Продолжить от $MainBranch?")) { throw "Остановлено пользователем" }
        $base = $mainHead
    }

    # 4. Ветка выгрузки
    $null = GitOrThrow 'git checkout -b' checkout -b $Branch $base
    $BranchCreated = $true

    # 5. Выгрузка из базы в промежуточную папку (инкрементально, если там уже есть ConfigDumpInfo.xml)
    $dumpArgs = "/DumpConfigToFiles `"$Stage`" -Format Hierarchical"
    if (Test-Path "$Stage\ConfigDumpInfo.xml") { $dumpArgs += ' -update -force' }
    else { Log "Первая выгрузка в $Stage - будет полной, это займёт несколько минут" }
    Invoke-1C 'Выгрузка конфигурации в файлы' $dumpArgs
    if (-not (Test-Path "$Stage\Configuration.xml")) { throw "После выгрузки в $Stage нет Configuration.xml" }

    # 6. Перенос в клон: зеркалирование (удалённые в базе объекты удаляются и из клона).
    #    .git, tools и служебные файлы репозитория не трогаются; ConfigDumpInfo.xml не переносим,
    #    чтобы он не конфликтовал между ветками.
    Log "=== Синхронизация $Stage -> $Repo ==="
    $rc = & robocopy $Stage $Repo /MIR /XD "$Repo\.git" "$Repo\tools" "$Repo\.github" /XF ConfigDumpInfo.xml .gitignore .gitattributes /R:1 /W:1 /MT:8 /NFL /NDL /NJH /NJS /NP
    $rcCode = $LASTEXITCODE
    $rc | Where-Object { $_.Trim() } | ForEach-Object { Log $_ }
    if ($rcCode -ge 8) { throw "robocopy завершился с ошибкой (код $rcCode)" }

    # 7. Что изменилось
    Log "=== Изменения ==="
    $null = GitOrThrow 'git add' add -A
    # Файлы, попадающие под .gitignore (например *.bin макетов), но нужные конфигурации - добавляем принудительно
    $ignored = Git ls-files --others --ignored --exclude-standard
    if ($ignored) {
        Log "Принудительно добавляю $(@($ignored).Count) файл(ов), попадающих под .gitignore:"
        $ignored | ForEach-Object { Log "  $_" }
        $listFile = "$Work\logs\force_add.txt"
        [IO.File]::WriteAllLines($listFile, [string[]]$ignored, (New-Object Text.UTF8Encoding $false))
        $null = GitOrThrow 'git add -f' add -f "--pathspec-from-file=$listFile"
    }

    $changes = @(Git diff --cached --name-status -M)
    if ($changes.Count -eq 0) {
        Log "[OK] Изменений нет - конфигурация в базе совпадает с коммитом $base"
        Set-Content -Path $State -Value (Git rev-parse HEAD) -Encoding ASCII
        $null = Git checkout $MainBranch
        $null = Git branch -D $Branch
        $BranchCreated = $false
        exit 0
    }

    $stat = (Git diff --cached --shortstat) | Select-Object -Last 1
    Log "Изменено файлов: $($changes.Count) ($stat)"
    # Сводка по объектам метаданных: Тип/Объект
    $objects = $changes | ForEach-Object {
        $parts = $_ -split "`t"
        $path  = $parts[-1]
        $seg   = $path -split '/'
        $obj   = if ($seg.Count -ge 2 -and $seg[0] -ne 'Ext') { "$($seg[0])/$($seg[1] -replace '\.xml$','')" } else { $seg[0] }
        [pscustomobject]@{ St = $parts[0].Substring(0,1); Obj = $obj }
    } | Group-Object Obj | Sort-Object Name
    Log "Затронуто объектов: $($objects.Count)"
    $objects | Select-Object -First 60 | ForEach-Object {
        $st = ($_.Group.St | Sort-Object -Unique) -join ''
        Log ("  [{0,-3}] {1} ({2} файл.)" -f $st, $_.Name, $_.Count)
    }
    if ($objects.Count -gt 60) { Log "  ... и ещё $($objects.Count - 60)" }

    # 8. Предохранитель
    if ($changes.Count -gt $MaxChangedFiles) {
        Log "ВНИМАНИЕ: изменилось $($changes.Count) файлов при пороге $MaxChangedFiles."
        Log "Так бывает при первой выгрузке, смене версии платформы или если база не соответствует коммиту $base."
        if (-not (Ask "Всё равно закоммитить и отправить?")) { throw "Остановлено: слишком много изменений" }
    }

    # 9. Коммит
    if (-not $Message -and -not $NonInteractive) { $Message = Read-Host "Кратко опишите изменения (Enter - пропустить)" }
    $subject = if ($Message) { $Message } else { "Выгрузка конфигурации из базы $ts" }
    $body = "$subject`n`nВыгрузка из базы $IBPath ($env:COMPUTERNAME, $env:USERNAME), $ts.`nБаза до изменений: $base.`nИзменено файлов: $($changes.Count), объектов: $($objects.Count).`n"
    $msgFile = "$Work\logs\commit_msg.txt"
    [IO.File]::WriteAllText($msgFile, $body, (New-Object Text.UTF8Encoding $false))
    $null = GitOrThrow 'git commit' commit -q -F $msgFile
    $Committed = $true
    $newCommit = ((Git rev-parse HEAD) | Select-Object -First 1).Trim()
    Set-Content -Path $State -Value $newCommit -Encoding ASCII
    Log "Коммит: $newCommit"

    # 10. Push
    Log "=== git push ==="
    $null = GitOrThrow 'git push' push -u origin $Branch

    # 11. Ссылка на PR
    $remote = ((Git remote get-url origin) | Select-Object -First 1).Trim()
    $web = $remote -replace '^git@([^:]+):', 'https://$1/' -replace '\.git$', ''
    $prUrl = "$web/compare/$MainBranch...$($Branch)?expand=1"
    Log "[OK] Ветка $Branch отправлена. Создать PR: $prUrl"
    if ($OpenBrowser -and -not $NonInteractive) { Start-Process $prUrl }

    # Возвращаем клон на основную ветку, чтобы update_mis.ps1 работал как обычно
    $null = Git checkout $MainBranch
    exit 0
}
catch {
    Log "[ОШИБКА] $($_.Exception.Message)"
    if ($BranchCreated -and -not $Committed) {
        Log "Откатываю изменения в клоне и удаляю ветку $Branch"
        $null = Git reset -q --hard
        $null = Git clean -fdq
        $null = Git checkout -q $MainBranch
        $null = Git branch -D $Branch
    } elseif ($Committed) {
        Log "Коммит сделан локально в ветке $Branch, но не отправлен. Отправьте вручную: git push -u origin $Branch"
    }
    Log "Лог: $Log"
    exit 1
}
