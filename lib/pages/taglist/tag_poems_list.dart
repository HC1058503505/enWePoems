import 'package:flutter/material.dart';
import 'package:flutterapp/tools/dio_manager.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/pages/taglist/poems_list_cell.dart';
import 'package:flutterapp/pages/detail/loading.dart';
import 'package:flutterapp/pages/detail/error_retry_page.dart';

enum TagType { Normal, Author, Dynasty, Collections, Category }

class PoemsTagList extends StatefulWidget {
  PoemsTagList({this.tagType, this.tagStr});
  final TagType tagType;
  final String tagStr;

  @override
  _PoemsTagListState createState() => _PoemsTagListState();
}

class _PoemsTagListState extends State<PoemsTagList> {
  int _page = 1;
  String _navTitle = "";
  ScrollController _scrollController = ScrollController();
  List<PoemRecommend> _poemList = <PoemRecommend>[];
  int _sumPage = 1;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _page++;
        _getMoreTagList();
      }
    });

    _getMoreTagList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void _getMoreTagList() async {
    if (_page > _sumPage) {
      return;
    }

    if (_poemList.length == 0) {
      setState(() {
        _isLoading = true;
      });
    }

    Map<String, dynamic> _postData = {
      "token": "gswapi",
      "id": "",
      "page": _page
    };
    if (widget.tagType == TagType.Normal ||
        widget.tagType == TagType.Collections) {
      _postData.addAll({"tstr": widget.tagStr});
      _navTitle =
          (widget.tagType == TagType.Normal ? "标签." : "诗集.") + widget.tagStr;
    } else if (widget.tagType == TagType.Dynasty) {
      _postData.addAll({"cstr": widget.tagStr});
      _navTitle = "朝代." + widget.tagStr;
    } else if (widget.tagType == TagType.Author) {
      _postData.addAll({"astr": widget.tagStr});
      _navTitle = "诗人." + widget.tagStr;
    }

    DioManager.singleton
        .post(path: "api/shiwen/Default.aspx", data: _postData)
        .then((response) {
          _sumPage = response["sumPage"] as int;
          List<dynamic> gushiwens = response["gushiwens"] as List<dynamic>;
          List<PoemRecommend> poems = gushiwens.map<PoemRecommend>((gushiwen) {
            return PoemRecommend.parseJSON(gushiwen);
          }).toList();

          if (_page == 1) {
            _poemList.clear();
          }

          setState(() {
            _poemList.addAll(poems);
          });
        })
        .catchError((error) {})
        .whenComplete(() {
          if (_isLoading == true) {
            setState(() {
              _isLoading = false;
            });
          }
        });
  }

  Future<void> _refresh() async {
    _page = 1;
    _getMoreTagList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_navTitle),
      ),
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
              child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return PoemsListCell(
                      poem: _poemList[index],
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      pushContext: context,
                    );
                  },
                  itemCount: _poemList.length),
              onRefresh: _refresh),
          LoadingIndicator(isLoading: _isLoading),
          RetryPage(
            offstage: _isLoading || _poemList.length > 0,
            onTap: () {
              _getMoreTagList();
            },
          )
        ],
      ),
    );
  }
}
