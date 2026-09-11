#Область ПрограммныйИнтерфейс

#Область ЗагрузкаИзЕГИСЗ

// Возвращает идентификатор основного классификатора источника на сайте росминздрава.
// 
// Возвращаемое значение:
//   - Строка
//
Функция ПолучитьOIDСправочника() Экспорт
	Возврат "1.2.643.5.1.13.13.99.2.114";
КонецФункции

// Описывает соответствие между именем реквизита в классификаторе и его именем в базе 1С.
// 
// Возвращаемое значение:
//   - Соответствие.
//
Функция ПолучитьСопоставленийРеквизитовИXMLСправочникаЕГИСЗ() Экспорт
	
	Сопоставление = Новый Соответствие;
	
	//2) depart_oid, OID структурного подразделения, Строковое, Обязательное;
	Сопоставление.Вставить("DEPART_OID", "OIDСтруктурногоПодразделения");
	//6) depart_name, Наименование структурного подразделения, Строковое;
	Сопоставление.Вставить("DEPART_NAME", "Наименование");
	
	Возврат Сопоставление;

КонецФункции

// Возвращает массив структур, ключ которой - имя реквизита справочника, а значение - имя поля таблицы актуальных в общей форме загрузки.
// 
// Возвращаемое значение:
//   - Массив
//
Функция ПолучитьЗагружаемыеПоляЕГИСЗ() Экспорт
	
	Поля = Новый Структура;
	Поля.Вставить("Наименование","Наименование");
	Поля.Вставить("ПолноеНаименование","Наименование");
	Поля.Вставить("OIDСтруктурногоПодразделения","OIDСтруктурногоПодразделения");
	Поля.Вставить("УИДЕГИСЗ", "УИДЕГИСЗ");
		
	Возврат Поля;
	
КонецФункции

