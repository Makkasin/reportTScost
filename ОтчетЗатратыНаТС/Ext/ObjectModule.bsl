﻿Процедура УстановитьПараметры(Настройки)
	
	Эл = Настройки.ПараметрыДанных.Элементы.Найти("НачПер");
	Эл.Использование = Истина;
	Эл.Значение = КонецДня(Дт);
	
	Эл = Настройки.ПараметрыДанных.Элементы.Найти("КонПер");
	Эл.Использование = Истина;
	Эл.Значение = КонецДня(Дт1)+1;
	
	
	Эл = Настройки.ПараметрыДанных.Элементы.Найти("ФильтрТС");
	Эл.Использование = Истина;
	Эл.Значение = ФильтрТС;
	
	Эл = Настройки.ПараметрыДанных.Элементы.Найти("фильтрДорогиеЗЧ");
	Эл.Использование = Истина;
	Эл.Значение = фильтрДорогиеЗЧ;
	
КонецПроцедуры   


Функция Данные(АдресРасшифровкиДанных,АдресСКД,идФормы) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	
	Схема = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Настройки = Схема.НастройкиПоУмолчанию;//отчОбк.КомпоновщикНастроек.Настройки;  
	УстановитьПараметры(Настройки);
	
	СооИмя = ПолучитьСооИмя(Схема);	
	//Выводимые поля
	
	Для каждого Эл из Настройки.Выбор.Элементы	Цикл
		Зн = СпкРес.НайтиПоЗначению(Эл.Поле);
		Если Зн<>Неопределено ТОгда
			Эл.Использование = зн.пометка;	
		КонецЕСлИ;
	КонецЦиклА;
	
	
		//Порядок Группировок
		  
		ЭтоТаблицаСкд = ложь;
		ТекГрп = Настройки;
		Если ТипЗнч(ТекГрп.Структура[0]) = ТИп("ТаблицаКомпоновкиДанных") ТОгда 
			ТекГрп = ТекГрп.Структура[0].Строки;
			ЭтоТаблицаСКД = Истина;
			
			КоллекцияГрупп = НастройкаГруппСКД.Строки;
			Если ТекГрп.Количество()>0 ТОгда
				ТекГрп.Удалить(ТекГрп[0]);
			КонецЕСЛИ;
		ИНаче
			КоллекцияГрупп = НастройкаГруппСКД.Структура;
			ТекГрп.Структура.Удалить(ТекГрп.Структура[0]);
		КонецЕСЛИ;	
			
		Для каждого Эл из СпкГрупп Цикл
			Если Эл.Пометка = Ложь Тогда Продолжить; КонецЕсли;
			
			ДЛя каждого ЭлГрп из КоллекцияГрупп Цикл
				Если эл.Значение = ПолучитьИмяГруппировки(элГрп,сооИмя) ТОгда
					Если ТипЗнч(ТекГрп) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") ТОгда
						ТекГрп = ТекГрп.Добавить();
					ИначеЕсли ЭтоТаблицаСкд ТОгда
						ТекГрп = ТекГрп.Структура.Добавить();
					ИНаче
						ТекГрп = ТекГрп.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
					КонецЕСЛИ;
					СкопироватьГруппировку(ТекГрп,ЭлГрп);
					ТекГрп.Использование = Истина;
					
					прервать;
				КонецеСЛИ;
			КонецЦикла;
			
		КонецЦикла;
		
		//Добавим колонки
		Если ЭтоТаблицаСКД Тогда
			КоллекцияГрупп = НастройкаГруппСКД.Колонки;
			
			ТекГрп = Настройки.Структура[0].Колонки;
			Если ТекГрп.Количество()>0 ТОгда
				ТекГрп.Удалить(ТекГрп[0]);
			КонецЕСЛИ;
			
			Для каждого Эл из СпкКолонки Цикл
				Если Эл.Пометка = Ложь Тогда Продолжить; КонецЕсли;
				
				ДЛя каждого ЭлГрп из КоллекцияГрупп Цикл
					Если эл.Значение = ПолучитьИмяГруппировки(элГрп,Сооимя) ТОгда
						Если ТипЗнч(ТекГрп) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") ТОгда
							ТекГрп = ТекГрп.Добавить();
						ИначеЕсли ЭтоТаблицаСкд ТОгда
							ТекГрп = ТекГрп.Структура.Добавить();
						ИНаче
							ТекГрп = ТекГрп.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
						КонецЕСЛИ;
						СкопироватьГруппировку(ТекГрп,ЭлГрп);
						
						прервать;
					КонецеСЛИ;
				КонецЦикла;
				
			КонецЦикла;
			
		КонеЦЕСЛИ;
		
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(Схема,Настройки,ДанныеРасшифровки,ПолучитьМакет("МакетОформления"),,Ложь);
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет,,ДанныеРасшифровки,истина,Ложь);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	
	Таб = Новый ТабличныйДокумент;
	
	ПроцессорВывода.УстановитьДокумент(Таб);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	АдресРасшифровкиДанных = ПоместитьВоВременноеХранилище(ДанныеРасшифровки,идФормы);
	АдресСКД = ПоместитьВоВременноеХранилище(Схема,идФормы);
	
	Возврат Таб;
	
