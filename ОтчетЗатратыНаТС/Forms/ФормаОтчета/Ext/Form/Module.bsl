﻿
&НаСервере
Процедура ПриОткрытииНаСервере()
	
	отчОбк = РеквизитФормыВЗначение("Отчет");
	
	Схема = отчОбк.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	СпкРес     = Отчет.СпкРес;
	СпкГрупп   = Отчет.СпкГрупп;
	СпкКолонки = Отчет.СпкКолонки;
	
	//Инициализация Групп
	Отчет.НастройкаГруппСКД = Новый НастройкиКомпоновкиДанных;
	
	//Имена полей
	СооИмя = отчОбк.ПолучитьСооИмя(Схема);	
	
	Грп = Схема.НастройкиПоУмолчанию;
	ЭтоТаблицаСкд = Ложь;

	Пока Грп.Структура.Количество()>0 Цикл
		Грп = Грп.Структура[Грп.Структура.Количество()-1];
		Если ТипЗнч(Грп) = ТИп("ТаблицаКомпоновкиДанных") ТОгда   //Первый заход
			Грп = Грп.Строки[0];
			Отчет.НастройкаГруппСКД = Отчет.НастройкаГруппСКД.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
		    ЭтоТаблицаСкд = Истина;
		КонецЕСЛИ;
		
		Если ЭтоТаблицаСкд ТОгда
			НовГрп = Отчет.НастройкаГруппСКД.Строки.Добавить();
		ИНАче
			НовГрп = Отчет.НастройкаГруппСКД.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		КонецЕСЛИ;
		
		ОтчОбк.СкопироватьГруппировку(НовГрп,Грп);
		
		п = ОтчОбк.ПолучитьИмяГруппировки(Грп,СооИмя);
		
		пИмя = Грп.Имя;
		Если пИмя="" ТОгда
			пИмя = п;
		КонецЕСЛИ;
		
		СпкГрупп.Добавить(п,пИмя,Грп.Использование);
	КонецЦикла;
	
	Если ЭтоТаблицаСКД ТОгда
		
		
		Для каждого Грп из Схема.НастройкиПоУмолчанию.Структура[0].Колонки Цикл
			
			Пока Грп<>Неопределено Цикл
				
				НовГрп = Отчет.НастройкаГруппСКД.Колонки.Добавить();
				
				ОтчОбк.СкопироватьГруппировку(НовГрп,Грп);
				
				п = ОтчОбк.ПолучитьИмяГруппировки(Грп,СооИмя);
				
				пИмя = Грп.Имя;
				Если пИмя="" ТОгда
					пИмя = п;
				КонецЕСЛИ;
				
				СпкКолонки.Добавить(п,пИмя,Грп.Использование);
				
				Если Грп.Структура.Количество()=0 ТОгда
					прервать;
				ИНАче
					Грп = Грп.Структура[Грп.Структура.Количество()-1];
				КонецЕСЛИ;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕСЛИ;
	
	
	
	ДЛя каждого эл из Схема.НастройкиПоУмолчанию.Выбор.Элементы Цикл
		
		//Если СпкГрупп.НайтиПоЗначению(СокрлП(Эл.Поле))<>Неопределено ТОгда Продолжить; КонецЕСЛИ;
		
		Если ТипЗнч(Эл) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда 
			СпкРес.Добавить(Эл.поле,Эл.Заголовок,ЭЛ.Использование);
		ИНаче
			СпкРес.Добавить(Эл.поле,СооИмя.Получить(СокрлП(Эл.Поле)),ЭЛ.Использование);
		КонецЕсли;
		
	КонецЦикла;
	
	
	Элементы.СпкГрупп.Видимость   = СпкГрупп.Количество()   <> 0;
	Элементы.СпкКолонки.Видимость = СпкКолонки.Количество() <> 0;
	Элементы.СпкРес.Видимость     = СпкРес.Количество()     <> 0;
	
	ОткрытьНастройки(ОтчОбк);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки(ОбкОтчет)
	
	Стк = Новый Структура();
	Для каждого эл из ОбкОтчет.Метаданные().Реквизиты Цикл
		Если Найти(",Дт,Дт1,НастройкаГруппСКД,",","+Эл.Имя+",") <> 0 Тогда Продолжить; КонецЕсли;
		Если ТипЗнч(Отчет[Эл.Имя]) = Тип("СписокЗначений") Тогда
			Стк.Вставить(Эл.Имя, Отчет[Эл.Имя].Скопировать());
		ИНаче
			Стк.Вставить(Эл.Имя, Отчет[Эл.Имя]);
		КонецЕСЛИ;
	КонецЦикла;
	
	ХранилищеВариантовОтчетов.Сохранить(ЭтаФорма.ИмяФормы,,Стк,,ИмяПользователя());
	
