
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_tags.dart';
import 'package:flutterapp/pages/taglist/tag_poems_list.dart';
class TagCategoryDynasty extends StatefulWidget {
  TagCategoryDynasty({this.dynastys});
  final List<PoemTagDynasty> dynastys;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TagCategoryDynastyState();
  }
}

class _TagCategoryDynastyState extends State<TagCategoryDynasty> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index){

          PoemTagDynasty dynasty = widget.dynastys[index];

          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) {
                    return PoemsTagList(
                        tagStr: dynasty.name, tagType: TagType.Dynasty);
                  })
              );
            },
            child: Container(
              color: Colors.white10,
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(dynasty.name, style: TextStyle(fontSize: 16),),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white10,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Text(dynasty.count + "首", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index){
          return Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 10,
          );
        },
        itemCount: widget.dynastys.length
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}