main() {
  operator();
  operatorOverLoading();
}

void operator() {
  //自增
  int a = 1;
  var a1 = a++; //先赋值给a1，a再加1
  var a2 = ++a; //先加1，再赋值给a，再赋值给a2
  print("operator:a=1,a++=$a1,++a=$a2");

  //三元运算符
  a1 == a2 ? print("a1==a2 is true") : print("a1==a2 is false");

  //~expr 按位补码（0成为1；1变成0）
  const b = 0X79;
  const bitMask = 0x0f;

  print("operator(&exper):${b & bitMask == 0x09}"); //and
  print("operator(~exper):${b & ~bitMask == 0x70}"); //and not
  print("operator(|exper):${b | bitMask == 0x7f}"); //or
  print("operator(^exper):${b ^ bitMask == 0X76}"); //xor 异或
  print("operator(>>):${b >> 4 == 0x07}"); //右移4位
  print("operator(<<):${b << 4 == 0x790}"); //左移4位

  //is
  var str = "zhangsan";
  print("operator(is):${str is String}");
  print("operator(is!): ${str is! int}");

  //除法
  print("operator(/):1/3=${1 / 3}");
  //取整
  print("operator(~/):1~/3=${1 ~/ 3}");
  //取余
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

///运算符重载
void operatorOverLoading() {
  Vector vector1 = new Vector(6, 8);
  Vector vector2 = new Vector(3, 4);
  var vector3 = vector1 - vector2;
  vector3.printVector();
  var vector4 = vector1 + vector2;
  vector4.printVector();
}

class Vector {
  num x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) {
    return new Vector(this.x + v.x, this.y + v.y);
  }

  Vector operator -(Vector v) => new Vector(this.x - v.x, this.y - v.y);

  void printVector() {
    print("printVector():Vector($x,$y)");
  }
}
