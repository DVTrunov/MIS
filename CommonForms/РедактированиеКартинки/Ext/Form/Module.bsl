#Область РазделОписанияПеременных

&НаКлиенте
Перем ДокументСформирован;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЦветАкцента = ЦветаСтиля.ЦветАкцента;
	
	ЦветСтрокой = "rgba(0,0,0,%1)";
	
	ЗаполнитьHTML();
	ШиринаЛинии = 2;
	Непрозрачность = 10;
	РазмерТекста = 3;
	
	КартинкаИлиДвоичныеДанные = ПолучитьИзВременногоХранилища(Параметры.ДанныеКартинки.АдресВХранилище);
	Если ТипЗнч(КартинкаИлиДвоичныеДанные) = Тип("Картинка") Тогда
		ДДКартинки = КартинкаИлиДвоичныеДанные.ПолучитьДвоичныеДанные();
	ИначеЕсли ТипЗнч(КартинкаИлиДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ДДКартинки = КартинкаИлиДвоичныеДанные;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Base64Картинки = СтрШаблон("data:image/%1;base64,%2", Параметры.ДанныеКартинки.Расширение, Base64Строка(ДДКартинки));
	
	Если Параметры.Свойство("УИДФормы") Тогда
		УИДФормы = Параметры.УИДФормы;
	КонецЕсли;

	Если Параметры.Свойство("АдресРисунка") И ЗначениеЗаполнено(Параметры.АдресРисунка) Тогда
		Base64Рисунка = СтрШаблон("data:image/png;base64,%1", Base64Строка(ПолучитьИзВременногоХранилища(Параметры.АдресРисунка)));
	КонецЕсли;
	
	Если Параметры.Свойство("ШаблонПриема") Тогда
		ИдентификаторНастроек = СтрШаблон("%1:%2", Параметры.ШаблонПриема.УникальныйИдентификатор(), Параметры.ИдентификаторРисунка);
	Иначе
		Элементы.Сохранить.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	ЗаполнитьПанельНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДокументСформирован = Ложь;
	ОбновитьСтроковоеЗначениеЦвета();
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.Цвет.Ширина = 5;
		Элементы.Цвет.Высота = 2;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.HTML.Документ.defaultView.undo();
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура Вперед(Команда)
	
	Элементы.HTML.Документ.defaultView.redo();
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	Элементы.HTML.Документ.defaultView.clearCanvas();
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Элементы.HTML.Документ.defaultView.placeText();
	
	Если Элементы.HTML.Документ.defaultView.getLengthArray() = 0 Тогда
		АдресРисунка = "";
	Иначе
		Результат = Элементы.HTML.Документ.defaultView.save();
		АдресРисунка = СохранитьРисунокВХранилище(Результат, УИДФормы);
	КонецЕсли;
	
	НастройкиВХранилище(ИдентификаторНастроек, Новый Структура("Инструмент, ЦветЛинии, ШиринаЛинии, Непрозрачность, РазмерТекста", Инструмент, ЦветЛинии, ШиринаЛинии, Непрозрачность, РазмерТекста));
	Закрыть(АдресРисунка);
	
КонецПроцедуры

&НаКлиенте
Процедура Кисть(Команда)
	
	ИзменитьИнструмент(0);
	
КонецПроцедуры

&НаКлиенте
Процедура Прямая(Команда)
	
	ИзменитьИнструмент(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Ластик(Команда)
	
	ИзменитьИнструмент(2);
	
КонецПроцедуры

&НаКлиенте
Процедура Текст(Команда)
	
	ИзменитьИнструмент(3);
	
КонецПроцедуры

&НаКлиенте
Процедура Стрелка(Команда)
	
	ИзменитьИнструмент(4);
	
КонецПроцедуры

&НаКлиенте
Процедура Прямоугольник(Команда)
	
	ИзменитьИнструмент(5);
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура Цвет(Команда)
	
	Диалог = Новый ДиалогВыбораЦвета();
	ВыбранныйЦвет = Ждать Диалог.ВыбратьАсинх();
	
	Если ЗначениеЗаполнено(ВыбранныйЦвет) Тогда
		ЦветЛинии = ВыбранныйЦвет;
		ОбновитьСтроковоеЗначениеЦвета();
		ЦветПриИзменении();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РазмерКистиПриИзменении(Элемент = Неопределено)
	
	Элементы.HTML.Документ.defaultView.changeWidth(ШиринаЛинии);
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLДокументСформирован(Элемент)
	
	Попытка
		ДокументСформирован = Элементы.HTML.Документ.defaultView.Check();
	Исключение
		СИ = Новый СистемнаяИнформация;
		ТекстПредупреждения = СтрШаблон(НСтр("ru='Функционал редактирования картинок недоступен.
			|Вероятно, используемая версия платформы (%1; тип: %2) не поддерживает этот функционал.'"), СИ.ВерсияПриложения, СИ.ТипПлатформы);
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ПослеЗакрытияПредупреждения", ЭтотОбъект), ТекстПредупреждения);
		Возврат;
	КонецПопытки;
	
	Элементы.HTML.Документ.defaultView.setBackground(Base64Картинки);
	
	Если ЗначениеЗаполнено(Base64Рисунка) Тогда
		Если Элементы.HTML.Документ.defaultView.canvasIsExist() Тогда
			Элементы.HTML.Документ.defaultView.load(Base64Рисунка);
			ОбновитьДоступностьЭлементов(Истина);
		Иначе
			ПодключитьОбработчикОжидания("ЗагрузитьРисунок", 0.1, Истина);
		КонецЕсли;
	Иначе
		ОбновитьДоступностьЭлементов();
	КонецЕсли;
	
	НастроитьПараметрыРисования();
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДокументСформирован Тогда
		ОбновитьДоступностьЭлементов();
		Если Элементы.HTML.Документ.defaultView.wheelChange = Истина Тогда
			НоваяШиринаЛинии = ШиринаЛинии + Элементы.HTML.Документ.defaultView.deltaY;
			Если НоваяШиринаЛинии >= Элементы.ШиринаЛинии.МинимальноеЗначение
				И НоваяШиринаЛинии <= Элементы.ШиринаЛинии.МаксимальноеЗначение
			Тогда
				ШиринаЛинии = НоваяШиринаЛинии;
				РазмерКистиПриИзменении();
			КонецЕсли;
			НовыйРазмерТекста = РазмерТекста + Элементы.HTML.Документ.defaultView.deltaY;
			Если НовыйРазмерТекста >= Элементы.РазмерТекста.МинимальноеЗначение
				И НовыйРазмерТекста <= Элементы.РазмерТекста.МаксимальноеЗначение
			Тогда
				РазмерТекста = НовыйРазмерТекста;
				РазмерТекстаПриИзменении();
			КонецЕсли;
			Элементы.HTML.Документ.defaultView.wheelChange = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НепрозрачностьПриИзменении(Элемент)
	
	ЦветПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦветЛинииПриИзменении(Элемент)
	
	ОбновитьСтроковоеЗначениеЦвета();
	ЦветПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерТекстаПриИзменении(Элемент = Неопределено)
	
	РазмерыТекста = Новый Соответствие;
	РазмерыТекста.Вставить(1, "x-small");
	РазмерыТекста.Вставить(2, "small");
	РазмерыТекста.Вставить(3, "medium");
	РазмерыТекста.Вставить(4, "large");
	РазмерыТекста.Вставить(5, "x-large");
	РазмерыТекста.Вставить(6, "xx-large");
	РазмерыТекста.Вставить(7, "-webkit-xxx-large");
	
	Элементы.HTML.Документ.defaultView.changeFontSize(РазмерыТекста.Получить(РазмерТекста));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьИнструмент(НовыйИнструмент = Неопределено)
	
	Если НовыйИнструмент <> Неопределено Тогда
		Инструмент = НовыйИнструмент;
	КонецЕсли;
	
	УстановитьОтметкуИнструмента();
	
	Элементы.ШиринаЛинии.Видимость		= Инструмент <> 3;
	Элементы.РазмерТекста.Видимость		= Инструмент = 3;
	Элементы.Непрозрачность.Доступность	= Инструмент <> 2;
	
	Элементы.HTML.Документ.defaultView.placeText();
	Элементы.HTML.Документ.defaultView.changeTool(Инструмент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов(ЗагрузкаРисунка = Ложь)
	
	Если ЗагрузкаРисунка Тогда
		// При загрузке рисунка в массиве ещё нет ни одного элемента - элемент добавится после окончания загрузки.
		Элементы.Назад.Доступность = Истина;
		Элементы.Очистить.Доступность = Истина;
		Элементы.Вперед.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	ЕстьЭлементы = Элементы.HTML.Документ.defaultView.getLengthArray() > 0;
	Элементы.Назад.Доступность = ЕстьЭлементы;
	Элементы.Очистить.Доступность = ЕстьЭлементы;
	Элементы.Вперед.Доступность = Элементы.HTML.Документ.defaultView.getLengthRedoArray() > 0;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьHTML()
	
	HTML = 
		"<html>
		|	<head>
		|		<meta http-equiv='X-UA-Compatible' content='IE=edge'>
		|		<style>
		|			canvas {
		|				border: 1px solid #7B899B;
		|			}
		|		</style>
		|		<script type='text/javascript'>
		|			var canvas;
		|			var context;
		|			var canvasPath;
		|			var contextPath;
		|			var canvasCursor;
		|			var contextCursor;
		|			var canvasTemp;
		|			var contextTemp;
		|			var currentTextarea;
		|			
		|			var deltaY;
		|			var wheelChange;
		|			
		|			var startX;
		|			var startY;
		|			
		|			deltaY = 0;
		|			wheelChange = false;
		|			
		|			// 0 = кисть; 1 = прямая; 2 = ластик; 3 = текст; 4 = стрелка; 5 = прямоугольник
		|			let tool = 0;
		|			
		|			let drawColor = 'rgba(0,0,0,1)';
		|			let drawWidth = 2;
		|			let isDrawing = false;
		|			let restoreArray = [];
		|			let pathArray = [];
		|			let backgroundAlreadyLoaded = false;
		|			let fontSize = 'medium';
		|			let redoArray = [];
		|			
		|			var imageBackground = new Image();
		|			imageBackground.onload = imgOnload;
		|			
		|			// Работа с инструментами
		|			function changeTool(value) {
		|				tool = value;
		|			}
		|			
		|			function changeColor(colorValue) {
		|				drawColor = colorValue;
		|				if (currentTextarea) {
		|					currentTextarea.style.color = drawColor;
		|				}
		|			}
		|			
		|			function changeWidth(widthValue) {
		|				drawWidth = widthValue;
		|			}
		|			
		|			function changeFontSize(fontSizeValue) {
		|				fontSize = fontSizeValue;
		|				if (currentTextarea) {
		|					currentTextarea.style['font-size'] = fontSize;
		|				}
		|			}
		|			
		|			// Обработчики функций, вызываемых из 1С
		|			function Check() {
		|				return true;
		|			}
		|			
		|			function setBackground(src) {
		|				imageBackground.src = src;
		|			}
		|			
		|			function canvasIsExist() {
		|				return canvas != null;
		|			}
		|			
		|			function getLengthArray() {
		|				return restoreArray.length;
		|			}
		|			
		|			function getLengthRedoArray() {
		|				return redoArray.length;
		|			}
		|			
		|			function undo() {
		|				if (currentTextarea) {
		|					currentTextarea.parentNode.removeChild(currentTextarea);
		|					currentTextarea = null;
		|				} else {
		|					let amount = restoreArray.length;
		|					if (amount > 0) {
		|						lastEl = restoreArray.pop();
		|						redoArray.push(lastEl);
		|						if (amount > 1) {
		|							context.putImageData(restoreArray[restoreArray.length-1], 0, 0);
		|						} else {
		|							context.clearRect(0, 0, canvas.width, canvas.height);
		|						}
		|					}
		|				}
		|			}
		|			
		|			function redo() {
		|				if (redoArray.length > 0) {
		|					lastEl = redoArray.pop();
		|					restoreArray.push(lastEl);
		|					context.putImageData(restoreArray[restoreArray.length-1], 0, 0);
		|				}
		|				elementAvailabilityCheck();
		|			}
		|			
		|			function save() {
		|				return canvas.toDataURL('image/png', 0.1);
		|			}
		|			
		|			function placeText() {
		|				if (currentTextarea) {
		|					if (currentTextarea.value != '') {
		|						context.beginPath();
		|						let computedStyle = getComputedStyle(currentTextarea);
		|						let strLineHeight = getLineHeight(computedStyle);
		|						context.font = computedStyle.getPropertyValue('font');
		|						context.fillStyle = computedStyle.getPropertyValue('color');
		|						let rows = currentTextarea.value.split(/\r\n|\r|\n/g);
		|						let i = 1;
		|						offsets = getOffsetByFontSize(fontSize);
		|						
		|						rows.forEach(strElem => {
		|							context.fillText(strElem, parseInt(currentTextarea.style.left, 10) + offsets.hOffset, parseInt(currentTextarea.style.top, 10) - offsets.vOffset + i*strLineHeight)
		|							i += 1;
		|						});
		|						context.stroke();
		|						context.closePath();
		|						restoreArray.push(context.getImageData(0, 0, canvas.width, canvas.height));
		|					}
		|					currentTextarea.parentNode.removeChild(currentTextarea);
		|					currentTextarea = null;
		|				}
		|			}
		|			
		|			function clearCanvas() {
		|				context.clearRect(0, 0, canvas.width, canvas.height);
		|				if (restoreArray.length > 0) {
		|					restoreArray.push(context.getImageData(0, 0, canvas.width, canvas.height));
		|				};
		|				redoArray = [];
		|				if (currentTextarea) {
		|					currentTextarea.parentNode.removeChild(currentTextarea);
		|					currentTextarea = null;
		|				}
		|			}
		|			
		|			function load(pic) {
		|				clearCanvas();
		|				var imagePic = new Image();
		|				imagePic.src = pic;
		|				imagePic.onload = imagePicOnload;
		|			}
		|			
		|			// Обработчики событий мыши
		|			function mouseDown(event) {
		|				redoArray = [];
		|				context.globalCompositeOperation = (tool == 2) ? 'destination-out' : 'source-over';
		|				switch(tool) {
		|					case 0:
		|					case 1:
		|					case 2:
		|					case 4:
		|					case 5:
		|						startDrawing(event.clientX, event.clientY);
		|						event.preventDefault();
		|						break;
		|					case 3:
		|						placeText();
		|						break;
		|				}
		|				elementAvailabilityCheck();
		|			}
		|			
		|			function mouseMove(event) {
		|				cursorUpdate(tool != 3);
		|				switch(tool) {
		|					case 0:
		|					case 1:
		|					case 2:
		|					case 4:
		|					case 5:
		|						draw(event.clientX, event.clientY);
		|						event.preventDefault();
		|						break;
		|				}
		|			}
		|			
		|			function mouseUp(event) {
		|				switch(tool) {
		|					case 0:
		|					case 1:
		|					case 2:
		|					case 4:
		|					case 5:
		|						stopDrawing(event.clientX, event.clientY);
		|						event.preventDefault();
		|						break;
		|					case 3:
		|						if (!currentTextarea) {
		|							startTyping(event.clientX, event.clientY);
		|						}
		|						break;
		|				}
		|				elementAvailabilityCheck();
		|			}
		|			
		|			function mouseOut(event) {
		|				cursorUpdate(false);
		|				switch(tool) {
		|					case 0:
		|					case 1:
		|					case 2:
		|					case 4:
		|					case 5:
		|						stopDrawing(event);
		|						break;
		|				}
		|				elementAvailabilityCheck();
		|			}
		|			
		|			function mouseWheel(event) {
		|				if ((tool == 2 && isDrawing) || event.deltaY == 0) {
		|					return;
		|				}
		|				wheelChange = true;
		|				deltaY = event.deltaY > 0 ? -1 : 1;
		|				document.getElementById('canvasBG').click();
		|				cursorUpdate(tool != 3);
		|				if (tool != 2 && isDrawing) {
		|					if (tool == 0 && pathArray.length < 2) {
		|						startDrawing(event.clientX, event.clientY);
		|					} else {
		|						contextPath.lineWidth	= drawWidth;
		|						context.lineWidth		= drawWidth;
		|						draw(event.clientX, event.clientY);
		|					}
		|				}
		|			}
		|			
		|			// Служебные функции
		|			function cursorUpdate(cursorOn) {
		|				contextCursor.clearRect(0, 0, canvasCursor.width, canvasCursor.height);
		|				if (cursorOn) {
		|					contextCursor.beginPath();
		|					var rectCursor = canvasCursor.getBoundingClientRect();
		|					contextCursor.arc(event.clientX - rectCursor.left, event.clientY - rectCursor.top, drawWidth/2, 0, 2 * Math.PI);
		|					contextCursor.stroke();
		|				}
		|			}
		|			
		|			function startDrawing(clientX, clientY) {
		|				
		|				isDrawing = true;
		|				currentColor			= (tool == 2) ? 'rgba(0,0,0,1)' : drawColor; // Ластик всегда жёсткий и непрозрачный
		|				contextPath.strokeStyle	= currentColor;
		|				contextPath.fillStyle	= currentColor;
		|				contextPath.lineWidth	= drawWidth;
		|				context.strokeStyle		= currentColor;
		|				context.fillStyle		= currentColor;
		|				context.lineWidth		= drawWidth;
		|				
		|				switch(tool) {
		|					case 2:
		|						var currentContext = context;
		|						var currentCanvas = canvas;
		|						var rect = currentCanvas.getBoundingClientRect();
		|						currentContext.beginPath();
		|						break;
		|					default:
		|						var currentContext = contextPath;
		|						var currentCanvas = canvasPath;
		|						var rect = currentCanvas.getBoundingClientRect();
		|						currentContext.clearRect(0, 0, currentCanvas.width, currentCanvas.height);
		|						break;
		|				}
		|				
		|				startX = clientX - rect.left;
		|				startY = clientY - rect.top;
		|				currentContext.moveTo(startX, startY);
		|				
		|				currentContext.beginPath();
		|				
		|				brushType = tool == 0 || tool == 2;
		|				if (brushType) {
		|					currentContext.arc(startX, startY, 0.01, 0, 2 * Math.PI);
		|					currentContext.stroke();
		|				}
		|				
		|				pathArray = [];
		|				pathArray.push([startX, startY]);
		|			}
		|			
		|			function draw(clientX, clientY) {
		|				if (isDrawing) {
		|					
		|					var rect = canvasPath.getBoundingClientRect();
		|					endX = clientX - rect.left;
		|					endY = clientY - rect.top;
		|					
		|					switch (tool) {
		|						case 0:
		|							contextPath.closePath();
		|							contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|							contextPath.beginPath();
		|							pathArray.push([endX, endY]);
		|							contextPath.moveTo.apply(contextPath, pathArray[0]);
		|							pathArray.forEach(element => contextPath.lineTo(...element));
		|							contextPath.stroke();
		|							break;
		|						case 1:
		|							contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|							contextPath.beginPath();
		|							contextPath.moveTo(startX, startY);
		|							contextPath.lineTo(endX, endY);
		|							contextPath.stroke();
		|							break;
		|						case 4:
		|							contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|							drawArrow(contextPath, startX, startY, endX, endY);
		|							break;
		|						case 2:
		|							var rect = canvas.getBoundingClientRect();
		|							context.lineTo(endX, endY);
		|							context.stroke();
		|							break;
		|						case 5:
		|							contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|							drawRectangle(contextPath, startX, startY, endX, endY);
		|							break;
		|					}
		|				}
		|			}
		|			
		|			function stopDrawing(clientX, clientY) {
		|				if (isDrawing) {
		|					isDrawing = false;
		|					
		|					if (tool == 2){
		|						context.closePath();
		|					} else if (pathArray.length > 0) {
		|						var rect = canvasPath.getBoundingClientRect();
		|						contextPath.closePath();
		|						contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|						startX = pathArray[0][0];
		|						startY = pathArray[0][1];
		|						endX = clientX - rect.left;
		|						endY = clientY - rect.left;
		|						
		|						brushType = tool == 0 || tool == 2;
		|						
		|						if (!brushType && startX == endX && startY == endY) {
		|							pathArray = [];
		|							return;
		|						}
		|						
		|						context.beginPath();
		|						if (brushType) {
		|							if (pathArray.length == 1) {
		|								// Ветка - костыль, т.к. по нормальному 1С точку ставит непредсказуемо
		|								//  (гарантированно через moveTo → lineTo единичная точка поставится почему-то только если масштаб на максимум выкрутить)
		|								context.moveTo(startX, startY);
		|								context.arc(startX, startY, 0.01, 0, 2 * Math.PI);
		|							} else {
		|								pathArray.push([endX, endY]);
		|								context.moveTo(startX, startY);
		|								pathArray.forEach(element => context.lineTo(...element));
		|							}
		|							context.stroke();
		|							context.closePath();
		|						} else if (tool == 1) {
		|							context.moveTo(startX, startY);
		|							context.lineTo(endX, endY);
		|							context.stroke();
		|							context.closePath();
		|						} else if (tool == 4) {
		|							drawArrow(context, startX, startY, endX, endY);
		|						} else if (tool == 5){
		|							drawRectangle(context, startX, startY, endX, endY);
		|						}
		|					}
		|					restoreArray.push(context.getImageData(0, 0, canvas.width, canvas.height));
		|					pathArray = [];
		|				}
		|			}
		|			
		|			function drawArrow(targetContext, fromX, fromY, toX, toY) {
		|				
		|				// Длина отрезка
		|				const length = Math.sqrt((toX - fromX) ** 2 + (toY - fromY) ** 2);
		|				let angle = Math.atan2(toY - fromY, toX - fromX) - Math.PI / 2;
		|				
		|				// Начальные координаты
		|				let p0 = coordinates(fromX, fromY);
		|				
		|				// Вершины начала отрезка (прямоугольника)
		|				let p1 = coordinates(fromX + targetContext.lineWidth / 2, fromY);
		|				let p2 = coordinates(fromX - targetContext.lineWidth / 2, fromY);
		|				
		|				// Вершины конца отрезка (прилегающего к треугольнику)
		|				let p3 = coordinates(fromX + targetContext.lineWidth / 2, fromY + length - targetContext.lineWidth*5);
		|				let p4 = coordinates(fromX - targetContext.lineWidth / 2, fromY + length - targetContext.lineWidth*5);
		|				
		|				// Нижние вершины треугольника
		|				let p5 = coordinates(fromX + targetContext.lineWidth * 1.5, fromY + length - targetContext.lineWidth*5);
		|				let p6 = coordinates(fromX - targetContext.lineWidth * 1.5, fromY + length - targetContext.lineWidth*5);
		|				
		|				// Верхняя вершина треугольника
		|				let p7 = coordinates(fromX, fromY + length);
		|				
		|				// Определяем точки повёрнутой фигуры
		|				p1 = transform(p1, angle, p0);
		|				p2 = transform(p2, angle, p0);
		|				p3 = transform(p3, angle, p0);
		|				p4 = transform(p4, angle, p0);
		|				p5 = transform(p5, angle, p0);
		|				p6 = transform(p6, angle, p0)
		|				p7 = transform(p7, angle, p0);
		|				
		|				// Координаты начала треугольника
		|				triangleBottomX = (p5.x + p6.x) / 2;
		|				triangleBottomY = (p5.y + p6.y) / 2;
		|				
		|				lengthFromStartToTriangle = Math.sqrt((triangleBottomX - fromX)**2 + (triangleBottomY - fromY)**2);
		|				lengthFromTriangleToEnd = Math.sqrt((toX - triangleBottomX)**2 + (toY - triangleBottomY)**2)
		|				sumLength = lengthFromStartToTriangle + lengthFromTriangleToEnd;
		|				
		|				// Проверяем, лежит ли точка начала треугольника на отрезке. Если да - отрисовываем отрезок с треугольником, если нет - рисуем только треугольник
		|				if (sumLength + 0.1 >= length && length >= sumLength - 0.1) {
		|					targetContext.beginPath();
		|					targetContext.moveTo(p1.x, p1.y);
		|					targetContext.lineTo(p3.x, p3.y);
		|					targetContext.lineTo(p5.x, p5.y);
		|					targetContext.lineTo(p7.x, p7.y);
		|					targetContext.lineTo(p6.x, p6.y);
		|					targetContext.lineTo(p4.x, p4.y);
		|					targetContext.lineTo(p2.x, p2.y);
		|					targetContext.lineTo(p1.x, p1.y);
		|					targetContext.closePath();
		|					// Добавляем закругление начала отрезка
		|					targetContext.arc(fromX, fromY, targetContext.lineWidth / 2, angle - Math.PI, angle);
		|					targetContext.fill();
		|				} else {
		|					targetContext.beginPath();
		|					targetContext.moveTo(p5.x, p5.y);
		|					targetContext.lineTo(p7.x, p7.y);
		|					targetContext.lineTo(p6.x, p6.y);
		|					targetContext.closePath();
		|					targetContext.fill();
		|				}
		|			}
		|			
		|			function transform(xyPoint, angle, xyFrom) {
		|				// Установить x и y относительно fromX и fromY для последующего вращения
		|				const rel_x = xyPoint.x - xyFrom.x;
		|				const rel_y = xyPoint.y - xyFrom.y;
		|				
		|				// Вычисление смещения точек с учетом поворотом
		|				const new_rel_x = Math.cos(angle) * rel_x - Math.sin(angle) * rel_y;
		|				const new_rel_y = Math.sin(angle) * rel_x + Math.cos(angle) * rel_y;
		|				
		|				return coordinates(xyFrom.x + new_rel_x, xyFrom.y + new_rel_y);
		|			}
		|			
		|			function coordinates(X, Y) {
		|				return {x: X, y: Y}
		|			}
		|			
		|			function drawRectangle(targetContext, fromX, fromY, toX, toY) {
		|				targetContext.beginPath();
		|				targetContext.lineTo(fromX, fromY);
		|				targetContext.lineTo(fromX, toY);
		|				targetContext.lineTo(toX, toY);
		|				targetContext.lineTo(toX, fromY);
		|				targetContext.lineTo(fromX, fromY);
		|				targetContext.closePath();
		|				targetContext.stroke();
		|			}
		|			
		|			function startTyping(clientX, clientY) {
		|				
		|				var rect = canvas.getBoundingClientRect();
		|				startX = clientX - rect.left;
		|				startY = clientY - rect.top;
		|				currentTextarea = document.createElement('textarea');
		|				
		|				currentTextarea.style['position']	= 'absolute';
		|				currentTextarea.style['left']		= startX;
		|				currentTextarea.style['top']		= startY;
		|				currentTextarea.style['background']	= 'none';
		|				currentTextarea.style['border']		= '1px dashed #ccc';
		|				currentTextarea.style['outline']	= 'none';
		|				currentTextarea.style['resize']		= 'none';
		|				currentTextarea.style['z-index']	= 4;
		|				currentTextarea.style['cursor']		= 'grab';
		|				currentTextarea.style['color']		= drawColor;
		|				currentTextarea.style['font-size']	= fontSize;
		|				
		|				currentTextarea.cols = 1;
		|				currentTextarea.rows = 1;
		|				currentTextarea.spellcheck = false;
		|				currentTextarea.addEventListener('input', (event) => {
		|					rows = currentTextarea.value.split(/\r\n|\r|\n/g);
		|					currentTextarea.rows = Math.max(1, rows.length);
		|					currentTextarea.cols = rows.reduce((maxLength, currentStr) => Math.max(maxLength, currentStr.length), 1);
		|				});
		|				
		|				currentTextarea.addEventListener('mousedown',	textareaMouseDown);
		|				currentTextarea.addEventListener('touchstart',	textareaMouseDown);
		|				currentTextarea.addEventListener('wheel',		mouseWheel)
		|				
		|				document.body.appendChild(currentTextarea);
		|				currentTextarea.focus();
		|			}
		|			
		|			function textareaMouseDown(event) {
		|				var x = currentTextarea.offsetLeft - event.clientX,
		|					y = currentTextarea.offsetTop - event.clientY;
		|				
		|				function drag(event) {
		|					currentTextarea.style.left	= event.clientX + x + 'px';
		|					currentTextarea.style.top	= event.clientY + y + 'px';
		|				}
		|				function stopDrag() {
		|					document.removeEventListener('mousemove',	drag);
		|					document.removeEventListener('mouseup',		stopDrag);
		|					document.removeEventListener('touchend',	stopDrag);
		|				}
		|				document.addEventListener('mousemove',	drag);
		|				document.addEventListener('mouseup',	stopDrag);
		|				document.addEventListener('touchend',	stopDrag);
		|			}
		|			
		|			function getLineHeight(computedStyle) {
		|				let lineHeight = computedStyle.getPropertyValue('line-height');
		|				let lineheight;
		|				
		|				if (lineHeight === 'normal') {
		|					let fontSize = computedStyle.getPropertyValue('font-size');
		|					lineheight = parseFloat(fontSize) * 1.2;
		|				} else {
		|					lineheight = parseFloat(lineHeight);
		|				}
		|				
		|				return lineheight;
		|			}
		|			
		|			function getOffsetByFontSize(fontSize) {
		|				
		|				switch(fontSize) {
		|					case 'small':
		|					case 'x-small':
		|					case 'x-large':
		|						vOffset = 1;
		|						break;
		|					case 'xx-large':
		|						vOffset = 3;
		|						break;
		|					case 'xxx-large':
		|					case '-webkit-xxx-large':
		|						vOffset = 7;
		|						break;
		|					default:
		|						vOffset = 0;
		|						break;
		|				}
		|				switch(fontSize) {
		|					case 'small':
		|					case 'x-small':
		|						hOffset = 2;
		|						break;
		|					default:
		|						hOffset = 4;
		|						break;
		|				}
		|				
		|				return {
		|					vOffset: vOffset,
		|					hOffset: hOffset
		|				};
		|			}
		|			
		|			function imagePicOnload() {
		|				context.drawImage(this, 0, 0);
		|				restoreArray.push(context.getImageData(0, 0, canvas.width, canvas.height));
		|			}
		|			
		|			function imgOnload() {
		|				canvasBG = document.getElementById('canvasBG');
		|				contextBG = canvasBG.getContext('2d');
		|				canvasBG.width	= this.naturalWidth;
		|				canvasBG.height	= this.naturalHeight;
		|				contextBG.drawImage(this, 0, 0);
		|				
		|				canvas = document.getElementById('canvasDrawLayer');
		|				canvas.width	= this.naturalWidth;
		|				canvas.height	= this.naturalHeight;
		|				context = canvas.getContext('2d');
		|				context.lineCap		= 'round';
		|				context.lineJoin	= 'round';
		|				
		|				canvasPath = document.getElementById('canvasPathDrawLayer');
		|				canvasPath.width	= this.naturalWidth;
		|				canvasPath.height	= this.naturalHeight;
		|				contextPath = canvasPath.getContext('2d');
		|				contextPath.lineCap		= 'round';
		|				contextPath.lineJoin	= 'round';
		|				
		|				canvasCursor = document.getElementById('canvasCursor');
		|				canvasCursor.width = this.naturalWidth;
		|				canvasCursor.height = this.naturalHeight;
		|				contextCursor = canvasCursor.getContext('2d');
		|				contextCursor.lineCap		= 'round';
		|				contextCursor.lineJoin		= 'round';
		|				contextCursor.strokeStyle	= 'black';
		|				
		|				canvasCursor.addEventListener('mousedown',	mouseDown,	false);
		|				canvasCursor.addEventListener('touchstart',	mouseDown,	false);
		|				canvasCursor.addEventListener('mousemove',	mouseMove,	false);
		|				canvasCursor.addEventListener('touchmove',	mouseMove,	false);
		|				canvasCursor.addEventListener('mouseup',	mouseUp,	false);
		|				canvasCursor.addEventListener('touchend',	mouseUp,	false);
		|				canvasCursor.addEventListener('mouseout',	mouseOut,	false);
		|				canvasCursor.addEventListener('wheel',		mouseWheel,	false)
		|			}
		|			
		|			function elementAvailabilityCheck() {
		|				document.getElementById('canvasBG').click();
		|			}
		|		</script>
		|	</head>
		|	<body>
		|		<div style='position: static'>
		|			<canvas style='position: absolute; left: 0; top: 0; z-index: 0;' id='canvasBG'>
		|				<img id='imageBackground'></img>
		|			</canvas>
		|			<canvas style='position: absolute; left: 0; top: 0; z-index: 1;' id='canvasDrawLayer'></canvas>
		|			<canvas style='position: absolute; left: 0; top: 0; z-index: 2;' id='canvasPathDrawLayer'></canvas>
		|			<canvas style='position: absolute; left: 0; top: 0; z-index: 3;' id='canvasCursor'></canvas>
		|		</div>
		|	</body>
		|</html>";
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СохранитьРисунокВХранилище(Результат, УИДФормы)
	
	ДДРезультат = Base64Значение(СтрРазделить(Результат,",")[1]);
	Возврат ПоместитьВоВременноеХранилище(ДДРезультат, УИДФормы);
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьРисунок()
	
	// Может потребоваться некоторое время для отрисовки картинки.
	// Рисунок можно помещать только тогда, когда картинка уже отрисована, т.к. canvas для рисунка формируется при формировании canvas для картинки.
	Если Элементы.HTML.Документ.defaultView.canvasIsExist() Тогда
		Элементы.HTML.Документ.defaultView.load(Base64Рисунка);
		ОтключитьОбработчикОжидания("ЗагрузитьРисунок");
		ОбновитьДоступностьЭлементов(Истина);
	Иначе
		ПодключитьОбработчикОжидания("ЗагрузитьРисунок", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПанельНастроек()
	
	НастройкиРисункаШаблона = НастройкиИзХранилища(ИдентификаторНастроек);
	Если НастройкиРисункаШаблона <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиРисункаШаблона);
		Если НастройкиРисункаШаблона.Свойство("Цвет") Тогда
			ЦветСтрокой = НастройкиРисункаШаблона.Цвет;
			
			Попытка
				ЧастиЦвета = СтрРазделить(СтрЗаменить(ЦветСтрокой, "rgba(", ""), ",", Ложь);
				ЦветЛинии = Новый Цвет(СокрЛП(ЧастиЦвета[0]), СокрЛП(ЧастиЦвета[1]), СокрЛП(ЧастиЦвета[2]));
			Исключение
				ЦветЛинии = Новый Цвет(0,0,0);
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыРисования()
	
	ИзменитьИнструмент();
	ЦветПриИзменении();
	РазмерКистиПриИзменении();
	РазмерТекстаПриИзменении();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НастройкиВХранилище(КлючОбъекта, Настройки)
	
	ХранилищеОбщихНастроек.Сохранить(Строка(КлючОбъекта), , Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиИзХранилища(КлючОбъекта)
	
	Возврат ХранилищеОбщихНастроек.Загрузить(Строка(КлючОбъекта));
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияПредупреждения(ДополнительныеПараметры) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтроковоеЗначениеЦвета()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СтроковыеФункцииКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.23.0") >= 0 Тогда
		АбсолютныйЦвет = ЦветЛинии.ПолучитьАбсолютный();
	Иначе
		АбсолютныйЦвет = ПреобразоватьЦветВАбсолютный(ЦветЛинии);
	КонецЕсли;
	
	Элементы.Цвет.ЦветФона = Новый Цвет(АбсолютныйЦвет.Красный, АбсолютныйЦвет.Зеленый, АбсолютныйЦвет.Синий);
	
	ЦветСтрокой = СтрШаблон("rgba(%1,%2,%3,%%1)", АбсолютныйЦвет.Красный, АбсолютныйЦвет.Зеленый, АбсолютныйЦвет.Синий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПреобразоватьЦветВАбсолютный(ЦветЛинии)
	
	Если ЦветЛинии.Вид = ВидЦвета.Абсолютный Тогда
		Возврат ЦветЛинии;
	КонецЕсли;
	
	ФорматированныйДокумент = Новый ФорматированныйДокумент;
	ФорматированныйДокумент.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока("Цвет", , ЦветЛинии));
	
	АбсолютныйЦвет = ФорматированныйДокумент.Элементы[0].Элементы[0].ЦветТекста;
	Если АбсолютныйЦвет.Вид = ВидЦвета.Абсолютный Тогда
		Возврат АбсолютныйЦвет;
	КонецЕсли;
	
	ТекстHTML = "";
	Вложения = Новый Структура;
	ФорматированныйДокумент.ПолучитьHTML(ТекстHTML, Вложения);
	ФорматированныйДокумент.УстановитьHTML(ТекстHTML, Вложения);
	АбсолютныйЦвет = ФорматированныйДокумент.Элементы[0].Элементы[0].ЦветТекста;
	Если АбсолютныйЦвет.Вид = ВидЦвета.Абсолютный Тогда
		Возврат АбсолютныйЦвет;
	КонецЕсли;
	
	Возврат Новый Цвет(0,0,0);
	
КонецФункции

&НаКлиенте
Процедура ЦветПриИзменении()
	
	Элементы.HTML.Документ.defaultView.changeColor(СтрШаблон(ЦветСтрокой, Формат(Непрозрачность / 10, "ЧДЦ=1; ЧРД=.; ЧГ=0")));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтметкуИнструмента()
	
	ЭлементыИнструментов = Новый Массив;
	ЭлементыИнструментов.Добавить(Новый Структура("Инструмент, Элемент", 0, Элементы.Кисть));
	ЭлементыИнструментов.Добавить(Новый Структура("Инструмент, Элемент", 1, Элементы.Прямая));
	ЭлементыИнструментов.Добавить(Новый Структура("Инструмент, Элемент", 2, Элементы.Ластик));
	ЭлементыИнструментов.Добавить(Новый Структура("Инструмент, Элемент", 3, Элементы.Текст));
	ЭлементыИнструментов.Добавить(Новый Структура("Инструмент, Элемент", 4, Элементы.Стрелка));
	ЭлементыИнструментов.Добавить(Новый Структура("Инструмент, Элемент", 5, Элементы.Прямоугольник));
	
	Для Каждого ЭлементИнструмента Из ЭлементыИнструментов Цикл
		ТекущийИнструмент = ЭлементИнструмента.Инструмент = Инструмент;
		ЭлементИнструмента.Элемент.ЦветФона = ?(ТекущийИнструмент, WebЦвета.СеребристоСерый, Новый Цвет());
		ЭлементИнструмента.Элемент.Шрифт = ?(ТекущийИнструмент, Новый Шрифт(,,Истина), Новый Шрифт());
		Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
			ЭлементИнструмента.Элемент.ЦветРамки = ?(ТекущийИнструмент, ЦветАкцента, Новый Цвет());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти