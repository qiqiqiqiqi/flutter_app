import 'package:rxdart/rxdart.dart';

//https://juejin.im/post/5bcea438e51d4536c65d2232
void main() {
//  streamToObservable();
//  futureToObservable();
//  iterableToObservable();
  asBroadcastStream();
}

//stream直接包装成Observable
void streamToObservable() {
  var obs = Observable(Stream.fromIterable([2, 3, 4, 5, 6]));
  obs.listen((data) {
    print('streamToObservable():data=$data');
  });
}

//通过Future创建：fromFuture
void futureToObservable() {
  var obs = Observable.fromFuture(Future.value('Hello'));
  obs.listen((data) {
    print('futureToObservable():data=$data');
  });
}

//通过Iterable创建：fromIterable
void iterableToObservable() {
  Observable.fromIterable([1, 2, 3, 4, 5]).listen((data) {
    print('iterableToObservable():data=$data');
  });
}

//让流的“吐”出间隔一段时间：interval
void interval() {
  Observable.fromIterable([1, 2, 3, 4, 5])
      .interval(Duration(seconds: 1))
      .listen((data) {
    print('interval():data=$data');
  });
}

//迭代地处理数据：map
void map() {
  Observable.fromIterable([1, 2, 3]).map((data) {
    return '$data';
  }).listen((data) {
    print('map():data is String=${data is String}');
  });
}

//扩展流：expand
void expand() {
  Observable.fromIterable([
    [1, 1.0],
    [2, 2.0],
    [3, 3.0]
  ]).expand((data) {
    return data;
  }).listen((data) {
    print('expand():data=$data');
  });
}

//合并流：merge
void merge() {
  // Stream.fromIterable([1, 2, 3]).listen(print);
  Observable.merge([
    Stream.fromIterable([1, 2, 3]),
    Stream.fromIterable([4, 5, 6]),
    Stream.fromIterable([7, 8, 9]),
  ]).listen(print); // prints 2, 1
}

//顺序执行多个流：concat
void concat() {
  // Stream.fromIterable([1, 2, 3]).listen(print);
  Observable.concat([
    Stream.fromIterable([1, 2, 3]),
    Stream.fromIterable([4, 5, 6]),
    Stream.fromIterable([7, 8, 9]),
  ]).listen(print);
}

//检查每一个item：every
//every会检查每个item是否符合要求，然后它将会返回一个能够被转化为 Observable 的 AsObservableFuture< bool>。
void every() {
  Observable.fromIterable([1, 2, 3])
      .every((data) {
        return data < 2;
      })
      .asObservable()
      .listen(print);
}

void flatMap() {
  Observable.fromIterable([1, 2, 3]).flatMap((data) {
    return Observable.just(data);
  }).listen(print);
}

//Dart中 Observables 默认是单一订阅。如果您尝试两次收听它，则会抛出 StateError 。
// 你可以使用工厂方法或者 asBroadcastStream 将其转化为多订阅流。
void asBroadcastStream() {
  var obs =
      Observable(Stream.fromIterable([1, 2, 3, 4, 5])).asBroadcastStream();

  obs.interval(Duration(seconds: 1)).map((item) => '-$item').listen(print);

  obs.listen(print);
}
