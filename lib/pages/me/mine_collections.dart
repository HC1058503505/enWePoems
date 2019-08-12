import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/pages/recommand/poem_cell.dart';
import 'package:flutterapp/pages/detail/poem_detail.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:io';
import 'package:flutterapp/pages/taglist/poems_list_cell.dart';

enum MineCollectionsType { colloections, records }

class MineCollections extends StatefulWidget {
  MineCollections({this.collectionsType});
  final MineCollectionsType collectionsType;

  @override
  _MineCollectionsState createState() => _MineCollectionsState();
}

class _MineCollectionsState extends State<MineCollections> {
  int _page = 0;
  List<PoemRecommend> _collections = List<PoemRecommend>();
  ScrollController _scrollController = ScrollController();
  PoemRecommendProvider provider = PoemRecommendProvider.singleton;
  String _tipStr = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tipStr = widget.collectionsType == MineCollectionsType.colloections
        ? "收藏"
        : "浏览记录";
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page++;
        _getCollections();
      }
    });
    _getCollections();
  }

  void _getCollections() async {
    PoemRecommendProvider provider = PoemRecommendProvider.singleton;
    await provider.open(DatabasePath);
    String tableNameStr =
        widget.collectionsType == MineCollectionsType.colloections
            ? tableCollection
            : tableRecords;
    provider
        .getPoemRecomsPaging(tableName: tableNameStr, limit: 10, page: _page)
        .then((collectionList) {
      if (collectionList == null) {
        return;
      }

      if (_page == 0) {
        _collections.clear();
      }

      setState(() {
        _collections.addAll(collectionList);
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future _onRefresh() async {
    _page = 0;
    _getCollections();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    provider.close();
    dismissAllToast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("我的$_tipStr"),
        actions: <Widget>[
          Offstage(
            offstage: _collections == null || _collections.length <= 0,
            child: IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () {
                  clearCollections();
                }),
          ),
        ],
      ),
      body: collectionsListView(),
    );
  }

  void sureClear() {
    provider.deleteAll(tableName: tableCollection).then((dynamic) {
      Navigator.of(context).pop();
      showToast("清除成功");
      setState(() {
        _collections.clear();
      });
    }).catchError((error) {
      showToast("清除失败");
    }).whenComplete(() {});
  }

  void clearCollections() {
    if (!Platform.isIOS && !Platform.isMacOS) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("温馨提示"),
              content: Text("确定清除全部$_tipStr吗？"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    sureClear();
                  },
                  child: Text(
                    "确定",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "取消",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            );
          });
      return;
    }

    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("温馨提示"),
            content: Text("确定清除全部$_tipStr吗？"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  "取消",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  "确定",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  sureClear();
                },
              )
            ],
          );
        });
  }

  Widget collectionsListView() {
    if (_collections == null || _collections.length == 0) {
      return Container(
        color: Colors.white,
        child: Center(
          child: Text("您的$_tipStr夹空空如也哦！"),
        ),
      );
    }
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (contextList, index) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(_collections[index].idnew),
                child: GestureDetector(
//                  child: PoemCell(poem: _collections[index], showStyle: PoemShowStyle.PoemShowSingleLine,),
                  child: PoemsListCell(
                    poem: _collections[index],
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    pushContext: context,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) {
                      return PoemDetail(poemRecom: _collections[index]);
                    }));
                  },
                ),
                onDismissed: (direction) {
                  PoemRecommendProvider provider =
                      PoemRecommendProvider.singleton;
                  provider
                      .delete(
                          tableName: tableCollection,
                          id: _collections[index].idnew)
                      .then((dynamic) {
                    showToast("删除$_tipStr成功");
                    setState(() {
                      _collections.removeAt(index);
                    });
                  }).catchError((error) {
                    showToast("删除$_tipStr失败");
                  }).whenComplete(() {});
                },
                background: new Container(color: Colors.red),
              );
            },
            itemCount: _collections == null ? 0 : _collections.length,
          ),
          onRefresh: _onRefresh),
    );
  }
}
