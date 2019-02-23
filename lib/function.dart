/// main()函数
/// 不论在Dart还是Flutter中，必须都需要一个顶层的main()函数，
/// 它是整个应用的入口函数，main()函数的返回值是void，还有一个可选的参数，参数类型是List<String>。

/// 小结：
/// 1.函数不能重名，函数的重载是通过可选“命名参数”或“位置参数”是否赋值来重载同名函数
/// 2.函数作为一个对象他的具体类型是Function ，也可用var和dynamic接收；
/// 3.命名参数、位置参数调用时可以不传参数，说明其是有默认值的（默认值为null）；
/// 4.函数如果没有声明返回值类型，默认的返回值类型是dynamic；函数如果定义了返回值类型但是没有返回值，返回值是null；
/// 5.dynamic，Function，Object 定义函数的变量是可变的；
/// Object 和 dynamic 都使得我们可以接收任意类型的参数，但两者的区别非常的大。
/// 使用 Object 时，我们只是在说接受任意类型，我们需要的是一个 Object。类型系统会保证其类型安全。
/// 使用 dynamic 则是告诉编译器，我们知道自己在做什么，不用做类型检测。
/// 使用var定义的函数变量，一旦被赋值了会自动推断函数的返回值及参数的类型和参数个数；再次赋值时如果匹配不上则会报错(返回值(自上而下的规则),参数的类型(自下而上的规则))
///
main() {
  functionReturnValue();
  //函数如果没有标明返回值类型，默认的返回值类型是dynamic；函数如果定义了返回值类型但是没有返回值，返回值是null；
  dynamic functionAsParameterReturnValue = functionAsParameter();
  print("functionAsParameterReturnValue=$functionAsParameterReturnValue");
  functionNamedParam( "named param",age:12);
  functionNameParam2(name: "named param 2");
  functionLocationParam("zhangsan");
  functionLocationParam("zhangsan", 19);
  functionLocationParam("zhangsan", 20, "play game");
  functionAsVar();
}

///函数的返回值
void functionReturnValue() {
  int sum = add(3, 4);
  int sum2 = add2(3, 5);
  dynamic sum3 = add3(3, 6);


  String addNumStr = addNumString(7, "haha");
  String addStr = addString("hello", ",world");
  print(
      "functionReturnValue:sum=$sum,sum2=$sum2,sum3=$sum3,addNumStr=$addNumStr,addStr=$addStr");
  //运行结果：functionReturnValue:sum=7,sum2=8,sum3=9,addNumStr=7haha,addStr=hello,world
}

///******************************函数的返回值 start******************************************************
///声明返回值
int add(int a, int b) {
  return a + b;
}

///不声明返回值
add2(dynamic a, int b) {
  return a + b;
}

///return 的简写
 add3(dynamic a, num b) => a + b;

String add4(dynamic a, String b) {
  return "$a+$b";
}

int add5(var a, var b) {
  return 0;
}

///num 与string不能通过“+”来相加来拼接成一个字符串
addNumString(int a, String str) => "$a$str";

///****************************函数的返回值 end********************************************************

addString(String str1, String str2) => str1 + str2;

///可选命名参数
///命名参数不是必须的传递的,使用花括号将函数的参数括起来就是定义了命名参数
/// 命名参数、位置参数调用时可以不传参数，说明其是有默认值的（默认值为null）
functionNamedParam(String name,{ int age }) {
  //可设置默认值
  print("functionNamedParam():name=$name,age=$age");
}

void functionNameParam2({name: String}) {
  //不可设置默认值
  print("functionNameParam2():name=$name");
}

///可选位置参数
///使用中括号[]括起来的参数是函数的位置参数，代表该参数可传可不传，
/// 位置参数只能放在函数的参数列表的最后面
void functionLocationParam(String name, [int age = 18, String hobby]) {
  //可设置默认值
  print("functionLocationParam():name=$name,age=$age,hobby=$hobby.");
}

///函数作为一类对象你可以将一个函数作为参数传给另一个函数
functionAsParameter() {
  var array = [1, 2, 3];
  array.forEach(print);
}

///函数作为一类对象将一个函数赋值给某个变量
functionAsVar() {
  Function function_f = print;
  function_f("functionAsVar:function_f");
  function_f = add; //Function 定义的函数变量是可变的
  function_f(3, 6);

  dynamic dynamic_f = print;
  dynamic_f("functionAsVar:dynamic_f");
  dynamic_f = functionAsParameter; ////dynamic 定义函数的变量是可变的
  dynamic_f();
  dynamic_f=add;
 // dynamic_f(1,2,3);编译不报错，运行出错

  Object object_f = print;
  (object_f as Function)("functionAsVar:object_f");
  object_f = add; // Object定义的函数变量是可变的，并且使用时需要强转成函数再调用
  (object_f as Function)(3, 6);
  print(
      "functionAsVar:(object_f as Function)(3,6)=${(object_f as Function)(3, 6)}");

  var var_f = add2;
  print("functionAsVar:add2(3,9)=${var_f(3, 9)}");
  var_f =
      add3; //  var定义的函数变量，一旦被赋值了会自动推断函数的返回值及参数的类型和参数个数；再次赋值时如果匹配不上则会报错(返回值(自上而下的规则),参数的类型(自下而上的规则))，var 定义的function 变量不建议修改变量
  print("functionAsVar:add4(3,9)=${var_f(3, 9)}");
  var_f = add5;
  print("functionAsVar:add5(3,9)=${var_f(3, 9)}");

  dynamic f3 = (int a, int b) => a + b;
  print("functionAsVar:f3(4,9)=${f3(4, 9)}");
}
