import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/pages/taglist/tag_poems_list.dart';

class PoemTagPage extends StatelessWidget {
  PoemTagPage({this.tagStr, this.pushContext});
  final String tagStr;
  final BuildContext pushContext;
  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: tagStr.length <= 0,
      child: Wrap(
        children: tagStr.split("|").map<Widget>((tagItem) {
          return GestureDetector(
            onTap: () {
              Navigator.of(pushContext)
                  .push(CupertinoPageRoute(builder: (context) {
                return PoemsTagList(tagType: TagType.Normal, tagStr: tagItem);
              }));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  tagItem,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
