<% title "Модели" %>

Одной из проблем перемещения кода на сторону клиента является управление данными. Управление данными в приложениях на JavaScript очень сильно отличается от того, как это принято делать на стороне сервера. Здесь нет привычной модели взаимоотношений запрос/ответ и у вас нет доступа к переменным серверного кода.  Вместо этого данные запрашиваются из удаленного ресурса и хранятся на стороне клиента. Преимущество такого подхода заключается в том, что доступ к данным происходит моментально, и пользователи редко долго ждут загрузки данных из удаленного ресурса.

После того, как страница инициализации загружена, данные сохраняются локально в классовых структурах именуемых моделями. Модели - это основа Spine и являются невероятно важными для вашего приложения. Модели не только отвечают за хранение данных, но и за всю логику работы с этими данными.

Модели должны быть независимы и отделены от остального вашего приложения. Сохранность данных принадлежащих моделям может быть обеспечена использованием [HTML5 Local Storage](<%= docs_path("local") %>) или [Ajax](<%= docs_path("ajax") %>).

##Реализация

Модели создаются наследуясь от `Spine.Model`:
    
    //= CoffeeScript
    class Contact extends Spine.Model
      @configure "Contact", "first_name", "last_name"

    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "first_name", "last_name");
      
Прежде всего в контексте модели вы должны вызывать `configure()` это функция установит различные необходимые переменные и события. В качестве аргументов в `configure()` следует передавать имя модели и любые ее атрибуты. 

Модели - это совершенно обыкновенные CoffeeScript классы, что означает, что вы можете добавить методы класса и методы экземпляров:

    //= CoffeeScript
    class Contact extends Spine.Model
      @configure "Contact", "first_name", "last_name"
      
      @filter: (query) -> 
        @select (c) -> 
          c.first_name.indexOf(query) is not -1
      
      fullName: -> [@first_name, @last_name].join(' ')
      
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "first_name", "last_name");
    
    Contact.extend({
      filter: function(query) {
        return this.select(function(c){
          return c.first_name.indexOf(query) != -1
        });
      }
    });
    
    Contact.include({
      fullName: function(){
        return(this.first_name + " " + this.last_name);
      }
    });
      
Модели являются [модулями](<%= docs_path("classes") %>) Spine поэтому вы можете расширять их модулями расширений и различными свойствами.
    
    //= CoffeeScript
    class Contact extends Spine.Model
      @configure "Contact", "first_name", "last_name"
    
      @extend MyModule
      
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "first_name", "last_name");
    
    Contact.extend(MyModule);
    
Экземпляры моделей создаются используя ключевое слово `new`, а в функцию - конструктор (класс) передается опциональный набор аргументов..

    //= CoffeeScript
    contact = new Contact(first_name: "Alex", last_name: "MacCaw")
    assertEqual( contact.fullName(), "Alex MacCaw" )
    
    //= JavaScript
    var contact = new Contact({first_name: "Alex", last_name: "MacCaw"});
    assertEqual( contact.fullName(), "Alex MacCaw" );
    
Модели могут быть легко наследованы:

    //= CoffeeScript
    class User extends Contact
      @configure "User"
      
    //= JavaScript
    var User = Contact.sub();
    User.configure("User");
    
##Сохранение записей и обращение к ним

После того, как экземпляр модели создан вы можете сохранить его в памяти использовав метод `save()`.
    
    //= CoffeeScript
    class Contact extends Spine.Model
      @configure "Contact", "first_name", "last_name"
      
    contact = new Contact(first_name: "Joe")
    contact.save()
    
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "first_name", "last_name");
    
    var contact = new Contact({first_name: "Joe"});
    contact.save();
    
Когда запись сохранена, Spine присваивает ей уникальный идентификатор, если тот не был установлен ранее.

    assertEqual( contact.id, "AD9408B3-1229-4150-A6CC-B507DFDF8E90" )
    
Вы можете использовать идентификатор записи для обращения к ней используя `find()`.

    identicalContact = Contact.find( contact.id )
    assert( contact.eql( identicalContact ) )
    
Если `find()` не находит запись, то будет вызвана исключительная ситуация. Вы можете проверить существование записи с тем или иным идентификатором используя `exists()`.

    assert( Contact.exists( contact.id ) )
    
После того, как некоторые атрибуты записи были изменены, вы можете сохранить их, повторно вызвав метод `save()`.
    
    //= CoffeeScript
    contact = Contact.create(first_name: "Polo")
    contact.save()
    contact.first_name = "Marko"
    contact.save()
    
Вам также доступны методы `first()` или `last()` для обращения соответственно к первой и последней записи.

    //= CoffeeScript
    firstContact = Contact.first()
    
Чтобы получить сразу все записи контактов используйте метод `all()`.
  
    //= CoffeeScript
    contacts = Contact.all()
    console.log(contact.name) for contact in contacts

Вы можете назначить функцию, которая будет применена ко всем записям по очереди используя `each()`.

    //= CoffeeScript
    Contact.each (contact) -> console.log(contact.first_name)
    
Или получить набор определенных записей используя `select()`.

    //= CoffeeScript
    Contact.select (contact) -> contact.first_name
    
##Валидация

Валидация моделей предельно проста, просто перепишите функцию  `validate()` так, как вам нужно.

    //= CoffeeScript
    class Contact extends Spine.Model
      validate: ->
        unless @first_name
          "Необходимо указать имя"
          
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "first_name", "last_name");
    Contact.include({
      validate: function(){
        if ( !this.first_name )
          return "Необходимо указать имя";
      }
    });

