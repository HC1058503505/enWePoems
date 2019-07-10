import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_detail_model.dart';
import 'package:flutterapp/tools/dio_manager.dart';
import 'package:flutterapp/pages/detail/poem_author.dart';
import 'package:flutterapp/pages/detail/loading.dart';
import 'package:flutterapp/pages/detail/error_retry_page.dart';
import 'package:flutterapp/models/poem_recommend.dart';

class PoemSearchAuthor extends StatefulWidget {
  PoemSearchAuthor({this.author});
  final PoemAuthor author;
  @override
  _PoemSearchAuthorState createState() => _PoemSearchAuthorState();
}

class _PoemSearchAuthorState extends State<PoemSearchAuthor> {
  List<PoemRecommend> _poemRecoms = <PoemRecommend>[];
  List<PoemAnalyze> _analyzes = <PoemAnalyze>[];
  PoemAuthor _authorInfo;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAuthorInfo();
  }

  void _getAuthorInfo() async {
    setState(() {
      _isLoading = true;
    });

    var postData = {'token': 'gswapi', 'id': widget.author.idnew};
    DioManager.singleton
        .post(path: "/api/author/author2.aspx", data: postData)
        .then((response) {
          PoemAuthor authorTemp = PoemAuthor.parseJSON(response["tb_author"]);

          var tb_gushiwens = response["tb_gushiwens"] as Map<String, dynamic>;
          var gushiwens = tb_gushiwens["gushiwens"] as List<dynamic>;
          var gushiwensList = gushiwens.map<PoemRecommend>((poem) {
            return PoemRecommend.parseJSON(poem);
          }).toList();

          var tb_ziliaos = response["tb_ziliaos"] as Map<String, dynamic>;
          var ziliaos = tb_ziliaos["ziliaos"] as List<dynamic>;
          var analyzesList = ziliaos.map<PoemAnalyze>((analyze) {
            return PoemAnalyze.parseJSON(analyze);
          }).toList();

          setState(() {
            _authorInfo = authorTemp;
            _poemRecoms = gushiwensList;
            _analyzes = analyzesList;
          });
        })
        .catchError((error) {})
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    DioManager.singleton.cancle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.author.nameStr),
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: !(_analyzes.length > 0 &&
                _poemRecoms.length > 0 &&
                _authorInfo != null),
            child: Container(
              color: Colors.white,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(20),
                          child: PoemAuthorView(
                            poemRecoms: _poemRecoms,
                            analyzes: _analyzes,
                            authorInfo: _authorInfo,
                            pushContext: context,
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
            ),
          ),
          LoadingIndicator(isLoading: _isLoading),
          RetryPage(
            offstage: _isLoading ||
                (_analyzes.length > 0 &&
                    _poemRecoms.length > 0 &&
                    _authorInfo != null),
            onTap: () {
              _getAuthorInfo();
            },
          )
        ],
      ),
    );
  }
}
