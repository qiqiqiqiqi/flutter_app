/**
 * 当你在学习Dart语言时，下面的这些事实和概念请牢记于心：

    1.在Dart中，一切都是对象，一切对象都是class的实例，哪怕是数字类型、方法甚至null都是对象，所有的对象都是继承自Object
    虽然Dart是强类型语言，但变量类型是可选的因为Dart可以自动推断变量类型
    2.Dart支持范型，List<int>表示一个整型的数据列表，List<dynamic>则是一个对象的列表，其中可以装任意对象
    3.Dart支持顶层方法（如main方法），也支持类方法或对象方法，同时你也可以在方法内部创建方法
    4.Dart支持顶层变量，也支持类变量或对象变量
    跟Java不同的是，Dart没有public protected private等关键字，如果某个变量以下划线（_）开头，代表这个变量在库中是私有的，具体可以看这里
    5.Dart中变量可以以字母或下划线开头，后面跟着任意组合的字符或数字
    有时重要的是某事是一个表达还是一个陈述，所以这两个词的精确性是有帮助的
    6.Dart工具可以报告两种问题：警告和错误。警告只是指示代码可能无法工作，但它们不会阻止程序执行。错误可以是编译时，也可以是运行时发生。编译时错误根本不允许代码执行；运行时错误导致代码执行时引发异常

    链接：https://juejin.im/post/5b5005866fb9a04fea589561
 */

///
main() {
  defineVar();
  modifier();
}

/**
 * 你可以明确指定某个变量的类型，如int bool String，也可以用var或 dynamic来声明一个变量，Dart会自动推断其数据类型。
 * var 并不是一个数据类型，但是可以接收任意数据类型
 * 变量的默认值，没有赋初值的变量都会有默认值null
 */

///
void defineVar() {
  /**
   * numbers
   */
  int a = 7;
  var b = 8;
  dynamic c = 9;
  print("int:a=$a," + "b=$b," + "c=$c");

  double dou = 2.7;
  dou.toInt();
  //dou = a as double;//type 'int' is not a subtype of type 'double' in type cast,和java不一样，不能向上强转
  var doub = 2.8;
  doub.toInt();
  dynamic doubl = 3.2;
  (doubl as double).toInt();
  print("double:dou=$dou,doub=$doub,doubl=$doubl");
  print(
      "double:dou.toInt()=${dou.toInt()},doub.toInt()=${doub.toInt()},(doubl as double).toInt()=${(doubl as double).toInt()}");

  /**
   * bool
   */
  bool bo = true;
  var boo = false;
  dynamic boo_l = true;

  /**
   * string
   */

  String str = 'hahah';
  var stri = "zhangsan";
  dynamic strin = "lisi";
  /**
   * list
   */
  List<dynamic> dynamicList = [1, 2, 3];
  List<dynamic> dynamicList2 = [5, 2, 3];
  dynamicList.add(4);
  dynamicList.add(bo);
  dynamicList.addAll(dynamicList2);

  List<int> list = [7, 8, 9];
  list.add(1);
  //The keyword 'var' can't be used as a type name.
  // The name 'var' isn't a type so it can't be used as a type argumen
  List varList = [1, 2, 3];
  varList.add(dynamicList);
  /**
   * map
   */
  Map map = new Map();
  map["name"] = "lilei";
  map["age"] = 18;

  print("map:map=$map, map is Map ${map is Map}");

  /**
   * symbol
   *
   * 字面量是编译时常量，在标识符前面加#。如果是动态确定，
   * 则使用Symbol构造函数，通过new来实例化.你可能永远也不用不到Symbol
   *  symbols
   */

  print(#s == new Symbol("g")); // true
}

/**
 * 注意：实例变量可以是final的但不能是const的
 *
 * 如果你绝不想改变一个变量，使用final或const，不要使用var或其他类型，
 * 一个被final修饰的变量只能被赋值一次，一个被const修饰的变量是一个编译时常量（const常量毫无疑问也是final常量）。
 * 可以这么理解：final修饰的变量是不可改变的，而const修饰的表示一个常量。
 *
 * final和const的区别：
    区别一：final 要求变量只能初始化一次，并不要求赋的值一定是编译时常量，可以是常量也可以不是。而 const 要求在声明时初始化，并且赋值必需为编译时常量。
    区别二：final 是惰性初始化，即在运行时第一次使用前才初始化。而 const 是在编译时就确定值了

    链接：https://juejin.im/post/5b5005866fb9a04fea589561

 */

///
void modifier() {
  List<int> constList = const [1, 2];
  //const 修饰的list长度不可改变 Cannot add to an unmodifiable list
  //constList.add(3);
  final List<dynamic> finalList = [3, 4];
  //final 修饰的list长度可改变
  finalList.add(5);
}
