# Логирование
Ошибки сообщают только лишь, что произошло. Логирование же позволяет дополнить информацию, тем что пишет какие события происходят внутри системы.

## Использование
Для того чтобы получать логи от системы нужно:
* Подключить логирование, если вы используете cocoapods. Для этого у библиотеки выделен специальный модуль `Logger`
* Реализовать протокол DILogger, который содержит всего один метод: `log(_ event: DILogEvent, msg: String)`
* Зарегистрировать экземпляр класса реализующего протокол в системе: `DILoggerComposite.add(YourLogger())`

Помимо этого можно также отписаться от получения логов с помощью функции: `DILoggerComposite.add(YourLogger())`  

Логирование осуществляется ассинхронно, но всегда сохраняет порядок в котором появлялись логи. По причине ассинхронности, существует третья функция `wait` - она позволяет дождаться когда будут переданы все логи.  

Функция `log` принимает два параметра - событие и сообщение. Про события будет чуть ниже, а сообщение - это некоторый текст который описывает, что произошло в системе.

## События
В библиотеке выделено 8 логируемых событий:
* registration
* createSingle
* resolving
* found
* resolve
* cached
* injection
* error

Некоторые события являются примитивные, некоторые же включают в себя дополнительную информацию. Событие нужно лишь для фильтрации и для более простого понимания, в какой стадии выполнения находится библиотека.  
Разберем каждое событие отдельно и сообщение которое приходит вместе с этим событием.

### registration
Происходит в момент окончания регистрации типа. Само событие не содержит в себе полезной нагрузки, но сообщение является достаточно информативным. Текст сообщения достаточно динамичен и зависит от того что было объявлено во время регистрации.

### createSingle
Делится на две части: `createSingle(.begin)`, `createSingle(.end)`. Первое событие вызывается перед началом создания объектов одиночек, второй по окончанию. При событии начала в сообщении сообщается количество - сколько всего должно быть создано одиночек. Событие конца происходит в любом случае - не зависимо от наличия ошибок.

### resolving
Также как и прошлое событие, делится на две части: `resolving(.begin)`, `resolving(.end)`. Первое событие вызывается в момент очередного запроса на создание объекта, второе по окончанию его получения, даже в случае если его не удалось создать. Так как функция для получения существует несколько вариантов: обычное, по имени, множественное, для объекта - то для большей ясности, какой именно вариант используется, это сообщается в сообщении.

### found
Событие происходит когда библиотеке удалось найти, для запрашиваемого типа регистрацию в контейнере. Это событие выглядит так: `found(typeInfo:)`. То есть событие внутри себя содержит также информацию о регистрации.

### resolve
Событие происходит когда библиотека смогла создать запрашиваемый объект. Всего выделено три способа создания объекта: `resolve(.cache)`, `resolve(.new)`, `resolve(.use)`. Первый говорит о том, что объект был взят из кэша. Какой именно был использован кэш сообщается в сообщении. Второй - был создал полностью новый экземпляр объекта. Третий - в случае если разрешение зависимостей происходило по объекту, а не типу.

### cached
Событие происходит когда библиотека записывает созданный объект в кэш. Какой объект и в какой кэш он записывается пишется внутри сообщения.

### injection
Событие поделено на две части: `injection(.begin`, `injection(.end)`. Первое происходит перед началом внедрения зависимостей, второе по окончанию. Обращаю внимание, что это событие относится только к внедрению через свойства или методы. Внедрении через метод инициализации никак отдельно не выделяется.

### error
Событие происходит перед тем как будет кинуто исключение. Событие внутри себя содержит саму ошибку.

#### [Главная](main.md)
#### [Предыдущая глава "Поиск"](scan.md#Поиск)
#### [Следующая глава "Исключения"](errors.md#Исключения)


