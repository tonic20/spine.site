<% title 'Классы' %>

Spine обеспечивает работу с классами, для этого используется встроенная в CoffeeScript реализация. 

##Методы классов

### `@sub([includeProperties, extendProperties])`

Используется для создания или наследования класса. Пример создания класса:

    var User = Spine.Class.sub();
    
Пример наследования существующего класса:

    var Teacher = User.sub();
    
Также в параметрах можно передавать дополнительные или расширяющие свойства, которые будут добавлены в класс.

    var User = Spine.Class.sub({
      instanceFunction: function(){
        // Blah
      }
    });
    
### `new`

Обьект класса может быть создан с помощью ключевого слова `new`:
  
    var User = Spine.Class.sub();
    var user = new User;

### `@extend(Module)`

Функция `@extend()` добавляет метод класса.

    var User = Spine.Class.sub();
    User.extend({
      find: function(){
        /* ... */ 
      }
    });
    
    User.find();

### `@include(Module)`

Функция `@include()` добавляет метод обьекта.

    var User = Spine.Class.sub();
    User.include({
      name: "Default Name"
    });
    
    assertEqual( (new User).name, "Default Name" );

### `@proxy(function)`

Оборачивает функцию в прокси, так, что она будет исполнятся в контексте класса.

##Instance methods

### `proxy()`

Оборачивает функцию в прокси, так, что она будет исполнятся в контексте объекта.
