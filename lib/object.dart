main() {
  var person = new Person("zhangsan", 18, "play game");
  person.._printPersonInfo();
  person.name = "lisi";
  person.age = 17;
  person.hobby = "trip";
  person._printPersonInfo();
  person = new Person.name("wangwu", 12, "sleep");
  person._printPersonInfo();
  person = Person.name2(9);
  person._printPersonInfo();

  var human = new Human("lilei", 17, "eat", weight: 45);
  human._printPersonInfo();

  var human2 = Human.name2(0);
  human2._printPersonInfo();
  SmartTelevision("aaaa")._bootNetworkInterface();
}

///1.Dart类的成员没有访问限制,成员变量或成员方法不需要private，protected，public修饰
///2.Dart类如果没有自定义构造函数，内部则会自动定义一个空的构造函数，如果自己自定义了一个构造函数
class Person {
  String _name2;
  String name;
  int age;
  String hobby;
  final int sex;

  Person(String name, int age, String hobby) : sex = 0 {
    print("Person():name=${this.name},age=${this.age},hobby=${this.hobby}.");
    this.name = name;
    this.age = age;
    this.hobby = hobby;
  }

//  /// 构造函数的简写
//  Person(this.name, this.age, this.hobby) {
//    this.age += 10;
//    print("Person():name=$name,age=$age,hobby=$hobby.");
//  }

  /// Person(); //error 构造函数和函数一样也没有重载

  /// 命名构造方法
  Person.name(this.name, this.age, this.hobby) : sex = 0;

  Person.name2(int sex) : sex = sex;

  void _printPersonInfo() {
    print("my name is $name ,I am $age year old and my hobby is $hobby .");
  }

  void printPersonInfo() {
    print("my name is $name ,I am $age year old and my hobby is $hobby .");
  }
}

class Human extends Person {
  var weight;

  ///继承父类的构造函数
//  Human(String name, int age, String hobby) : super(name, age, hobby) {
//    print("Human():name=$name,age=${this.age},hobby=$hobby.");
//  }
  Human(String name, int age, String hobby, {var weight})
      : weight = weight,

        ///在构造函数的函数体运行前执行,只初始化自己的成员变量,不能初始化父类的成员变量
        super(name, age, hobby) {
    _name2 = "00";
    print(
        "Human():name=${this.name},age=${this.age},hobby=${this.hobby},weight=${this.weight}.");
  }

  ///  继承父类的命名构造函数
  Human.name(String name, int age, String hobby)
      : super.name(name, age, hobby) {}

  Human.name2(int sex) : this(null, null, null);
}

abstract class Human2 extends Person {
  var weight;

  ///继承父类的构造函数
//  Human(String name, int age, String hobby) : super(name, age, hobby) {
//    print("Human():name=$name,age=${this.age},hobby=$hobby.");
//  }
  Human2(String name, int age, String hobby, {var weight})
      : weight = weight,

        ///在构造函数的函数体运行前执行,只初始化自己的成员变量,不能初始化父类的成员变量
        super(name, age, hobby) {
    _name2 = "00";
    print(
        "Human():name=${this.name},age=${this.age},hobby=${this.hobby},weight=${this.weight}.");
    _privateMethod();
  }

  ///  继承父类的命名构造函数
  Human2.name(String name, int age, String hobby)
      : super.name(name, age, hobby) {}

  Human2.name2(int sex) : this(null, null, null);

  String get _human2;

  String get human2;

  bool _privateMethod();
}

class Television {
  String telev;

  Television();

  Television.name(this.telev);

  void turnOn() {
    _illuminateDisplay();
  }

  void _illuminateDisplay() {}
}

class Carton {
  String cartonName = "carton";

  void playCarton() {}
}

class Movie {
  void playMovie() {}
}

class Update {
  void updateApp() {}
}

class Charge {
  void chargeVip() {}
}

class SmartTelevision extends Television
    with Update, Charge
    implements Carton, Movie {
  @override
  String cartonName = "SmartTelevision carton";

  SmartTelevision(this.cartonName);

  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    updateApp();
    chargeVip();
  }

  void _bootNetworkInterface() {}

  @override
  void playCarton() {
    // TODO: implement playCarton
  }

  @override
  void playMovie() {
    // TODO: implement playMovie
  }
}
