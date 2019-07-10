import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.isLoading});
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isLoading,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
