main() {
  operator();
}

void operator() {
  //自增
  int a = 1;
  var a1 = a++; //先赋值，再加1
  var a2 = ++a; //先加1，再赋值
  print("operator:a1=$a1,a2=$a2");

  //三元运算符
  a1 == a2 ? print("a1==a2 is true") : print("a1==a2 is false");

  //is
  var str = "zhangsan";
  print("operator(is):${str is String}");
  print("operator(is!): ${str is! int}");

  //除法,取整，取余
  print("operator(/):1/3=${1 / 3}");
  print("operator(~/):1~/3=${1 ~/ 3}");
  print("operator(%):1%3=${1 % 3}");

  // ??= 操作符左边的变量如果为null则赋值，否则不赋值
  var v1 = 7, v2;
  print(
      "operator(??=):v1=$v1,v2=$v2;v1 ??= 8,v1=${v1 ??= 8};v2 ??=9,v2=${v2 ??= 9}");

  // ?. 对象的非空判断，在对象调用自身的方法或属性时先判断该对象是否为null
  var str1 = "zhangsan";
  print("operator(?.):str1.length=${str1?.length}");
  str1 = null;
  print("operator(?.):str1.length=${str1?.length}");
  //print("operator(?.):str1.length=${str1.length}");//报错

  //.. 级联操作,使用..调用某个对象的方法（或者成员变量）时，返回值是这个对象本身.
  var person = new Person();
  //person.name();
  person
    ..name1
    ..name();
  person
    ..name()
    ..age()
    ..hobby();
}

class Person {
  String name1;

  void name() {
    try {
      print("my name is ...");
    } catch (e) {
      print(e);
    }
  }

  void age() {
    try {
      print("my age is ...");
    } catch (e) {
      print(e);
    } finally {}
  }

  void hobby() {
    try {
      print("my hobby is ...");
      1 ~/ 0;
    } catch (e) {
      print(e);
    }
  }
}
