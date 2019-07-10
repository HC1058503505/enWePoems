import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/pages/find/search_controller.dart';

class SearchView extends StatelessWidget {
  SearchView();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black26, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
            return SearchController();
          }));
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Icon(
                Icons.search,
                color: Colors.black45,
              ),
            ),
            Expanded(
              child: Text(
                "发现更多精彩",
                style: TextStyle(color: Colors.black26),
              ),
            )
          ],
        ),
      ),
    );
  }
}
