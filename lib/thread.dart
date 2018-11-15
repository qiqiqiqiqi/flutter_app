
import 'dart:async';
import 'package:http/http.dart' as http;


main(){
  getNetData().then((str) {
    print(str);
  });
}
Future<String> getNetData() async{
  http.Response res = await http.get("http://www.baidu.com");
  return res.body;
}

