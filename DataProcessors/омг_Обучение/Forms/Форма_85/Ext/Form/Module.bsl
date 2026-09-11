&НаКлиенте
Процедура СодержаниеПриАктивизацииСтроки(Элемент)
	Строка = Элементы.Содержание.ТекущиеДанные;  
    
	Если Строка = Неопределено ИЛИ Строка.НомерКартинкиТипаКонтента = 0 Тогда
		Объект.ПолеHTML = ПолучитьHTMLЗаглушки();
		Возврат;
	КонецЕсли; 
    
	Данные = ПолучитьДанныеОбученияНаСервере(Строка.Наименование);
	Если Данные = Неопределено Тогда
		Объект.ПолеHTML = ПолучитьHTMLОшибки("Данные раздела не найдены");
		Возврат;
	КонецЕсли;
	
	HTML = ""; 
    
	Если Данные.ТипКонтента = "Видео" Тогда  
		IDФайла = ИзвлечьIDИзСсылкиГуглДиск(Данные.СсылкаНаВидео);
		Если ЗначениеЗаполнено(IDФайла) Тогда
			ПрямаяСсылка = "https://drive.usercontent.google.com/download?id=" 
				+ IDФайла + "&export=download&confirm=t";
			HTML = ПолучитьHTMLВидео(ПрямаяСсылка);
		Иначе
			HTML = ПолучитьHTMLОшибки("Не удалось распознать ID видео из ссылки");
		КонецЕсли;
	Иначе 
		СтрокаКеш = ПолучитьКешированныйПутьКФайлу(Данные.Документ);
		Если СтрокаКеш = Неопределено Тогда 
			ПутьКДокументу = ВыполнитьОткрытиеФайла(Данные.Документ);
		Иначе
			ПутьКДокументу = СтрокаКеш.Файл; 
		КонецЕсли;
		HTML = ПолучитьHTMLДокумента(ПутьКДокументу);
	КонецЕсли;
    
	Объект.ПолеHTML = HTML;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьHTMLВидео(ПрямаяСсылка)
	Возврат "
	|<!DOCTYPE html>
	|<html><head><meta charset='utf-8'><style>
	|  html,body{margin:0;padding:0;width:100%;height:100%;background:transparent;
	|    overflow:hidden;font-family:'Segoe UI',Arial,sans-serif;}
	|  .stage{display:flex;align-items:center;justify-content:center;
	|    width:100vw;height:100vh;box-sizing:border-box;padding:10px;
	|    background:transparent;}
	|  .player{position:relative;width:100%;height:100%;background:#f4f4f6;
	|    border-radius:10px;overflow:hidden;box-shadow:0 6px 22px rgba(0,0,0,.16);}
	|  video{position:absolute;top:0;left:0;width:100%;height:100%;
	|    object-fit:contain;display:block;background:#f4f4f6;}
	|  .loader{position:absolute;top:0;left:0;right:0;bottom:0;display:flex;
	|    flex-direction:column;align-items:center;justify-content:center;
	|    background:#f4f4f6;z-index:5;transition:opacity .35s;}
	|  .loader.hidden{opacity:0;pointer-events:none;}
	|  .logo{width:130px;height:auto;display:block;}
	|  .ltext{margin-top:16px;color:#0f9d77;font-size:13px;}
	|  .soundbtn{position:absolute;top:0;left:0;right:0;bottom:0;display:none;
	|    align-items:center;justify-content:center;flex-direction:column;
	|    background:rgba(0,0,0,.4);z-index:6;cursor:pointer;}
	|  .soundbtn.show{display:flex;}
	|  .sicon{width:62px;height:62px;border-radius:50%;background:#0f9d77;
	|    display:flex;align-items:center;justify-content:center;
	|    font-size:24px;color:#fff;padding-left:4px;box-sizing:border-box;}
	|  .stext{margin-top:12px;color:#fff;font-size:14px;}
	|</style></head><body>
	|<div class='stage'><div class='player'>
	|  <video id='v' controls playsinline preload='auto'>
	|    <source src='" + ПрямаяСсылка + "' type='video/mp4'>
	|  </video>
	|  <div class='loader' id='loader'>
	|    <img id='logo' class='logo' alt='' src=""data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='643' height='579' viewBox='0 0 643 579' fill='none'><path d='M642.103 195.406C642.103 303.326 554.469 390.813 446.366 390.813C338.263 390.813 250.629 303.326 250.629 195.406C250.629 87.4864 338.263 0 446.366 0C554.469 0 642.103 87.4864 642.103 195.406Z' fill='url(%23p0)'/><path d='M141.115 8.88909C177.723 1.2797 210.767 6.93516 235.272 14.7247C259.804 22.5229 279.756 33.6955 292.946 42.1801C299.754 46.5595 305.323 50.5878 309.422 53.7177C311.484 55.2918 313.208 56.6644 314.566 57.7727C315.246 58.3277 315.838 58.8191 316.337 59.2388C316.586 59.4487 316.813 59.641 317.017 59.8148C317.119 59.9016 317.215 59.9838 317.305 60.0612C317.35 60.1 317.394 60.1377 317.437 60.1741C317.458 60.1923 317.488 60.2188 317.499 60.2278C317.529 60.2539 317.522 60.3221 256.156 131.294L317.559 60.2797L320.135 62.5067L466.859 209.217L334.084 341.979L215.772 223.678C210.31 230.279 196.158 247.429 159.453 291.958C99.8264 364.295 99.7151 364.38 99.6902 364.36C99.6814 364.353 99.656 364.332 99.6384 364.317C99.603 364.288 99.5658 364.257 99.527 364.225C99.4494 364.161 99.3647 364.091 99.2735 364.015C99.091 363.863 98.8816 363.687 98.6463 363.489C98.1758 363.092 97.6009 362.603 96.9308 362.025C95.592 360.87 93.8636 359.351 91.8197 357.494C87.7505 353.796 82.3266 348.664 76.175 342.309C64.2092 329.948 47.8784 311.31 33.543 288.175C6.95331 245.264 -29.3771 154.843 40.214 71.2393L40.8658 70.4603C68.5107 37.5704 103.053 16.8007 141.115 8.88909Z' fill='url(%23p1)'/><path d='M85.0586 350.703L211.623 219.307L448.246 447.23L321.681 578.626L85.0586 350.703Z' fill='url(%23p2)'/><defs><linearGradient id='p0' x1='446.366' y1='0' x2='459.469' y2='195.543' gradientUnits='userSpaceOnUse'><stop stop-color='%23B3E6D2'/><stop offset='1' stop-color='%2311B594'/></linearGradient><linearGradient id='p1' x1='12.0495' y1='41.1735' x2='95.3547' y2='257.858' gradientUnits='userSpaceOnUse'><stop stop-color='%23A7E2CE'/><stop offset='1' stop-color='%2311B594'/></linearGradient><linearGradient id='p2' x1='159.216' y1='274.712' x2='538.921' y2='650.142' gradientUnits='userSpaceOnUse'><stop stop-color='%2311B594'/><stop offset='0.627933' stop-color='%23BAE8D5'/></linearGradient></defs></svg>"">
	|    <div class='ltext'>Загрузка видео…</div>
	|  </div>
	|  <div class='soundbtn' id='soundbtn'>
	|    <div class='sicon'>&#9658;</div>
	|    <div class='stext'>Нажмите для воспроизведения со звуком</div>
	|  </div>
	|</div></div>
	|<script>
	|  var v=document.getElementById('v');
	|  var loader=document.getElementById('loader');
	|  var soundbtn=document.getElementById('soundbtn');
	|  var logo=document.getElementById('logo');
	|  var t0=new Date().getTime();
	|  setInterval(function(){
	|    var k=Math.sin(2*Math.PI*((new Date().getTime()-t0)%1900)/1900);
	|    var s='scale('+(0.985+0.045*k).toFixed(4)+')';
	|    logo.style.transform=s;
	|    logo.style.msTransform=s;
	|    logo.style.webkitTransform=s;
	|    logo.style.opacity=(0.9+0.1*k).toFixed(3);
	|  },33);
	|  function hideLoader(){loader.classList.add('hidden');}
	|  v.addEventListener('canplay',hideLoader);
	|  v.addEventListener('playing',hideLoader);
	|  v.addEventListener('waiting',function(){loader.classList.remove('hidden');});
	|  v.addEventListener('error',function(){
	|    loader.classList.remove('hidden');
	|    loader.innerHTML=""<div class='ltext' style='color:#d23b3b'>Не удалось загрузить видео</div>"";
	|  });
	|  if(v.readyState>=3){hideLoader();}
	|  v.muted=false;
	|  var p=v.play();
	|  if(p!==undefined){
	|    p.catch(function(){
	|      v.muted=true;
	|      v.play().then(function(){soundbtn.classList.add('show');})
	|              .catch(function(){soundbtn.classList.add('show');});
	|    });
	|  }
	|  soundbtn.addEventListener('click',function(){
	|    v.muted=false; v.play(); soundbtn.classList.remove('show');
	|  });
	|</script>
	|</body></html>";
КонецФункции

&НаКлиенте
Функция ПолучитьHTMLЗаглушки()
	Возврат "
	|<!DOCTYPE html>
	|<html><head><meta charset='utf-8'><style>
	|  html,body{margin:0;height:100%;background:#f4f4f6;}
	|  .c{display:flex;flex-direction:column;align-items:center;justify-content:center;
	|     height:100vh;font-family:'Segoe UI',Arial,sans-serif;color:#9a9aa2;}
	|  .ic{width:84px;height:84px;border-radius:50%;background:#e7e7ea;
	|     display:flex;align-items:center;justify-content:center;
	|     font-size:34px;color:#b4b4bc;padding-left:6px;box-sizing:border-box;}
	|  .t{margin-top:16px;font-size:15px;}
	|</style></head><body>
	|  <div class='c'><div class='ic'>&#9658;</div>
	|  <div class='t'>Выберите раздел обучения слева</div></div>
	|</body></html>";
КонецФункции

&НаКлиенте
Функция ПолучитьHTMLОшибки(Текст)
	Возврат "
	|<!DOCTYPE html>
	|<html><head><meta charset='utf-8'><style>
	|  html,body{margin:0;height:100%;background:#f4f4f6;}
	|  .c{display:flex;align-items:center;justify-content:center;height:100vh;
	|     font-family:'Segoe UI',Arial,sans-serif;}
	|  .box{background:#fff;border:1px solid #f0d4d4;border-radius:10px;
	|     padding:22px 28px;color:#d23b3b;font-size:14px;
	|     box-shadow:0 4px 16px rgba(0,0,0,.06);}
	|</style></head><body>
	|  <div class='c'><div class='box'>" + Текст + "</div></div>
	|</body></html>";
КонецФункции

&НаКлиенте
Функция ПолучитьHTMLДокумента(ПутьКДокументу)
	Возврат "
	|<!DOCTYPE html>
	|<html><head><meta charset='utf-8'><style>
	|  html,body{margin:0;padding:0;height:100%;background:#f4f4f6;}
	|  .stage{box-sizing:border-box;padding:14px;height:100vh;}
	|  iframe{width:100%;height:100%;border:0;border-radius:10px;
	|     background:#fff;box-shadow:0 6px 22px rgba(0,0,0,.16);}
	|</style></head><body>
	|  <div class='stage'>
	|    <iframe src='" + ПутьКДокументу + "' frameborder='0'></iframe>
	|  </div>
	|</body></html>";
КонецФункции

&НаКлиенте
Функция ИзвлечьIDИзСсылкиГуглДиск(Знач Ссылка)
	// Ищем маркер начала ID
	ПозицияD = СтрНайти(Ссылка, "/d/");
	Если ПозицияD = 0 Тогда
		Возврат ""; // Ссылка не от Гугл Диска или битая
	КонецЕсли;
	
	// Отрезаем всё до ID
	Хвост = Сред(Ссылка, ПозицияD + 3);
	
	// Ищем конец ID (следующий слэш перед /view)
	ПозицияСлеша = СтрНайти(Хвост, "/");
	Если ПозицияСлеша > 0 Тогда
		Возврат Лев(Хвост, ПозицияСлеша - 1);
	Иначе
		Возврат Хвост;
	КонецЕсли;
КонецФункции
&НаКлиенте
Функция ПолучитьКешированныйПутьКФайлу(СсылкаНаФайл)
	
	НайдСтроки = КешПутейКФайлам.НайтиСтроки(Новый Структура("Файл", СсылкаНаФайл));
	Если НайдСтроки.Количество() > 0 Тогда 
		Возврат НайдСтроки[0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеОбученияНаСервере(Строка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|    Разделы.ТипКонтента,
	|    Разделы.Документ,
	|    Разделы.СсылкаНаВидео
	|ИЗ
	|    Справочник.омг_РазделыОбучения КАК Разделы
	|ГДЕ
	|    Разделы.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Строка);
	
	// Выполнение запроса
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		РезультатЗапроса = Новый Структура;
		Если Выборка.ТипКонтента = Перечисления.омг_ТипыКонтента.Видео Тогда
			ТипКонтента = "Видео"
		Иначе
			ТипКонтента = "Документ" 
		КонецЕсли;
		РезультатЗапроса.Вставить("ТипКонтента", ТипКонтента); 
		РезультатЗапроса.Вставить("Документ", Выборка.Документ);
		РезультатЗапроса.Вставить("СсылкаНаВидео", Выборка.СсылкаНаВидео);
		Возврат РезультатЗапроса;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции
&НаКлиенте
Функция ВыполнитьОткрытиеФайла(СсылкаНаФайл, КешированныйПуть=Неопределено)
	
	РасширениеФайла = НРег(ОбщегоНазначения.ПолучитьЗначениеРеквизита(СсылкаНаФайл, "Расширение"));
	Если РасширениеФайла = ".mxl" Тогда
		ПутьКФайлу = РаботаСФайламиКлиент.ОткрытьФайл(СсылкаНаФайл,,КешированныйПуть, Истина);
		Если Не ЗначениеЗаполнено(ПутьКФайлу) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Прикрепленный файл не найден");
			Возврат "";
		КонецЕсли;
		
		АдресХранилища = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу), УникальныйИдентификатор);
		////СтруктураПечати = ПолучитьСтруктуруПечатиТабДока(АдресХранилища);
		//Если СтруктураПечати = Неопределено Тогда 
		//	ОбщегоНазначения.СообщитьПользователю("Не удалось открыть файл");
		//Иначе
		//	ПечатьДокументовКлиент.ВывестиНапечататьДокумент(СтруктураПечати, Неопределено);
		//КонецЕсли;
	Иначе
		ПутьКФайлу = РаботаСФайламиКлиент.ОткрытьФайл(СсылкаНаФайл,,КешированныйПуть,ИСТИНА); 
	КонецЕсли;
	
	Возврат ПутьКФайлу;
	
КонецФункции 

&НаКлиенте
Процедура СодержаниеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Элементы.СодержаниеСсылкаНаВидео.Видимость = ЛОЖЬ;
КонецПроцедуры
