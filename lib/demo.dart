//https://juejin.im/post/5b5005866fb9a04fea589561
/**
 * 重要概念
    当你在学习Dart语言时，下面的这些事实和概念请牢记于心：

    在Dart中，一切都是对象，一切对象都是class的实例，哪怕是数字类型、方法甚至null都是对象，所有的对象都是继承自Object
    虽然Dart是强类型语言，但变量类型是可选的因为Dart可以自动推断变量类型
    Dart支持范型，List<int>表示一个整型的数据列表，List<dynamic>则是一个对象的列表，其中可以装任意对象
    Dart支持顶层方法（如main方法），也支持类方法或对象方法，同时你也可以在方法内部创建方法
    Dart支持顶层变量，也支持类变量或对象变量
    跟Java不同的是，Dart没有public protected private等关键字，如果某个变量以下划线（_）开头，代表这个变量在库中是私有的，具体可以看这里
    Dart中变量可以以字母或下划线开头，后面跟着任意组合的字符或数字
    有时重要的是某事是一个表达还是一个陈述，所以这两个词的精确性是有帮助的
    Dart工具可以报告两种问题：警告和错误。警告只是指示代码可能无法工作，但它们不会阻止程序执行。错误可以是编译时，也可以是运行时发生。编译时错误根本不允许代码执行；运行时错误导致代码执行时引发异常。

 */
main() {
  //number
  var number ;
  printInteger(number);
  const int a = 77;
  const List<int> constList = [1, 2];
  //constList.add(3);//const 修饰的list长度不可改变 Cannot add to an unmodifiable list
  printConst(constList);

  final List<dynamic> finalList = [3, 4];
  finalList.add(5);
  printFinal(finalList);
  //String
  String name = "zhangsan";
  printString(name);
  bool bo = true;
  printBool(bo);
  //list
  List<String> lists = new List();
  lists.add('1');
  lists.add('2');
  lists.add('3');
  //printList(lists);
  lists.forEach(printString);

  //map
  Map map = new Map();
  map['a'] = 'a';
  map['b'] = 'b';
  printVarToString(map);

  //emoji
  var clapping = '\u{1f44f}';
  printEmoji(clapping); // 打印的是拍手emoji的表情

  //函数的返回值
  printInteger(add(1, 2));
  printInteger(add2(4, 2));
  printInteger(add3(5, 2));

  sayHello(name: "皇阿玛");
  sayHello2(name: "皇阿玛2");
  sayHello();
  sayHello3("皇阿玛", 18, "sleep");
  sayHello3("皇阿玛", 18);

  printInteger(add4(a: 4));
  printInteger(add5(8, 7));
  printInteger(add5(8, 7, 6));
}

printInteger(int number) {
  print('the number is a $number.');
}

/**
 * final和const的区别：
    区别一：final 要求变量只能初始化一次，并不要求赋的值一定是编译时常量，可以是常量也可以不是。而 const 要求在声明时初始化，并且赋值必需为编译时常量。
    区别二：final 是惰性初始化，即在运行时第一次使用前才初始化。而 const 是在编译时就确定值了。

 */
printConst(var constInt) {
  print('the constInt is $constInt.');
}

printFinal(var finalVar) {
  print('finalVar=' + finalVar.toString());
}

printString(String content) {
  print('this string is $content.');
}

printBool(bool bo) {
  print('the bo is $bo.');
}

printList(List<Object> list) {
  print('list=' + list.toString());
  for (var value in list) {
    print('value=$value');
  }
  for (int i = 0; i < list.last; i++) {
    print('list[$i]=${list[i]}');
  }

// Iterable<Object> iterator = list.iterator as Iterable<Object>;
//  while(iterator.)
}

printVarToString(var va) {
  print("va=" + va.toString());
}

printEmoji(var va) {
  print(va);
}

/**
 * 函数的返回值
    Dart是一个面向对象的编程语言，所以即使是函数也是一个对象，也有一种类型Function，
    这就意味着函数可以赋值给某个变量或者作为参数传给另外的函数。虽然Dart推荐你给函数加上返回值，
    但是不加返回值的函数同样可以正常工作，另外你还可以用=>代替return语句，比如下面的代码：

 */
int add(int a, int b) {
  return a + b;
}

add2(int a, int b) {
  return a + b;
}

add3(int a, int b) => a + b;

/**
 *命名参数
 * 定义命名参数时，你可以以{type paramName}或者{paramName: type}两种方式声明参数，
 * 而调用命名参数时，需要以funcName(paramName: paramValue)的形式调用。
 *
 * 命名参数的参数并不是必须的，所以上面的代码中，如果调用sayHello()不带任何参数，也是可以的，
 * 只不过最后打印出来的结果是：hello, my name is null，在Flutter开发中，
 * 你可以使用@required注解来标识一个命名参数，这代表该参数是必须的，你不传则会报错

 */

sayHello({String name}) {
  print("hello,my name is $name.");
}

sayHello2({name: String}) {
  print("hello,my name is $name.");
}

/**
 * 使用中括号[]括起来的参数是函数的位置参数，代表该参数可传可不传，
 * 位置参数只能放在函数的参数列表的最后面，如下代码所示：
 */
sayHello3(String name, int age, [String hobby]) {
  if (hobby == null) {
    print("hello,my name is $name and I am $age year old.");
  } else {
    print(
        "hello,my name is $name and I am $age year old and my hobby is $hobby.");
  }
}

/**
 * 参数默认值
    你可以为命名参数或者位置参数设置默认值，如下代码所示：
 */
// 命名参数的默认值
add4({int a, int b = 7}) => a + b;
// 位置参数的默认值
add5(int a, int b, [int c = 7]) => a + b + c;
