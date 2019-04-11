import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(home: SplashScreen()));
}

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyHomePage()),
            (route) => route == null);
      }
    });
    //播放动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      //透明度动画组件
      opacity: _animation, //执行动画
      child: Image.asset(
          //网络图片
          'images/bg_guide_page2.png',
          fit: BoxFit.cover // 充满父容器
          ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('首页')), body: Center(child: Text('我是首页')));
  }
}
