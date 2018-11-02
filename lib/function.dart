/**
 * main()函数
    不论在Dart还是Flutter中，必须都需要一个顶层的main()函数，
    它是整个应用的入口函数，main()函数的返回值是void，还有一个可选的参数，参数类型是List<String>。
 */

///
main() {
  functionReturnValue();
  functionAsParameter();
  functionAsVar();
}

///函数的返回值
void functionReturnValue() {
  String str = "haha";
  int sum = add(3, 4);
  int sum2 = add2(3, 5);
  double sum3 = add3(3, 6);
  String addNumStr = addNumString(7, "haha");
  String addStr = addString("hello", ",world");
  print(
      "functionReturnValue:sum=$sum,sum2=$sum2,sum3=$sum3,addNumStr=$addNumStr,addStr=$addStr");
}

int add(int a, int b) {
  return a + b;
}

add2(int a, int b) {
  return a + b;
}

add3(int a, double b) => a + b;

///num 与string不能通过“+”来相加来拼接成一个字符串
addNumString(int a, String str) => "$a$str";

addString(String str1, String str2) => str1 + str2;


///************************************************************************************
///函数作为一类对象你可以将一个函数作为参数传给另一个函数，比如下面的代码：
functionAsParameter() {
  var array = [1, 2, 3];
  array.forEach(print);
}

///函数作为一类对象将一个函数赋值给某个变量，比如下面的代码：
functionAsVar() {
  var f1 = print;
  f1 = print;
  var f = functionAsParameter;
  f = functionAsParameter;
  Function f2 = print;
  var f3 = (var v) => print('v=$v');
  f1('f1');
  f2('f2');
  f3('f3');
  f();
}
