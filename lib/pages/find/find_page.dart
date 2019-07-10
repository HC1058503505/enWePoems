import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/poem_tags.dart';
import 'package:flutterapp/pages/find/search_view.dart';
import 'package:flutterapp/pages/taglist/tag_poems_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/pages/taglist/tag_category.dart';
class FindPage extends StatefulWidget {
  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  PoemSearchConditions _searchConditions;
  TextEditingController _editingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSearchConditions();
  }

  Future<void> _getSearchConditions() async {
    String searchContentStr =
        await rootBundle.loadString("lib/sources/search_conditions.json");
    Map<String, dynamic> searchData =
        json.decode(searchContentStr) as Map<String, dynamic>;

    setState(() {
      _searchConditions = PoemSearchConditions.parseJSON(searchData);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_searchConditions == null) {
      return GestureDetector(
        onTap: () {
          _getSearchConditions();
        },
        child: Container(
          child: Center(
            child: Text(
              "点击重试",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
      );
    }
    return Container(
      child: Column(
        children: <Widget>[
          SearchView(),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _searchConditions.hotsearchs.length,
                itemBuilder: (context, index) {
                  PoemTagHotSearch search = _searchConditions.hotsearchs[index];
                  List<String> hotKeyList = search.hotkeys;
                  if (search.type == "poet") {
                    hotKeyList = hotKeyList.map<String>((item) {
                      return item.split("|").first;
                    }).toList();
                  }
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 18,
                                width: 5,
                                color: Theme.of(context).primaryColor,
                              ),
                              Text(
                                search.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15, color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        ),
                        Wrap(
                          children: hotKeyList.map<Widget>((item) {
                            return FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    CupertinoPageRoute(builder: (context) {
                                  String tagStr = item;
//                                    if (index == 1) {
//                                      int indexItem = hotKeyList.indexOf(item);
//                                      tagStr = search.hotkeys[indexItem].split("|").last;
//                                    }
                                  TagType tagType = TagType.Normal;
                                  switch (index) {
                                    case 0:
                                      tagType = TagType.Category;
                                      return TagCategoryView(searchConditions: _searchConditions, index: hotKeyList.indexOf(item),);
                                    case 1:
                                      tagType = TagType.Author;
                                      break;
                                    case 2:
                                      tagType = TagType.Dynasty;
                                      break;
                                    case 3:
                                      break;
                                    case 4:
                                      tagType = TagType.Collections;
                                      break;
                                    default:
                                      break;
                                  }
                                  return PoemsTagList(
                                      tagStr: tagStr, tagType: tagType);
                                }));
                              },
                              child: Text(
                                item,
                                style: TextStyle(fontSize: 12),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(
                                    color: Colors.black26,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            );
                          }).toList(),
                          spacing: 7,
                          runSpacing: 7,
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
