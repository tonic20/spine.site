<% title 'События' %>

События - это отличный способ разделения взаимодействия внутри приложения.  События не ограничиваются событиями DOM элементов, они могут быть также определены любому классу или экземпляру класса. Если вы знакомы с API событий в [jQuery](http://jquery.com) или [Zepto](http://zeptojs.com), то реализация событий в Spine покажется вам очень знакомой.

##Реализация

`Spine.Events` - это модуль Spine, который используется для добавления классам поддержки событий. Чтобы добавить события в свой класс, просто наследуйтесь им от `Spine.Events`.

    //= CoffeeScript
    class Tasks extends Spine.Module
      @extend(Spine.Events)
      
    //= JavaScript
    var Tasks = Spine.Class.sub();
    Tasks.extend(Spine.Events);
    
`Spine.Events` предоставляет вам три метода, `bind()`, `trigger()`, и `unbind()`. Все эти три метода имеют API очень подобное тому, что есть в jQuery. `bind(name, callback)` принимает в качестве аргументов название события и коллбек. `trigger(name, [*data])` принимает название события и необязательные данные, которые будут переданы в обработчики события. `unbind(name, [callback])` принимает имя события и необязательный параметр - коллбек.
    
    //= CoffeeScript
    Tasks.bind "create", (foo, bar) -> alert(foo + bar)
    Tasks.trigger "create", "some", "data"

Вы можете привязываться ко множеству событий разделяя их названия пробелами. Коллбеки всегда вызываются в контексте с которым ассоциировано событие.

    //= CoffeeScript
    Tasks.bind("create update destroy", -> @trigger("change"))
    
При необходимости вы можете передавать данные в `trigger()`, эти данные будут переданы в коллбеки привязанные к событию. В отличие от jQuery в Spine объект представляющий событие не передается в коллбеки.

    //= CoffeeScript
    Tasks.bind "create", (name) -> alert(name)
    Tasks.trigger "create", "Take out the rubbish"
    
Однако вам вряд ли понадобится использовать `Spine.Events` в собственных классах, скорее всего вы ограничитесь использованием его только c моделями и контроллерами.

##Глобальные события

Вы также можете привязывать и вызывать глобальные события через вызов соответственно `Spine.bind()` и `Spine.trigger()`.

    //= CoffeeScript
    Spine.bind 'sidebar:show', =>
      @sidebar.active()
      
    Spine.trigger 'sidebar:show'
    
    //= JavaScript
    Spine.bind('sidebar:show', this.proxy(function(){
      this.sidebar.active();
    });
      
    Spine.trigger('sidebar:show');
    
Однако, вам следует знать, что это может быть не самая удачная идея. Всегда спрашивайте себя можно ли использовать роутинг вместо глобальных событий или обойтись локальными событиями контроллеров.

##Документация по API

Чтобы узнать больше о событиях обратите внимание на [подробную документацию по API событий](<%= api_path("events") %>).