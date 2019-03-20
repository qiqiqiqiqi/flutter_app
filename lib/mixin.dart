//https://juejin.im/post/5c44382d51882523f0261bb5
main() {
  WidgetsFlutterBinding().hitTest();
  print("*******************************");
  //class WidgetsFlutterBinding2 extends BindingBase with GestureBinding, RendererBinding {}
  //WidgetsFlutterBinding2先混入了GestureBinding，后混入RendererBinding
  //WidgetsFlutterBinding2().hitTest()调用的是RendererBinding中的hitTest()方法
  WidgetsFlutterBinding2().hitTest();
  print("*******************************");
  WidgetsFlutterBinding3().hitTest();
  print("*******************************");
  WidgetsFlutterBinding2().testhitTest();
  print("*******************************");
  WidgetsFlutterBinding3().testHitTest();
}

//这次，on只能用于被mixins标记的类，例如mixins X on A，
// 意思是要mixins X的话，得先接口实现或者继承A。
// 这里A可以是类，也可以是接口，但是在mixins的时候用法有区别.+
/*class A {
  void a() {
    print("a");
  }
}

mixin X on A {
  void x() {
    print("x");
  }

  void a() {
    super.a();
    print("X");
  }
}

//on 一个类
class mixinsX extends A with X {}

//on 的是一个接口：得首先实现这个接口，然后再用mix

abstract class B {
  void b() {
    print("b");
  }
}

mixin XX on B {
  void x() {
    print("x");
  }

  void b() {
    super.b();
    print("xb");
  }
}

class mixinsXX extends B with XX {
  @override
  void a() {
    // TODO: implement a
  }
}*/

abstract class BindingBase {
  BindingBase() {
    initInstances();
  }

  void initInstances() {}

  void hitTest() {
    print("BindingBase:hitTest()");
  }
}

abstract class HitTestable {
  factory HitTestable._() => null;

  void hitTest() {
    print("HitTestable:hitTest()");
  }
}

mixin RendererBinding on BindingBase, HitTestable {
  @override
  void hitTest() {
    print("RendererBinding:hitTest()");
    super.hitTest();
  }
}
mixin GestureBinding on BindingBase implements HitTestable {
  @override
  void hitTest() {
    //HitTestable和BindingBase中都有hitTest()方法，根据mixin的线性规则此处复写的是HitTestable中的hitTest()方法
    print("GestureBinding:hitTest()");
    super.hitTest(); //super指在GestureBinding前一个具有hitTest()方法的混入类或超类
  }

  void testhitTest() {
    hitTest();
  }
}

mixin TestBinding on BindingBase, HitTestable {
  @override
  void hitTest() {
    print("TestBinding:hitTest()");
    super.hitTest();
  }

  void testHitTest() {
    hitTest();
  }
}

class WidgetsFlutterBinding extends BindingBase with GestureBinding {}

class WidgetsFlutterBinding2 extends BindingBase
    with GestureBinding, RendererBinding {}

class WidgetsFlutterBinding3 extends BindingBase
    with GestureBinding, TestBinding, RendererBinding {}
