
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/pages/taglist/tag_poems_list.dart';
import 'package:flutterapp/models/poem_tags.dart';
class TagCategoryLabel extends StatefulWidget {
  TagCategoryLabel({this.labels});
  List<PoemTagSection> labels;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TagCategoryLabelState();
  }
}
class _TagCategoryLabelState extends State<TagCategoryLabel> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 10, 0, MediaQuery.of(context).padding.bottom),
      itemBuilder: (context, index){
        PoemTagSection labelSection = widget.labels[index];
        return Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                      color: Colors.black,
                      width: 5,
                    )
                )
              ),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20),
              padding: EdgeInsets.only(left: 5),
              child: Text(labelSection.section_title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                  ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Wrap(
                runSpacing: 7,
                spacing: 7,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: labelSection.items.map<Widget>((item){
                  return FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                            color: Colors.black12,
                            style: BorderStyle.solid
                        )
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) {
                            return PoemsTagList(
                                tagStr: item, tagType: TagType.Normal);
                          })
                      );
                    },
                    child: Text(item),
                  );
                }).toList(),
              ),
            )
          ],
        );
      },
      itemCount: widget.labels.length,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}