// Дополнительные атрибуты для загрузки из классификатора ФР НСИ ЕГИСЗ.
// 
// Возвращаемое значение:
//  Соответствие - дополнительные атрибуты. 
//
Функция ПолучитьДополнительныеАтрибуты() Экспорт
	
	Поля = Новый Соответствие;
	
	//1) mo_oid, OID медицинской организации, Строковое;
	Поля.Вставить("mo_oid", "mo_oid");
	//3) depart_create_date, Дата создания записи о структурном подразделении, Строковое;
	Поля.Вставить("depart_create_date", "depart_create_date");
	//4) depart_modify_date, Дата изменения записи о структурном подразделении, Строковое;
	Поля.Вставить("depart_modify_date", "depart_modify_date");
	//5) depart_liquidation_date, Дата ликвидации структурного подразделения, Строковое;
	Поля.Вставить("depart_liquidation_date", "depart_liquidation_date");
	//7) depart_type_id, Идентификатор типа структурного подразделения, Строковое;
	Поля.Вставить("depart_type_id", "depart_type_id");
	//8) depart_type_name, Тип структурного подразделения, Строковое;
	Поля.Вставить("depart_type_name", "depart_type_name");
	//9) depart_kind_id, Идентификатор вида структурного подразделения, Целочисленное;
	Поля.Вставить("depart_kind_id", "depart_kind_id");
	//10) depart_kind_name, Вид структурного подразделения, Строковое;
	Поля.Вставить("depart_kind_name", "depart_kind_name");
	//11) separate_depart_boolean, Признак обособленности структурного подразделения, Строковое;
	Поля.Вставить("separate_depart_boolean", "separate_depart_boolean");
	//12) separate_depart_text, Обособленное структурное подразделение, Строковое;
	Поля.Вставить("separate_depart_text", "separate_depart_text");
	//13) building_id, Идентификатор здания, Целочисленное;
	Поля.Вставить("building_id", "building_id");
	//14) building_create_date, Дата создания записи о здании, Строковое;
	Поля.Вставить("building_create_date", "building_create_date");
	//15) building_modify_date, Дата изменения записи о здании, Строковое;
	Поля.Вставить("building_modify_date", "building_modify_date");
	//16) building_name, Наименование здания, Строковое;
	Поля.Вставить("building_name", "building_name");
	//17) building_build_year, Год постройки, Целочисленное;
	Поля.Вставить("building_build_year", "building_build_year");
	//18) building_floor_count, Этажность, Целочисленное;
	Поля.Вставить("building_floor_count", "building_floor_count");
	//19) building_has_trouble, Признано аварийным, Строковое;
	Поля.Вставить("building_has_trouble", "building_has_trouble");
	//20) building_address_post_index, Почтовый индекс, Целочисленное;
	Поля.Вставить("building_address_post_index", "building_address_post_index");
	//21) building_address_cadastral_number, Кадастровый номер, Строковое;
	Поля.Вставить("building_address_cadastral_number", "building_address_cadastral_number");
	//22) building_address_latitude, Широта, Строковое;
	Поля.Вставить("building_address_latitude", "building_address_latitude");
	//23) building_address_longtitude, Долгота, Строковое;
	Поля.Вставить("building_address_longtitude", "building_address_longtitude");
	//24) building_address_region_id, Код региона, Целочисленное;
	Поля.Вставить("building_address_region_id", "building_address_region_id");
	//25) building_address_region_name, Наименование региона, Строковое;
	Поля.Вставить("building_address_region_name", "building_address_region_name");
	//26) building_address_aoid_area, Идентификатор населенного пункта, Строковое;
	Поля.Вставить("building_address_aoid_area", "building_address_aoid_area");
	//27) building_address_aoid_street, Идентификатор улицы, Строковое;
	Поля.Вставить("building_address_aoid_street", "building_address_aoid_street");
	//28) building_address_houseid, Идентификатор дома, Строковое;
	Поля.Вставить("building_address_houseid", "building_address_houseid");
	//29) building_address_prefix_area, Префикс населенного пункта, Строковое;
	Поля.Вставить("building_address_prefix_area", "building_address_prefix_area");
	//30) building_address_area_name, Наименование населенного пункта, Строковое;
	Поля.Вставить("building_address_area_name", "building_address_area_name");
	//31) building_address_prefix_street, Префикс улицы, Строковое;
	Поля.Вставить("building_address_prefix_street", "building_address_prefix_street");
	//32) building_address_street_name, Наименование улицы, Строковое;
	Поля.Вставить("building_address_street_name", "building_address_street_name");
	//33) building_address_house, Номер дома, Строковое;
	Поля.Вставить("building_address_house", "building_address_house");
	//34) building_address_building, Номер строения, Строковое;
	Поля.Вставить("building_address_building", "building_address_building");
	//35) building_address_struct, Номер корпуса, Строковое;
	Поля.Вставить("building_address_struct", "building_address_struct");
	//36) building_address_fias_version, Версия ФИАС, Строковое;
	Поля.Вставить("building_address_fias_version", "building_address_fias_version");
	//37) ambulatory_visit_per_shift, Подразделение с типом "Амбулаторный". Плановое число посещений в смену, Целочисленное;
	Поля.Вставить("ambulatory_visit_per_shift", "ambulatory_visit_per_shift");
	//38) ambulatory_patient_attached, Подразделение с типом "Амбулаторный". Прикреплено жителей всего, Целочисленное;
	Поля.Вставить("ambulatory_patient_attached", "ambulatory_patient_attached");
	//39) ambulatory_child_attached, Подразделение с типом "Амбулаторный". Из них детей до 17 лет, Целочисленное;
	Поля.Вставить("ambulatory_child_attached", "ambulatory_child_attached");
	//40) ambulatory_visit_home, Подразделение с типом "Амбулаторный". Прием на дому, Строковое;
	Поля.Вставить("ambulatory_visit_home", "ambulatory_visit_home");
	//41) hospital_mode_id, Подразделение с типом "Стационарный". Идентификатор режима работы, Строковое;
	Поля.Вставить("hospital_mode_id", "hospital_mode_id");
	//42) hospital_mode_name, Подразделение с типом "Стационарный". Режим работы, Строковое;
	Поля.Вставить("hospital_mode_name", "hospital_mode_name");
	//43) hospital_ambulance_boolean, Подразделение с типом "Стационарный". Признак приема по скорой, Строковое;
	Поля.Вставить("hospital_ambulance_boolean", "hospital_ambulance_boolean");
	//44) hospital_ambulance_text, Подразделение с типом "Стационарный". Прием по скорой, Строковое;
	Поля.Вставить("hospital_ambulance_text", "hospital_ambulance_text");
	//45) hospital_home_bed_count, Подразделение с типом "Стационарный". Количество коек, Строковое;
	Поля.Вставить("hospital_home_bed_count", "hospital_home_bed_count");
	//46) hospital_home_building_id, Идентификатор здания (Стационар на дому), Целочисленное;
	Поля.Вставить("hospital_home_building_id", "hospital_home_building_id");
	//47) hospital_home_building_create_date, Дата создания записи о здании (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_create_date", "hospital_home_building_create_date");
	//48) hospital_home_building_modify_date, Дата изменения записи о здании (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_modify_date", "hospital_home_building_modify_date");
	//49) hospital_home_building_name, Наименование здания (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_name", "hospital_home_building_name");
	//50) hospital_home_building_build_year, Год постройки (Стационар на дому), Целочисленное;
	Поля.Вставить("hospital_home_building_build_year", "hospital_home_building_build_year");
	//51) hospital_home_building_floor_count, Этажность (Стационар на дому), Целочисленное;
	Поля.Вставить("hospital_home_building_floor_count", "hospital_home_building_floor_count");
	//52) hospital_home_building_has_trouble, Признано аварийным (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_has_trouble", "hospital_home_building_has_trouble");
	//53) hospital_home_building_address_post_index, Почтовый индекс (Стационар на дому), Целочисленное;
	Поля.Вставить("hospital_home_building_address_post_index", "hospital_home_building_address_post_index");
	//54) hospital_home_building_address_cadastral_number, Кадастровый номер (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_cadastral_number", "hospital_home_building_address_cadastral_number");
	//55) hospital_home_building_address_latitude, Широта (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_latitude", "hospital_home_building_address_latitude");
	//56) hospital_home_building_address_longtitude, Долгота (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_longtitude", "hospital_home_building_address_longtitude");
	//57) hospital_home_building_address_region_id, Код региона (Стационар на дому), Целочисленное;
	Поля.Вставить("hospital_home_building_address_region_id", "hospital_home_building_address_region_id");
	//58) hospital_home_building_address_region_name, Наименование региона (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_region_name", "hospital_home_building_address_region_name");
	//59) hospital_home_building_address_aoid_area, Идентификатор населенного пункта (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_aoid_area", "hospital_home_building_address_aoid_area");
	//60) hospital_home_building_address_aoid_street, Идентификатор улицы (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_aoid_street", "hospital_home_building_address_aoid_street");
	//61) hospital_home_building_address_houseid, Идентификатор дома (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_houseid", "hospital_home_building_address_houseid");
	//62) hospital_home_building_address_prefix_area, Префикс населенного пункта (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_prefix_area", "hospital_home_building_address_prefix_area");
	//63) hospital_home_building_address_area_name, Наименование населенного пункта (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_area_name", "hospital_home_building_address_area_name");
	//64) hospital_home_building_address_prefix_street, Префикс улицы (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_prefix_street", "hospital_home_building_address_prefix_street");
	//65) hospital_home_building_address_street_name, Наименование улицы (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_street_name", "hospital_home_building_address_street_name");
	//66) hospital_home_building_address_house, Номер дома (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_house", "hospital_home_building_address_house");
	//67) hospital_home_building_address_building, Номер строения (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_building", "hospital_home_building_address_building");
	//68) hospital_home_building_address_struct, Номер корпуса (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_struct", "hospital_home_building_address_struct");
	//69) hospital_home_building_address_fias_version, Версия ФИАС (Стационар на дому), Строковое;
	Поля.Вставить("hospital_home_building_address_fias_version", "hospital_home_building_address_fias_version");
	
	Возврат Поля;
	
