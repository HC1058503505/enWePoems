import 'package:flutter/material.dart';

typedef OnTapCallback = void Function();

class RetryPage extends StatelessWidget {
  RetryPage({this.offstage, this.onTap});
  final bool offstage;
  final OnTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: offstage,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Center(
            child: Text(
              "点击重试",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
