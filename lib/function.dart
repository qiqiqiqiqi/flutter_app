/**
 * main()函数
    不论在Dart还是Flutter中，必须都需要一个顶层的main()函数，
    它是整个应用的入口函数，main()函数的返回值是void，还有一个可选的参数，参数类型是List<String>。
 */

main() {
  functionToParameter(8);
  functionToVar();
}

/**
 * 函数作为一类对象你可以将一个函数作为参数传给另一个函数，比如下面的代码：
 */
functionToParameter(int i) {
  var array = [1, 2, 3];
  array.forEach(print);
}

/**
 * 函数作为一类对象将一个函数赋值给某个变量，比如下面的代码：
 */
functionToVar() {

  var f1 = print;
  f1 = print;
  var f = functionToParameter;
  f = functionToParameter;
  Function f2 = print;
  var f3 = (var v) => print('v=$v');
  f1('f1');
  f2('f2');
  f3('f3');
  f(7);
}
