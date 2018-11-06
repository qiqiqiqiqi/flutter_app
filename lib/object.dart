main() {
  var person = new Person("zhangsan", 18, "play game");
  person..printPersonInfo();
  person.name = "lisi";
  person.age = 17;
  person.hobby = "trip";
  person.printPersonInfo();
  person=new Person.name("wangwu", 12, "sleep");
}

class Person {
  String name;
  int age;
  String hobby;

  Person(this.name, this.age, this.hobby);

  Person.name(this.name, this.age, this.hobby);

  printPersonInfo() {
    print("my name is $name ,I am $age year old and my hobby is $hobby .");
  }
}
