
Функция ПолучитьАдресАрхиваНаСервере(УникальныйИдентификатор) Экспорт
	
	МакетАрхив = Обработки.iga_РедакторТекстаHTML.ПолучитьМакет("МакетTwemoji");
	
	// Помещаем во временное хранилище и привязываем к жизни текущей формы
	Возврат ПоместитьВоВременноеХранилище(МакетАрхив, УникальныйИдентификатор);
	
КонецФункции

Функция ПолучитьМакетДляЧтения() Экспорт
	
	Возврат ПолучитьОбщийМакет("iga_КодРедактораHTMLЧтение").ПолучитьТекст();
	
КонецФункции

Функция ПолучитьМакетДляРедактирования() Экспорт
	
	Возврат ПолучитьОбщийМакет("iga_КодРедактораHTMLРедактирование").ПолучитьТекст();
	
КонецФункции

Функция ПутьКСкриптуЭмодзи() Экспорт
	
	Возврат Константы.iga_ПутьКСкриптуЭмодзи.Получить();
	
КонецФункции

Функция ПолучитьПолеВыбораЯзыка(ТекущийЯзык) Экспорт
	
    // Получаем УИД текущего языка из параметров формы, если он был передан
    ТекущийУИД = "";
    Если ЗначениеЗаполнено(ТекущийЯзык) Тогда
        ТекущийУИД = Строка(ТекущийЯзык.УникальныйИдентификатор());
    КонецЕсли;
    
    // CSS дополнен стилями для выделенной карточки (.selected) и бейджа (.badge)
    Стиль = "
    | body { display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f4f4f9; font-family: sans-serif; }
    | .lang-container { display: flex; gap: 20px; flex-wrap: wrap; justify-content: center; }
    | .lang-card { position: relative; text-decoration: none; color: inherit; display: flex; justify-content: center; align-items: center; background: #fff; border: 2px solid #e0e0e0; border-radius: 12px; padding: 30px 40px; cursor: pointer; transition: all 0.2s ease; text-align: center; min-width: 120px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
    | .lang-card:hover { border-color: #007bff; transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,123,255,0.2); }
    | .lang-title { font-size: 20px; font-weight: bold; color: #333; pointer-events: none; }
    | /* Стили для выбранного языка */
    | .lang-card.selected { border-color: #28a745; background-color: #f8fff9; box-shadow: 0 0 0 2px rgba(40,167,69,0.2); }
    | .lang-card.selected:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(40,167,69,0.3); }
    | .badge { position: absolute; top: -12px; right: -12px; background: #28a745; color: white; font-size: 12px; font-weight: bold; padding: 4px 10px; border-radius: 12px; pointer-events: none; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    |";
    
    HTML = "<!DOCTYPE html><html><head><meta charset='utf-8'><style>" + Стиль + "</style></head><body><div class='lang-container'>";
    
    Запрос = Новый Запрос("ВЫБРАТЬ Ссылка, Наименование ИЗ Справочник.iga_ЯзыкиЧатов ГДЕ Используется");
    Выборка = Запрос.Выполнить().Выбрать();
    
    Пока Выборка.Следующий() Цикл
        УИД = Строка(Выборка.Ссылка.УникальныйИдентификатор());
        СсылкаНаСобытие = "http://1c-event/SelectLang?uid=" + УИД;
        
        // Проверяем, является ли язык текущим
        ДопКласс = "";
        HTMLБейдж = "";
        Если УИД = ТекущийУИД Тогда
            ДопКласс = " selected";
            // Добавляем плашку в правый верхний угол
            HTMLБейдж = "<div class='badge'>Текущий</div>"; 
        КонецЕсли;
        
        HTML = HTML + "<a class='lang-card" + ДопКласс + "' href='" + СсылкаНаСобытие + "'>";
        HTML = HTML + HTMLБейдж + "<span class='lang-title'>" + Выборка.Наименование + "</span></a>";
    КонецЦикла;
    
    HTML = HTML + "</div></body></html>";
    
    Возврат HTML;
	
КонецФункции
