import 'package:flutter/material.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/pages/recommand/poem_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/tools/LogUtils.dart';
import 'package:flutterapp/tools/dio_manager.dart';
import 'package:flutterapp/pages/detail/poem_detail.dart';
import 'package:flutterapp/pages/detail/loading.dart';
import 'package:flutterapp/pages/detail/error_retry_page.dart';
import 'package:flutterapp/tools/translate_utils.dart';

class RecommandPage extends StatefulWidget {
  @override
  _RecommandPageState createState() => _RecommandPageState();
}

class _RecommandPageState extends State<RecommandPage> {
  ScrollController _scrollController;
  List<PoemRecommend> _recommandList = <PoemRecommend>[];

  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _page++;
        _getPoems();
      }
    });

    _getPoems();
  }

  void _getPoems() async {
    if (_recommandList.length == 0) {
      setState(() {
        _isLoading = true;
      });
    }
    var postData = {"pwd": "", "token": "gswapi", "id": "", "page": _page};
    DioManager.singleton
        .post(path: "api/upTimeTop11.aspx", data: postData)
        .then((response) {
          var gushiwens = response["gushiwens"] as List<dynamic>;
          var gushiwenList = gushiwens.map((poem) {
            return PoemRecommend.parseJSON(poem);
          });
          LogUtils.e("response", response.toString());

          if (_page == 0) {
            _recommandList.clear();
          }

          setState(() {
            _recommandList.addAll(gushiwenList);
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

  Future<void> _onRefresh() async {
    _page = 0;
    _getPoems();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: PoemCell(
                    poem: _recommandList[index],
                    showStyle: PoemShowStyle.PoemShowMultipleLines,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) {
                      _recommandList[index].from = "recommend";
                      _recommandList[index].isCollection = false;
                      return PoemDetail(poemRecom: _recommandList[index]);
                    }));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.transparent,
                );
              },
              itemCount: _recommandList.length),
          onRefresh: _onRefresh,
        ),
        LoadingIndicator(isLoading: _isLoading),
        RetryPage(
          offstage: _isLoading || _recommandList.length > 0,
          onTap: () {
            _getPoems();
          },
        )
      ],
    );
  }
}
