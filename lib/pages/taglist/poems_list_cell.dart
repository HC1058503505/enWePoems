import 'package:flutter/material.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/pages/detail/poem_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

class PoemsListCell extends StatelessWidget {
  PoemsListCell({this.poem, this.padding, this.pushContext});
  final PoemRecommend poem;
  final EdgeInsets padding;
  final BuildContext pushContext;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(pushContext).push(CupertinoPageRoute(builder: (context) {
          return PoemDetail(poemRecom: poem);
        }));
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(padding.left, 15, padding.right, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(poem.nameStr,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 20),
                  Text(poem.chaodai + ' / ' + poem.author,
                      style: TextStyle(color: Colors.black26))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Html(
                  data: poem.cont.split(RegExp("\n")).first,
                  defaultTextStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Divider(
              indent: padding.left,
              height: 0,
              color: Colors.black26,
            )
          ],
        ),
      ),
    );
  }
}