КонецПроцедуры

&НаСервере
Процедура ОткрытьНастройки(ОбкОтчет)
	
	Стк = ХранилищеВариантовОтчетов.Загрузить(ЭтаФорма.ИмяФормы,,,ИмяПользователя());
	Если ТипЗнч(Стк) <> Тип("Структура") ТОгда Возврат; КонецЕсли;
	
	Для каждого Эл из Стк Цикл
		Если ТипЗнч(ОбкОтчет[Эл.Ключ])=Тип("СписокЗначений") Тогда
			Для каждого элСпк из ОбкОтчет[Эл.Ключ] Цикл
				нс = Эл.Значение.НайтиПоЗначению(элСпк.Значение);
				Если нс<>Неопределено Тогда
					элСпк.пометка = нс.Пометка;
				КонецЕСЛИ;
			КонецЦикла;
			
		Иначе
			Отчет[Эл.Ключ] = Эл.Значение;
		КонецеСЛИ;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отчет.Дт  = НачалоМЕсяца(ТекущаяДата()-30 * 24*3600);
	Отчет.Дт1 = КонецМесяца(Отчет.дт);
	
	ПриОткрытииНаСервере();
	кнНастройка(1);
КонецПроцедуры


&НаКлиенте
Процедура кнНастройка(Команда)
	Элементы.грпНастройка.Видимость = 1 - Элементы.грпНастройка.Видимость;
КонецПроцедуры


&НаСервере
Функция СформироватьНаСервере()
	Элементы.грпНастройка.Видимость = ложь;
	
	ОбкОтчет = РеквизитФормыВЗначение("Отчет");
	СохранитьНастройки(ОбкОтчет);
	
	ТабСкд = ОбкОтчет.Данные(АдресРасшифровкиДанных,АдресСКД,ЭтаФорма.УникальныйИдентификатор);
	Если Элементы.Дт1.Видимость=Истина ТОгда
		ТабСкд.Область(2,1,2,1).Текст  = ""+ЭтаФорма.Заголовок+" с "+Формат(Отчет.Дт,"ДФ=dd.MM.yyyy")+" по "+Формат(Отчет.Дт1,"ДФ=dd.MM.yyyy");
	ИНАче
		ТабСкд.Область(2,1,2,1).Текст  = ""+ЭтаФорма.Заголовок+" на "+Формат(Отчет.Дт,"ДФ=dd.MM.yyyy");
	КонецеслИ;
	ТабСкд.Область(2,1,2,1).Шрифт = Новый Шрифт(ТабСкд.Область(2,1,2,1).Шрифт,,10,Истина);
	
	ТекЦвет = ТабСКД.Область(4,1,4,1).ЦветФона;
	ДЛя а=5 по 10 Цикл
		Если ТабСКД.Область(а,1,а,1).ЦветФона <> ТекЦвет Тогда
			ТабСКД.Область(4,1,а,ТабСкд.ШиринаТаблицы).Шрифт = Новый Шрифт(ТабСкд.Область(2,1,2,1).Шрифт,,8,Истина);;
			прервать;
		КонецеСЛИ;
	КонецЦикла;
	
	ТабСкд.ВерхнийКолонтитул.ТекстСправа = ""+ИмяПользователя()+" - "+ТекущаяДата()+" страница [&НомерСтраницы] из [&СтраницВсего]";
	ТабСкд.ВерхнийКолонтитул.выводить = Истина;
	
	Таб =  Результат;
	Таб.Очистить();
	Таб.Вывести(ТабСкд);
	Таб.ФиксацияСверху = 4;
	Таб.ФиксацияСлева = 1;
	Таб.ОтображатьЗаголовки = Истина;
	
КонецФункции



&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
	Элементы.Результат.ОтображениеСостояния.Видимость = ложь; 
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
КонецПроцедуры


