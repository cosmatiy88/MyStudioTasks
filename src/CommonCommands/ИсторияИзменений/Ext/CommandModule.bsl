﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		СсылкаНаОбъект = ПараметрКоманды[0];
	Иначе
		СсылкаНаОбъект = ПараметрКоманды;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", СсылкаНаОбъект);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ПараметрыВыполненияКоманды.Источник.ТолькоПросмотр);
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ВыборХранимыхВерсий",
								ПараметрыФормы,
								ПараметрыВыполненияКоманды.Источник,
								ПараметрыВыполненияКоманды.Уникальность,
								ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
