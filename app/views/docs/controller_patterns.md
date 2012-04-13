<% title 'Шаблоны Контроллеров' %>

Описание основных функций контроллеров в находится разделе [контроллеры](<%= docs_path("controllers") %>), давайте разберем некоторые типичные примеры использования. 

##Шаблон Рендер

Шаблон *рендер* это удобный способ соединить модель и её представление. Когда контроллер инициализируется он добавляет обработчики событий на соответствующую модель, и вызывает коллбеки когда данные модели меняются. Коллбек вызывает функцию `render()` и обновляет элемент (`el`) заменяя его содержимое новым значением полученным из шаблона. 

    //= CoffeeScript
    class Contacts extends Spine.Controller
      constructor: ->
        super
        Contact.bind("refresh change", @render)

      template: (items) ->
        require('views/contacts')(items)

      render: =>
        @html(@template(Contact.all()))
    
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      init: function(){
        Contact.bind("refresh change", this.proxy(this.render));
      },
      
      template: function(items){
        return $('#contactTemplate').tmpl(items);
      },
      
      render: function(){
        this.html(this.template(Contact.all()));
      }
    })
    
Это самой простой способ для обновления элементов при обновлении данных. Это подходит для несложных и небольших списков, но вам может понадобится больше контроля над отдельными элементами, например, добавление обработчиков событий элементов. Для такой ситуации больше подходит *шаблон элемент*.

##Шаблон Элемент

Шаблон элемент по существу дает вам такую ​​же функциональность как шаблон рендер, но даёт гораздо больше контроля. Он состоит из двух контроллеров, который управляет коллекцией элементов. Давайте посмотрим примеры кода, чтобы получить представление о том, как это работает.

    //= CoffeeScript
    class ContactItem extends Spine.Controller
      # Delegate the click event to a local handler
      events:
        "click": "click"
      
      # Bind events to the record
      constructor: ->
        super
        throw "@item required" unless @item
        @item.bind("update", @render)
        @item.bind("destroy", @remove)

      # Render an element
      render: (item) =>
        @item = item if item

        @html(@template(@item))
        @

      # Use a template, in this case via Eco
      template: (items) ->
        require('views/contacts')(items)

      # Called after an element is destroyed
      remove: ->
        @el.remove()
      
      # We have fine control over events, and 
      # easy access to the record too
      click: ->

    class Contacts extends Spine.Controller
      constructor: ->
        Contact.bind("refresh", @addAll)
        Contact.bind("create",  @addOne)

      addOne: (item) =>
        contact = new ContactItem(item: item)
        @append(contact.render())

      addAll: =>
        Contact.each(@addOne)
    
    //= JavaScript
    var ContactItem = Spine.Controller.sub({
      
      // Delegate the click event to a local handler
      events: {
        "click": "click"
      },
      
      // Bind events to the record
      init: function()
        if ( !this.item ) throw "@item required";
        this.item.bind("update", this.proxy(this.render));
        this.item.bind("destroy", this.proxy(remove));
      },
      
      render: function(item){
        if (item) this.item = item;
        
        this.html(this.template(this.item));
        return this;
      },
      
      // Use a template, in this case via jQuery.tmpl.js
      template: function(items){
        return $('#contactTemplate').tmpl(items);
      },
      
      // Called after an element is destroyed
      remove: function(){
        this.el.remove();
      },
      
      click: function(){
        // We have fine control over events, and 
        // easy access to the record too
      }
    });

    var Contacts = Spine.Controller.sub({
      init: function(){
        Contact.bind("refresh", this.proxy(this.addAll));
        Contact.bind("create",  this.proxy(this.addOne));
      },
      
      addOne: function(item){
        var contact = new ContactItem({item: item});
        this.append(contact.render());
      },
      
      addAll: function(){
        Contact.each(this.proxy(this.addOne));
      }
    });        

В этом примере `Contacts` отвечает за добавление записей когда они создаются, а `ContactItem` отвечает за обновление, удаление и перерисовку когда это необходимо. Хотя такой вариант выглядит сложнее, это дает нам преимущества по сравнению с предыдущим шаблоном.

С одной стороны, это удобно, так как список не должен быть повторно отрисововатся каждый раз, когда происходит изменение одного элемента. Кроме того, теперь у нас есть намного больше контроля по каждому элементу. Мы можем поставить обработчики событий, как показано в обработчике `click` и управлять отрисовкой на уровне каждого элемента.

##Далее

Отличный пример использования *шаблона элемент* можно посмотреть в тестовом приложении TodoList, которое разбирается подробно в разделе [примеры приложений](<%= docs_path("example") %>).
