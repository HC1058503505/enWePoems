import 'package:flutter/material.dart';
import 'package:flutterapp/models/poem_detail_model.dart';
import 'package:flutter_html/flutter_html.dart';

enum AnalyzePageType { AnalyzePageFanyi, AnalyzePageShangxi }

class PoemAnalyzeView extends StatelessWidget {
  PoemAnalyzeView({this.analyzes, this.index, this.pageType});
  final List<PoemAnalyze> analyzes;
  final int index;
  final AnalyzePageType pageType;
//  @override
//  _PoemAnalyzeViewState createState() => _PoemAnalyzeViewState();
//}
//
//class _PoemAnalyzeViewState extends State<PoemAnalyzeView>  with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    String msg = pageType == AnalyzePageType.AnalyzePageFanyi ? "译注" : "赏析";
    if (analyzes.length == 0) {
      return Container(
        height: 200,
        child: Center(
            child: Text.rich(TextSpan(children: [
          TextSpan(
            text: "暂无",
            style: TextStyle(color: Colors.black26),
          ),
          TextSpan(
            text: msg,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "相关内容",
            style: TextStyle(color: Colors.black26),
          )
        ]))),
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Text(
              analyzes[index].nameStr,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              textAlign: TextAlign.left,
            ),
          ),
          Html(
            data: analyzes[index].cont,
            defaultTextStyle: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }

//  @override
//  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive => true;
}
