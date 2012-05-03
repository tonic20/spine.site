<% title 'Классы и модули' %>

Классы - отличный способ инкапсуляции логики и создания пространств имен. Классы повсеместно используются в Spine, например модели и контроллеры являются классами. Объектный литерал в JavaScript не только отлично подходит для создания статических классов, но и часто может быть полезен для создания классических классов с наследованиями и экземплярами.

Так как JavaScript не имеет поддержки классов, то они эмулируются через использование функций - конструкторов и прототипов объеков. Классы - это просто другой инструмент, и они очень полезны в JavaScript, как и в любом другом языке программирования.

Если вы используете JavaScript вместо CoffeeScript для разработки ваших приложений, то вам следует взглянуть на предпоследний раздел этого руководства - *JavaScript классы*. 

##Реализация

Для классов Spine Использует [собственную реализацию классов](http://arcturo.github.com/library/coffeescript/03_classes.html) в CoffeeScript, например:

    class User
      # метод класса
      @find: (id) ->
        (@records or= {})[id]
      
      # конструктор - вызывается при инициализации экземпляров
      constructor: (attributes = {}) ->
        @attributes = attributes

      # методы экземпляров
      save: ->
      destroy: ->
      
Для создания экземпляров класса используйте ключевое слово `new` (под капотом классов скрываются функции - конструкторы).
      
    user = new User(name: "Dark Knight")
    user.save()
    user.destroy()
    
    user = User.find(1)
    
Для наследования одного класса от другого в CoffeeScript, используйте `extends`.

    class Users extends Spine.Controller
      constructor: ->
        super

Если вы расширяете другой класс и переписываете функцию `constructor`, то вам следует убедиться в том, что вы не забыли вызвать внутри конструктора `super`, особенно когда это касается моделей и конструкторов Spine. `super` позволяет вызвать оригинальный метод в контексте того, который его перекрывает.

##Контекст

Приложения JavaScript часто включают множество переключений контекста, особенно когда речь идет о коллбеках определенных для событий. Вместо того, чтобы вручную проксировать коллбеки, чтобы те выполнялись в правильном контексте, вам следует использовать особый синтаксис функций в CoffeeScript в котором используется `fat arrow` (жирная стрелка) то есть вот это обозначение функции: `=>`. 

    class TaskApp extends Spine.Controller
      constructor: ->
        super
        Task.bind("create",  @addOne)
        Task.bind("refresh", @addAll)
        Task.fetch()

      addOne: (task) =>
        view = new Tasks(item: task)
        @append(view.render())

      addAll: =>
        Task.each(@addOne)
        
В примере выше обе функции `addOne()` и `addAll()` используют определение функции с `fat arrow` (`=>`), вместо обычной (`->`). Это определяет контекст выполнения функций, таким образом, что, не смотря на то, что коллбеки определенные для событий `Task` будут вызывать их в контексте `Task`, сами эти функции будут выполняться в контексте `TaskApp`.
    
Чтобы узнать больше о классах CoffeeScript обратите внимание на [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/03_classes.html).

##Модули

Spine расширяет классы в CoffeeScript поддержкой модулей, используя `Spine.Module`. Это позволяет вам легко расширять классы и их экземпляры свойствами используя соответственно `@extend()` и `@include()`. Чтобы использовать модули, просто наследуйте ваши классы от `Spine.Module`.
    
    class MyTest extends Spine.Module
      @extend ClassModule
      @include InstanceModule
      
Внутренние классы Spine наследуются от `Spine.Module`, таким образом все они уже имеют поддержку `@extend()` и `@include()`:

    class User extends Spine.Model
      @configure "User"
      @extend Spine.Model.Ajax
  
Модули - это просто набор свойств, например:
    
    OrmModule = {
      find: (id) -> /* ... */
    }
    
Модули также могут включать функции - коллбеки, `extended()` и `included()`:

    OrmModule =
      find: (id) -> /* ... */
      extended: -> 
        console.log("module extended: ", @)

##JavaScript классы

Если вы пишите на JavaScript, то вы очевидно не имеете доступа к синтаксису объявления классов CoffeeScript. Spine решает эту проблему через `Spine.Class`:

    var Users = Spine.Class.sub();
    
Вызов `sub()` для класса возвращает его наследуемый от него класс. Вы также можете передать в `sub()` набор свойств экземпляров и класса или вызывать `extend()` и `include()` напрямую из класса. 
    
    Users.extend({
      find: function(id){
        /* ... */         
      }
    });
    
    Users.include({
      destroy: function(){
        /* ... */ 
      }
    });
    
Для наследования от класса `Users` в примере ниже просто вызывается метод `sub()`:

    var Owner = Users.sub();
    
Функция инициализации класса называется `init()`:

    var User = Spine.Class.sub({
      init: function(){
        // вызывается при создании экземпляров
        console.log(arguments);
      }
    });
    
    var user = new User({name: "Spock"});

Вызов оригинальных функции (через super) выглядит значительно сложнее чем в CoffeeScript.

    var User = Spine.Controller.sub({
      init: function(){
        this.constructor.__super__.init.apply(this, arguments)
      }
    });
    
Как вы могли увидеть в примерах выше, использовать контроллеры и модели Spine в ортодоксальном JavaScript заключается просто в вызове метода `sub()` для них.

##API

Чтобы узнать больше о классах, обратите внимание на [подробное API](<%= api_path("classes") %>).