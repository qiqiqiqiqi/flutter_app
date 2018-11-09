main() {
  var person = new Person("zhangsan", 18, "play game");
  person..printPersonInfo();
  person.name = "lisi";
  person.age = 17;
  person.hobby = "trip";
  person.printPersonInfo();
  person = new Person.name("wangwu", 12, "sleep");
  person.printPersonInfo();
  person = Person.name2("jack");
  person.printPersonInfo();

  var human = new Human("lilei", 17, "eat");
  human.printPersonInfo();
}

///1.Dart类的成员没有访问限制,成员变量或成员方法不需要private，protected，public修饰
///2.Dart类如果没有自定义构造函数，内部则会自动定义一个空的构造函数，如果自己自定义了一个构造函数
class Person {
  String name;
  int age;
  String hobby;

//  Person(String name, int age, String hobby) {
//    this.name = name;
//    this.age = age;
//    this.hobby = hobby;
//  }

  /// 构造函数的简写
  Person(this.name, this.age, this.hobby) {
    print("Person():name=$name,age=$age,hobby=$hobby.");
  }

  /// Person(); //error 构造函数和函数一样也没有重载

  /// 命名构造方法
  Person.name(this.name, this.age, this.hobby);

  Person.name2(this.name);

  printPersonInfo() {
    print("my name is $name ,I am $age year old and my hobby is $hobby .");
  }
}

class Human extends Person {
  ///继承父类的构造函数
  Human(String name, int age, String hobby) : super(name, age,hobby) {
    print("Human():name=$name,age=$age,hobby=$hobby.");
  }

  ///  继承父类的命名构造函数
  Human.name(String name, int age, String hobby)
      : super.name(name, age, hobby) {}
}