КонецФункции	

Функция ПолучитьИмяГруппировки(Грп,СооИмя) Экспорт
	
	
	Стр = "";
	Для каждого Эл из Грп.ПоляГруппировки.Элементы Цикл
		Если ТипЗнч(Эл) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") ТОгда
			Стр = Стр+"Детальные записи,";
		ИНАче
			Стр = Стр+СооИмя.Получить(СокрлП(Эл.Поле))+",";
		КонецЕсли;
	КонецЦикла;
	
	Возврат Лев(Стр,стрДлина(Стр)-1);;
	
КонецФункции

Процедура СкопироватьГруппировку(НовГрп,Грп) Экспорт
	
	ЗаполнитьЗначенияСвойств(НовГрп,Грп);
	
	ДЛя каждого эл из Грп.Выбор.Элементы Цикл
		НовЭл = НовГрп.Выбор.Элементы.Добавить(ТипЗнч(Эл));
		ЗаполнитьЗначенияСвойств(НовЭл,Эл);
	КонецЦикла;
	
	Для а=0 по Грп.ПараметрыВывода.Элементы.Количество()-1 Цикл
		ЗаполнитьЗначенияСвойств(НовГрп.ПараметрыВывода.Элементы[а],Грп.ПараметрыВывода.Элементы[а]);
	КонецЦикла;
	
	ДЛя каждого эл из Грп.Порядок.Элементы Цикл
		НовЭл = НовГрп.Порядок.Элементы.Добавить(ТипЗнч(Эл));
		ЗаполнитьЗначенияСвойств(НовЭл,Эл);
	КонецЦикла;
	
	ДЛя каждого эл из Грп.ПоляГруппировки.Элементы Цикл
		НовЭл = НовГрп.ПоляГруппировки.Элементы.Добавить(ТипЗнч(Эл));
		ЗаполнитьЗначенияСвойств(НовЭл,Эл);
	КонецЦикла;
	
	ДЛя каждого эл из Грп.Отбор.Элементы Цикл
		НовЭл = НовГрп.Отбор.Элементы.Добавить(ТипЗнч(Эл));
		ЗаполнитьЗначенияСвойств(НовЭл,Эл);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСооИмя(Схема) Экспорт
	
	СооИмя = Новый Соответствие;
	Для каждого НаборДанных из Схема.НаборыДанных Цикл
		Для каждого Эл из НаборДанных.Поля Цикл
			Если СокрлП(ЭЛ.Заголовок)="" Тогда
				СооИмя.Вставить(Эл.Поле,СокрЛП(Эл.Поле));
			ИНАче
				СооИмя.Вставить(Эл.Поле,Эл.Заголовок);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат СооИмя;
	
КонецФункции