&НаКлиенте
Процедура кнПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода,ВыборКварталов", ДобавитьМесяц(ТекущаяДата(),-1), ДобавитьМесяц(ТекущаяДата(),-1), ложь);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, , , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОТчет.дт = РезультатВыбора.НачалоПериода;
	Отчет.Дт1= РезультатВыбора.КонецПериода;
	
	//Таб = Печать(РезультатВыбора.НачалоПериода);
	//Таб.Показать();


КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	// Вставить содержимое обработчика.
    СтандартнаяОбработка = Ложь;
	
 
    ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
 
    ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(АдресРасшифровкиДанных, ИсточникДоступныхНастроек);
 
    ДоступныеДействия = Новый Массив();
    ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
    
    Оповещение = Новый ОписаниеОповещения("РезультатОбработкаРасшифровки_Продолжение", ЭтаФорма, Расшифровка);
    ОбработкаРасшифровки.ПоказатьВыборДействия(Оповещение, Расшифровка, ДоступныеДействия, , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура  РезультатОбработкаРасшифровки_Продолжение(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
    Если ПараметрВыполненногоДействия <> Неопределено Тогда
        
        Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
            ПоказатьЗначение(,ПараметрВыполненногоДействия);
        КонецЕсли;
        
    КонецЕсли;        
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизации(Элемент)
	Сумма = ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(Результат);
	Если Сумма=0 Тогда
		Элементы.ПолеСуммы.Видимость  = Ложь;
		Возврат; 
	КонецеСЛИ;
	
	Элементы.ПолеСуммы.Видимость  = Истина;
	
	ПолеСуммы = Сумма;	
	
КонецПроцедуры

&НаКлиенте
Функция ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(ПолеТабличногоДокумента) Экспорт
	
	Сумма = 0;
	Соо = Новый Соответствие;
	Для Каждого Область Из ПолеТабличногоДокумента.ВыделенныеОбласти Цикл
		Если ТипЗнч(Область) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			Для ИндексСтрока = Область.Верх По Область.Низ Цикл
				Для ИндексКолонка = Область.Лево По Область.Право Цикл
					обНОмСтр = Формат(ИндексСтрока, "ЧГ=0");
					обНОмКол = Формат(ИндексКолонка, "ЧГ=0");
					
										
					Попытка
						Сумма = Сумма+Число(СтрЗаменить(ПолеТабличногоДокумента.Область("R" + обНомСтр + "C" + обНОмКол) .Текст, " ", ""));
					Исключение
					КонецПопытки;
					
					
					
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Сумма;
	
КонецФункции


&НаКлиенте
Процедура ПоискСтрокаПриИзменении(Элемент,Вперед=0)
	
	текПоиск = нрег(СокрлП(ПоискСтрока));
	Если текПоиск = "" Тогда Возврат; КонецЕсли;
	Таб = Результат;
	
	НачСтрока=1;
	конСтрока=Таб.ВысотаТаблицы;
	
	Если Вперед = 1 Тогда
		начСтрока = Результат.ТекущаяОбласть.Верх+1;	
	ИНачеЕсли Вперед=-1 ТОгда
		конСтрока = -1;
		НачСтрока = -Результат.ТекущаяОбласть.Верх+1;
	КонецеСЛИ;
	
	
	Для а=НачСтрока по конСтрока Цикл
		
		Если а<0 Тогда
			нс=-а;
		ИНАче
			нс=а;
		КонецЕсли;
		
		ДЛя б=1 по 3 Цикл
			п =нрег(Таб.Область(нс,б,нс,б).Текст);
			Если Найти(п,текПоиск)<>0 Тогда
				этаФорма.ТекущийЭлемент = Элементы.Результат;
				Элементы.Результат.ТекущаяОбласть= Таб.Область(нс,б,нс,б);
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
	Конеццикла;
	
	
	
	этаФорма.ТекущийЭлемент = Элементы.Результат;
	Элементы.Результат.ТекущаяОбласть= Результат.ТекущаяОбласть;
	
	ПоказатьПредупреждение(,"Строка не найдена");
	
КонецПроцедуры


&НаКлиенте
Процедура ПоискДалее(Команда)
	 ПоискСтрокаПриИзменении(Неопределено,1);
КонецПроцедуры


&НаКлиенте
Процедура ПоискНазад(Команда)
	 ПоискСтрокаПриИзменении(Неопределено,-1);
КонецПроцедуры




