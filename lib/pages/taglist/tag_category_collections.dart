
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_tags.dart';
import 'package:flutterapp/pages/taglist/tag_poems_list.dart';
class TagCategoryCollections extends StatefulWidget {
  TagCategoryCollections({this.collections});
  final List<PoemTagCollections> collections;


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TagCategoryCollectionsState();
  }
}

class _TagCategoryCollectionsState extends State<TagCategoryCollections> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index){

          PoemTagCollections collection = widget.collections[index];

          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) {
                    return PoemsTagList(
                        tagStr: collection.name, tagType: TagType.Collections);
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
                        child: Text(collection.name, style: TextStyle(fontSize: 16),),
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
                        child: Text(collection.count + "首", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
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
        itemCount: widget.collections.length
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