Если `validate()` возвращает какое-либо значение, то это свидетельствует о том, что валидация провалена и произошло событие *error* модели. Вы можете вылавливать это событие через добавление наблюдателей за ним.
    
    //= CoffeeScript
    Contact.bind "error", (rec, msg) ->
      alert("Не удается сохранить контакт - " + msg)
    
Кроме того, `save()`, `create()` и `updateAttributes()` возвращают false в случае, когда валидация провалилась. Чтобы узнать больше о валидации обратите внимание на [руководство по валидации](<%= docs_path("forms") %>).

##Сериализация

Модели в Spine имеют поддержку JSON сериализации. Для сериализации модели вызовите метод `JSON.stringify()` передав в него запись, или для сериализации всех записей передав модель.

    JSON.stringify(Contact)
    JSON.stringify(Contact.first())
    
Как вариант вы можете обратиться к атрибутам экземпляра модели через `attributes()` и реализовать свою собственную сериализацию.

    //= CoffeeScript
    contact = new Contact(first_name: "Leo")
    assertEqual( contact.attributes(), {first_name: "Leo"} )
    
    Contact.include
      toXML: ->
        serializeToXML(@attributes())
    
Если вы используете старые браузеры, которые не имеют встроенной поддержки JSON (например IE 7), то вам необходимо будет подключить [json2.js](https://github.com/douglascrockford/JSON-js/blob/master/json2.js) - это библиотека, которая добавит поддержку JSON. 

##Сохранность данных

В Spine приложениях данные хранятся в оперативной памяти для быстрого доступа к ним, однако из-за возможности потерять их во время какого-либо сбоя, вам следует в тот или иной способ позаботиться об их сохранности. Spine включает в себя набор модулей обеспечивающих сохранность данных, например модуль для отправки Ajax запросов на сервер и модуль для работы с HTML5 Local Storage, которые вы можете использовать для хранения данных соответственно на сервере или на клиенте. Обратите ваше внимание на [руководство по работе с Ajax](<%= docs_path("ajax") %>) и [руководство по Local Storage](<%= docs_path("local") %>)) чтобы узнать больше. 

##События

Вы уже знаете, что модели имеют ассоциируемые с ними события, например *error* или *ajaxError*, однако что насчет коллбеков для создания, обновления или уничтожения записи? Разумеется, разработчики Spine позаботились об этом и потому вы можете пользоваться коллбеками для следующих событий:

* *save* - запись сохранена (создана и сохранена или обновлена ранее существующая)
* *update* - запись обновлена
* *create* - создана новая запись
* *destroy* - запись уничтожена
* *change* - любое из ранее перечисленных событий (сохранение, изменение, создание новой записи или ее уничтожение)
* *refresh* - все записи не проходят валидацию и заменены
* *error* - провал валидации

Используя коллбеки, мы можете привязать к событию *create* какое-либо действие, например:

    //= CoffeeScript
    Contact.bind "create", (newRecord) ->
      # создана новая запись
    
В коллбеках уровня модели ассоциируемая запись всегда передается в коллбек. Как вариант вы можете привязывать коллбек к событию напрямую через запись.

    //= CoffeeScript
    contact = Contact.first()
    contact.bind "save", -> 
      # Contact обновлен
      updateInterface()
    
Контекстом выполнения функции - коллбека является та запись для событий в которой назначен наблюдатель. Вы найдете события модели очень важными, например, привязывая записи к их представлениям и проверяя синхронизацию представлений с данными приложения.

Если вы хотите отменить выполнение коллбеков для определенных действий, то вам необходимо использовать метод `unbind()` модели. Обратите внимание на [руководство по событиям](<%= docs_path("events") %>) чтобы узнать больше о том, как использовать `unbind()`. Экземпляры модели также обладают методом `unbind()`, но в случае с экземпляром модели, `unbind()` отменит коллбеки только для того экземпляра (записи), для которого он вызван.

##Динамические записи

Одной замечательной особенностью моделей Spine являются динамические записи, которые используют наследование на прототипах для синхронизации копий экземпляров модели. Вызов любого метода `find()`, `all()`, `first()`, `last()` и т.д., и коллбек повешенный на события модели вернет *клон* сохраненной записи. Это означает, что после сохранения изменений экземпляра модели (записи), все ее копии (клоны) автоматически получат актуальные данные, то есть будут синхронизированы.

Давайте рассмотрим пример кода. Мы хотим создать asset и затем создать его клон. При этом нам необходимо сделать так, чтобы при обновлении записи ее клон также автоматически обновился.

    //= CoffeeScript
    asset = Asset.create(name: "whatshisname")
    
    # Абсолютно новый экземпляр asset
    clone = Asset.find(asset.id)

    # Изменяем сохраненный asset
    asset.updateAttributes(name: "bob")
    
    # Проверяем появились ли изменения у клона записи
    assertEqual(clone.name, "bob")
    
Это означает, что вам не нужно вызывать метод вроде `reload()` для экземпляров, чтобы синхронизировать их. Вы можете быть уверены, что все копии записи будут обновлены при сохранении обновлений одной из них.

##Ассоциирование моделей

Spine имеет поддержку ассоциаций моделей, таких как: *has-many*, *has-one* и *belongs-to*. Чтобы узнать больше об отношениях (ассоциациях) между моделями обратите внимание на [руководство по ассоциированию моделей](<%= docs_path("relations") %>).

##Документация по API

Чтобы узнать больше о моделях, обратите внимание на [документацию по API](<%= api_path("models") %>).
