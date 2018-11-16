import 'dart:async';
import 'package:http/http.dart' as http;

///1.await关键字必须在async函数内部使用
///2.调用async函数必须使用await关键字
void main() {
  setData();
  futureFunction(); //  当所有任务完成后的回调函数

}

void futureFunction() {
  var future = new Future(() => futureTask) //  异步任务的函数
      .then((m) => "futueTask execute result:$m") //   任务执行完后的子任务
      .then((m) => m.length) //  其中m为上个任务执行完后的返回的结果
      .then((m) => printLength(m))
      .whenComplete(() => whenTaskCompelete); //  当所有任务完成后的回调函数
}

int futureTask() {
  return 22;
}

void printLength(int length) {
  print("Text Length:$length");
}

void whenTaskCompelete() {
  print("Task Complete");
}

getData() async {
  //async关键字声明该函数内部有代码需要延迟执行
  return await http.get(Uri.encodeFull("http://www.baidu.com"),
      headers: {"Accept": "application/json"}); //await关键字声明运算为延迟执行，然后return运算结果
}

setData() async {
  http.Response data = await getData();
  print(data.body);
}
