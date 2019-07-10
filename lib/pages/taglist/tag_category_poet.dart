import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_tags.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutterapp/pages/taglist/tag_poems_list.dart';

class TagCategoryPoet extends StatefulWidget {
  TagCategoryPoet({this.authors});

  final List<PoemTagAuthor> authors;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TagCategoryPoetState();
  }
}

class _TagCategoryPoetState extends State<TagCategoryPoet>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            slivers: authorsCategory(context),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black.withAlpha(10),
                borderRadius: BorderRadius.all(Radius.circular(40))),
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            margin: EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            width: 44,
            height: (widget.authors.length + 1) * 20.0 + 10,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              itemExtent: 20,
              children: widget.authors.map<Widget>((author) {
                int index = widget.authors.indexOf(author);
                return GestureDetector(
                  onTap: () {
                    int temp = 0;
                    for (int i = 0; i < index; i++) {
                      temp += (widget.authors[i].list.length + 1);
                    }
                    _scrollController.animateTo(50.0 * temp,
                        duration: Duration(milliseconds: 250),
                        curve: Curves.decelerate);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(author.title, textAlign: TextAlign.center),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> authorsCategory(BuildContext context) {
    List<Widget> temp = List<Widget>();
    for (PoemTagAuthor author in widget.authors) {
      Widget titleWidget = SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 20),
          height: 50,
          color: Colors.black.withAlpha(10),
          child: Text(
            author.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.centerLeft,
        ),
      );

      temp.add(titleWidget);

      SliverFixedExtentList extentList = SliverFixedExtentList(
        delegate: SliverChildListDelegate(author.list.map<Widget>((authorItem) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return PoemsTagList(
                    tagStr: authorItem.poet_name, tagType: TagType.Author);
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withAlpha(12),
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          authorItem.poet_name,
                          style: TextStyle(fontSize: 16),
                        ),
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
                        child: Text(
                          authorItem.poetry_count + "首",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList()),
        itemExtent: 50,
      );

      temp.add(extentList);
    }

    return temp;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _PoemTagInfo extends ISuspensionBean {
  _PoemTagInfo({this.name, this.tag, this.idnew});
  final String name;
  final String tag;
  final String idnew;

  @override
  String getSuspensionTag() {
    // TODO: implement getSuspensionTag
    return tag;
  }
}
