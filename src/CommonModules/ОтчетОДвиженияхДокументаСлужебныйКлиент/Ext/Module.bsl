﻿
#Область СлужебныйПрограммныйИнтерфейс

// Обработчик двойного щелчка мыши, нажатия клавиши Enter или гиперссылки в табличном документе формы отчета.
// См. "Расширение поля формы для поля табличного документа.Выбор" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета          - УправляемаяФорма - Форма отчета.
//   Элемент              - ПолеФормы        - Табличный документ.
//   Область              - ОбластьЯчеекТабличногоДокумента - Выбранное значение.
//   СтандартнаяОбработка - Булево - Признак выполнения стандартной обработки события.
//
Процедура ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя = "Отчет.ДвиженияДокумента" Тогда
		
		Если ТипЗнч(Область.Расшифровка) = Тип("Структура") Тогда
			ОткрытьФормуРегистраИзОтчетаОДвижениях(ФормаОтчета, Область.Расшифровка, СтандартнаяОбработка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает форму регистра с отбором по регистратору
//
// Параметры:
//   ФормаОтчета      - УправляемаяФорма - Форма отчета.
//   Расшифровка      - Структура - Структура со свойствами.
//      * ВидРегистра - Содержит вид регистра "Накопления", "Сведений", "Бухгалтерии" или "Расчета".
//      * ИмяРегистра - Содержит имя регистра как объекта метаданных.
//      * Регистратор - Содержит ссылку на документ регистратор, по которому нужно сделать отбор
//                      в открывшейся форме регистра.
//   СтандартнаяОбработка - Булево  - Признак выполнения стандартной (системной) обработки события.
//
Процедура ОткрытьФормуРегистраИзОтчетаОДвижениях(ФормаОтчета, Расшифровка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ПользовательскиеНастройки    = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	Отбор                        = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ЭлементОтбора                = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Регистратор");
	ЭлементОтбора.ПравоеЗначение = Расшифровка.Регистратор;
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование  = Истина;
	
	ИмяФормыРегистра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Регистр%1.%2.ФормаСписка",
		Расшифровка.ВидРегистра, Расшифровка.ИмяРегистра);
	
	ФормаРегистра = ПолучитьФорму(ИмяФормыРегистра);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Поле",          "Регистратор");
	ПараметрыОтбора.Вставить("Значение",      Расшифровка.Регистратор);
	ПараметрыОтбора.Вставить("ВидСравнения",  ВидСравненияКомпоновкиДанных.Равно);
	ПараметрыОтбора.Вставить("Использование", Истина);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Истина);
	ДополнительныеПараметры.Вставить("ЗаменятьСуществующий",       Истина);
	
	ДобавитьОтбор(ФормаРегистра.Список.КомпоновщикНастроек, ПараметрыОтбора, ДополнительныеПараметры);
	ФормаРегистра.Открыть();
	
КонецПроцедуры

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов
//
// Параметры:
//   ЭлементСтруктуры        - КомпоновщикНастроекКомпоновкиДанных, НастройкиКомпоновкиДанных - элемент структуры КД
//   ПараметрыОтбора         - Структура - Содержит параметры отбора компоновки данных.
//     * Поле                - Строка - Имя поля, по которому добавляется отбор.
//     * Значение            - Произвольный - Значение отбора КД (по умолчанию: Неопределено).
//     * ВидСравнения        - ВидСравненияКомпоновкиДанных - Вид сравнений КД (по умолчанию: Неопределено).
//     * Использование       - Булево - Признак использования отбора (по умолчанию: Истина).
//   ДополнительныеПараметры - Структура - Содержит дополнительные параметры, перечисленные ниже:
//     * ВПользовательскиеНастройки - Булево - признак добавления в пользовательские настройки КД (по умолчанию: Ложь).
//     * ЗаменятьСуществующий       - Булево - признак полной замены существующего отбора по полю (по умолчанию: Истина).
//
// Возвращаемое значение:
//   ЭлементОтбораКомпоновкиДанных - Добавленный отбор.
//
Функция ДобавитьОтбор(ЭлементСтруктуры, ПараметрыОтбора, ДополнительныеПараметры = Неопределено)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Ложь);
		ДополнительныеПараметры.Вставить("ЗаменятьСуществующий",       Истина);
	Иначе
		Если Не ДополнительныеПараметры.Свойство("ВПользовательскиеНастройки") Тогда
			ДополнительныеПараметры.Вставить("ВПользовательскиеНастройки", Ложь);
		КонецЕсли;
		Если Не ДополнительныеПараметры.Свойство("ЗаменятьСуществующий") Тогда
			ДополнительныеПараметры.Вставить("ЗаменятьСуществующий", Истина);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыОтбора.Поле) = Тип("Строка") Тогда
		НовоеПоле = Новый ПолеКомпоновкиДанных(ПараметрыОтбора.Поле);
	Иначе
		НовоеПоле = ПараметрыОтбора.Поле;
	КонецЕсли;
	
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		
		Если ДополнительныеПараметры.ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки =
					ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	
	ЭлементОтбора = Неопределено;
	Если ДополнительныеПараметры.ЗаменятьСуществующий Тогда
		Для каждого Элемент Из Отбор.Элементы Цикл
	
			Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
	
			Если Элемент.ЛевоеЗначение = НовоеПоле Тогда
				ЭлементОтбора = Элемент;
			КонецЕсли;
	
		КонецЦикла;
	КонецЕсли;
	
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КонецЕсли;
	ЭлементОтбора.Использование  = ПараметрыОтбора.Использование;
	ЭлементОтбора.ЛевоеЗначение  = НовоеПоле;
	ЭлементОтбора.ВидСравнения   = ?(ПараметрыОтбора.ВидСравнения = Неопределено, ВидСравненияКомпоновкиДанных.Равно,
		ПараметрыОтбора.ВидСравнения);
	ЭлементОтбора.ПравоеЗначение = ПараметрыОтбора.Значение;
	
	Возврат ЭлементОтбора;
	
КонецФункции

#КонецОбласти