import 'package:flutter/material.dart';

class SportPopupMenuEntry<T> extends PopupMenuEntry<T> {
  @override
  State<StatefulWidget> createState() {
    return SportPopupMenuEntryState();
  }

  @override
  double get height => 42;

  const SportPopupMenuEntry({
    Key key,
    this.value,
    this.enabled = true,
    @required this.child,
  }) : assert(enabled != null),
        super(key: key);

  /// The value that will be returned by [showMenu] if this entry is selected.
  final T value;

  /// Whether the user is permitted to select this entry.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
  final bool enabled;



  /// The widget below this widget in the tree.
  ///
  /// Typically a single-line [ListTile] (for menus with icons) or a [Text]. An
  /// appropriate [DefaultTextStyle] is put in scope for the child. In either
  /// case, the text should be short enough that it won't wrap.
  final Widget child;

  @override
  bool represents(T value) => value == this.value;
}

class SportPopupMenuEntryState extends State<SportPopupMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 100,
      child: Row(
        children: <Widget>[
          Image.asset(
            'images/datarecord/ic_bate_paobu.png',
            package: 'hb_solution',
            width: 24,
            height: 24,
            fit: BoxFit.cover,
          ),
          Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                '跑步',
                style: TextStyle(
                    color: Color(0xFF374147),
                    fontSize: 14,
                    decoration: TextDecoration.none),
              ))
        ],
      ),
    );
    ;
  }
}