КонецФункции

// Формирует массив структур, ключи которых - поля для поиска существующих элементов при загрузки из ФР НСИ ЕГИСЗ,
//  а порядок в массиве - приоритет использования способов поиска.
// 
// Возвращаемое значение:
//  Массив - наборы ключей поиска.
//
Функция ПолучитьПорядокПоискаСуществующихОбъектов() Экспорт
	
	ПорядокПоиска = Новый Массив;
	
	ПоляПоиска = Новый Структура;
	ПоляПоиска.Вставить("OIDСтруктурногоПодразделения", "OIDСтруктурногоПодразделения");
	ПоляПоиска.Вставить("ПолноеНаименование", "Наименование");
	
	ПорядокПоиска.Добавить(ПоляПоиска);
	
	Возврат ПорядокПоиска;
	
КонецФункции

// Список полей отбора для загрузки из внешнего классификатора.
// 
// Возвращаемое значение:
//  Структура - список полей.
//
Функция СписокПолейДляЗагрузкиПоОтбору() Экспорт
	СписокПолей = Новый Структура;
	
	ПараметрыПоля = Новый Структура;
	ПараметрыПоля.Вставить("Представление","Медицинская организация");
	ПараметрыПоля.Вставить("ТипДанных",Тип("СправочникСсылка.РеестрМедицинскихОрганизаций"));
	ПараметрыПоля.Вставить("ТолькоТочноеСовпадение",Истина);

	СписокПолей.Вставить("mo_oid",ПараметрыПоля);
	
	Возврат СписокПолей;
КонецФункции

// Загрузка справочника: событие перед записью элемента справочника.
//
// Параметры:
//  ОбъектСправочника		 - СправочникОбъект	 - объект справочника
//  ДополнительныеСвойства	 - Структура		 - дополнительные свойства
//  СтрокаКлассификатора	 - СтрокаДереваЗначений	 - строка дерева классификатора
//  СообщениеОтказа			 - Строка				 - Сообщение отказа
//
Процедура ЗагрузкаСправочникаИзЕГИСЗПередЗаписью(ОбъектСправочника, ДополнительныеСвойства, СтрокаКлассификатора, СообщениеОтказа) Экспорт
	
	Если ДополнительныеСвойства.Свойство("ТестовыйКонтур") Тогда
		ОбъектСправочника.ТестовыйКонтур = ДополнительныеСвойства.ТестовыйКонтур;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти