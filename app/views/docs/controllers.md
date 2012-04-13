<% title 'Контроллеры' %>

Контроллеры - это последняя из трех основных составляющих Spine. Контроллеры - это очень простая составляющая Spine, которая является скорее набором соглашений, чем реальным кодом. Контроллеры представляют собой цемент, которым соединяются компоненты вашего приложения.  Основной задачей контроллеров является обращение к элементам DOM и добавление новых элементов, а также рендеринг шаблонов и синхронизация моделей с их представлениями.

##Реализация

Контроллеры, как и модели, раширяются `Spine.Module` и в такой способ наследуют все его свойства. Это означает, что вы можете использовать `extend()` и `include()` для добавления свойств в контроллеры и получаете возможность работать со всеми внутренностями Spine. Для того, чтобы создать контроллер необходимо наследовать класс от `Spine.Controller`.
    
    //= CoffeeScript
    class Tasks extends Spine.Controller
      constructor: ->
        super
        # Called on instantiation
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      init: function(){
        // Called on instantiation
      }
    });

Согласно соглашению об именовании в Spine имена контроллеров должны представлять собой имена соответствующих моделей во множественном числе. В нашем случае модель носит имя `Task`. Обычно вы будете добавлять в контроллеры только свойства экземпляров, по этому вы можете добавить их как встроенные, как и любой другой класс. Создание экземпляра контроллера происходит через использование ключевого слова new.
  
    //= CoffeeScript
    tasks = new Tasks
    
Каждый контроллер имеет ассоциируемый с ним элемент, доступ к которому можно получить через свойство `el`. Этот элемент определяется автоматически при создании экземпляра контроллера. Тип элемента определяется через свойство `tag`, которое по умолчанию имеет значение `"div"`.

    //= CoffeeScript
    class TaskItem extends Spine.Controller
      tag: "li"
      
    # taskItem.el is a <li></li> element
    taskItem = new TaskItem 
    
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      tag: "li"
    });
    
    var taskItem = new TaskItem;

Свойство `el` можно устанавливать вручную при создании экземпляров контроллера.
    
    //= CoffeeScript
    tasks = new Tasks(el: $("#tasks"));

Фактически все, что вы передадите в контроллер при создании экземпляров будет использовано для установки свойств экземпляра контроллера. Например, вы можете передать запись с которой будет ассоциирован контроллер.

    //= CoffeeScript
    taskItem = new TaskItem(item: Task.first())

Внутри функции `constructor()` вашего контроллера, вы можете непосредственно добавлять наблюдателей за событиями для моделей и представлении, привязывая функцию внутри контроллера.

##События

Spine предоставляет вам свойство `events` для добавления наблюдателей за событиями для элементов DOM.

    //= CoffeeScript
    class Tasks extends Spine.Controller
      events: 
        "click .item": "click"
      
      click: (event) ->
        # Invoked when .item is clicked
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      events: {"click .item": "click"},
      
      click: function(event){
        // Invoked when .item is clicked
      }
    });
    
`events` - это объект, который имеет следующий формат `{"eventType selector", "functionName"}`. Все селекторы привязываются к ассоциируемому с контроллером элементу - `el`. Если селектор не указан, то событие будет добавлено собственно самому элементу `el`, а если указан, то событие будет добавлено всем дочерним элементам `el`, которые соответствуют селектору.

Spine позаботился для вас о контексте коллбеков проверяя чтобы они были объявлены для текущего контроллера. Коллбеки будут получать объект представляющий событие и вы можете получить через него доступ к элементу которому принадлежит коллбек используя `event.target`. (Коллбек - транслитерация на callback - обратный вызов. Коллбек - это функция, которая выполняется при возникновении определенного события, например вывод сообщения при клике на кнопку.)

    //= CoffeeScript
    class Tasks extends Spine.Controller
      events: 
        "click .item": "click"
  
      click: (event) ->
        item = jQuery(event.target);
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      events: {"click .item": "click"},

      click: function(event){
        var item = jQuery(event.target);
      }
    });

Так как Spine использует [delegation](http://api.jquery.com/delegate) для событий, то не важно, будет ли меняться контекст `el`. Ранее присвоенные коллбеки для событий будут успешно срабатывать при возникновении соответствующих им событий.

Помимо событий DOM, `Spine.Controller` расширяясь при помощи `Spine.Events` позволяет вам связывать и вызывать коллбеки для собственных событий. 

    //= CoffeeScript
    class ToggleView extends Spine.Controller
      constructor: ->
        super
        @items = @$(".items")
        @items.click => @trigger("toggle")
        @bind "toggle", @toggle
        
      toggle: ->
        # ...
    
    //= JavaScript
    var ToggleView = Spine.Controller.sub({
      init: function(){
        this.items = this.$(".items");
        this.items.click(this.proxy(function(){
          this.trigger("toggle");
        }));
        this.bind("toggle", this.toggle);
      },
      
      toggle: function(){
        // ...
      }
    });

##Элементы

Когда вы впервые создаете экземпляр контроллера, то обычно устанавливаете набор переменных экземпляра, которые ссылаются на различные элементы. Пример установки переменной `items` для контроллера `Tasks`:

    //= CoffeeScript
    class Tasks extends Spine.Controller
      constructor: ->
        super
        @items = @$(".items")
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      init: function(){
        this.items = this.$(".items");
      }
    });
    
Поскольку это достаточно типичная практика, Spine предоставляет свойство `elements`, которое очень удобно. Формат объекта, которым является это свойство следующий: `{"selector": "variableName"}`. Когда создаются экземпляры контроллера, Spine пробегается по `elements` устанавливая имеющиеся там элементы в качестве свойств экземпляра контроллера. Как и в случае с `events`, все селекторы привязываются к текущему элементу - `el`.

    //= CoffeeScript
    class Tasks extends Spine.Controller
      elements:
        ".items": "items"
      
      constructor: ->
        super
        @items.each -> #...
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      elements: {".items", "items"},
      
      init: function(){
        this.items.each(function(){
          // ...
        });
      }
    });

##Документация по API

Чтобы получить больше информации о контроллерах, пожалуйста обратите внимание на [документация по API](<%= api_path("controllers") %>).