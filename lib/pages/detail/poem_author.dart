import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_detail_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutterapp/tools/dio_manager.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterapp/pages/taglist/poems_list_cell.dart';
import 'package:flutterapp/pages/taglist/tag_poems_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterapp/pages/detail/poem_search_author.dart';

enum PoemAuthorType { PoemAuthorBrief, PomeAuthorDetail }

class PoemAuthorView extends StatefulWidget {
  PoemAuthorView(
      {this.poemRecoms, this.analyzes, this.authorInfo, this.pushContext});
  final List<PoemRecommend> poemRecoms;
  final List<PoemAnalyze> analyzes;
  final PoemAuthor authorInfo;
  final BuildContext pushContext;
  @override
  _PoemAuthorViewState createState() => _PoemAuthorViewState();
}

class _PoemAuthorViewState extends State<PoemAuthorView> {
  final TapGestureRecognizer _recognizer = TapGestureRecognizer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recognizer.onTap = () {
      Navigator.of(widget.pushContext)
          .push(CupertinoPageRoute(builder: (context) {
        return PoemSearchAuthor(
            author: PoemAuthor(
                idnew: widget.authorInfo.idnew,
                nameStr: widget.authorInfo.nameStr));
      }));
    };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    DioManager.singleton.cancle();
    _recognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String iconName = "libai";
    if (widget.authorInfo != null &&
        widget.authorInfo.pic != null &&
        widget.authorInfo.pic.length > 0) {
      iconName = widget.authorInfo.pic;
    }

    String authorCont = "";
    if (widget.authorInfo != null && widget.authorInfo.cont != null) {
      authorCont = widget.authorInfo.cont;
    }

    String authorNameErrorState = "佚名";
    if (widget.authorInfo != null && widget.authorInfo.nameStr != null) {
      authorNameErrorState = widget.authorInfo.nameStr;
    }
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: widget.authorInfo == null ||
                widget.authorInfo.pic == null ||
                widget.authorInfo.pic.length == 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: ClipRRect(
                child: Image(
                  fit: BoxFit.fitHeight,
                  image: CachedNetworkImageProvider(
                      "https://img.gushiwen.org/authorImg/${iconName}.jpg"),
                  height: 180,
                ),
                borderRadius: BorderRadius.all(Radius.circular(126)),
              ),
            ),
          ),
          Offstage(
            offstage:
                widget.authorInfo == null || widget.authorInfo.cont == null,
            child: RichText(
              text: TextSpan(
                text: authorCont,
                style: DefaultTextStyle.of(context).style,
                children:
                    (widget.analyzes.length == 0 || widget.analyzes == null)
                        ? [
                            TextSpan(
                              text: "查看更多详情>>",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: _recognizer,
                            ),
                          ]
                        : [],
              ),
            ),
          ),
          Offstage(
            offstage:
                widget.poemRecoms == null || widget.poemRecoms.length == 0,
            child: poemRecomView(),
          ),
          Offstage(
            offstage: widget.analyzes == null || widget.analyzes.length == 0,
            child: analyzesView(),
          ),
          Offstage(
            offstage: widget.authorInfo != null &&
                widget.authorInfo.idnew != null &&
                widget.authorInfo.idnew.length > 0,
            child: Container(
              height: 200,
              child: Center(
                child: Text(
                  authorNameErrorState,
                  style: TextStyle(color: Colors.black26),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget poemRecomView() {
    List<Widget> poemWidgets = widget.poemRecoms.map<Widget>((poem) {
      return PoemsListCell(
        poem: poem,
        padding: EdgeInsets.all(0),
        pushContext: widget.pushContext,
      );
    }).toList();

    var faltBtn = FlatButton(
        child: Text(
          "查看更多作品>>",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: () {
          Navigator.of(widget.pushContext)
              .push(CupertinoPageRoute(builder: (context) {
            return PoemsTagList(
              tagType: TagType.Author,
              tagStr: widget.authorInfo.nameStr,
            );
          }));
        });
    poemWidgets.add(faltBtn);

    var titleText = Container(
      child: Text(
        "代表作",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleText,
          Column(
            children: poemWidgets,
          )
        ],
      ),
    );
  }

  Widget analyzesView() {
    List<Widget> analyzeWidgets = widget.analyzes.map<Widget>((analyze) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              analyze.nameStr,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              textAlign: TextAlign.left,
            ),
          ),
          Html(
            data: analyze.cont,
          )
        ],
      );
    }).toList();

    return Column(
      children: analyzeWidgets,
    );
  }

//  @override
//  // TODO: implement wantKeepAlive
//  bool get wantKeepAlive => true;
}
