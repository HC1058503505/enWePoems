import 'package:flutter/material.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/tools/LogUtils.dart';
import 'package:flutterapp/tools/dio_manager.dart';
import 'package:flutterapp/tools/translate_utils.dart';

enum PoemShowStyle { PoemShowSingleLine, PoemShowMultipleLines }

class PoemCell extends StatefulWidget {
  final PoemRecommend poem;
  final PoemShowStyle showStyle;

  PoemCell({this.poem, this.showStyle});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PoemCellState(poem: poem, showStyle: showStyle);
  }
}

class PoemCellState extends State<PoemCell> {
  final PoemRecommend poem;
  final PoemShowStyle showStyle;

  PoemCellState({this.poem, this.showStyle});

  String enPoemName = "";
  String enAssert = "";
  String enChaodai = "";
  String encCont = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    translate(poem.nameStr);
  }

  void translateName(String nameStr) async {
//    enPoemName = translate(nameStr).toString();
    Map<String, String> params = {
      "keyfrom": 'zhaotranslator',
      "key": "1681711370",
      "type": 'data',
      "doctype": 'json',
      "version": '1.1',
      "q": nameStr,
    };
    DioManager.singleton
        .translate(path: "openapi.do", params: params)
        .then((response) {
      LogUtils.e("translatetranslate", "1" + response.toString());
     enPoemName = response.toString();
    }).catchError((error) {
      LogUtils.e("translatetranslate", "3" + error.toString());
    }).whenComplete(() {});
  }

  void translateAuthor(String author) async {
//    enAssert = translate(author).toString();
    Map<String, String> params = {
      "keyfrom": 'zhaotranslator',
      "key": "1681711370",
      "type": 'data',
      "doctype": 'json',
      "version": '1.1',
      "q": author,
    };
    DioManager.singleton
        .translate(path: "openapi.do", params: params)
        .then((response) {
      LogUtils.e("translatetranslate", "1" + response.toString());
      enAssert = response.toString();
    }).catchError((error) {
      LogUtils.e("translatetranslate", "3" + error.toString());
    }).whenComplete(() {});
  }

  void translateChaodai(String src) async {
//    enChaodai = translate(src).toString();
    Map<String, String> params = {
      "keyfrom": 'zhaotranslator',
      "key": "1681711370",
      "type": 'data',
      "doctype": 'json',
      "version": '1.1',
      "q": src,
    };
    DioManager.singleton
        .translate(path: "openapi.do", params: params)
        .then((response) {
      LogUtils.e("translatetranslate", "1" + response.toString());
      enChaodai = response.toString();
    }).catchError((error) {
      LogUtils.e("translatetranslate", "3" + error.toString());
    }).whenComplete(() {});
  }

  void translateCont(String cont) {
    Map<String, String> params = {
      "keyfrom": 'zhaotranslator',
      "key": "1681711370",
      "type": 'data',
      "doctype": 'json',
      "version": '1.1',
      "q": cont,
    };
    DioManager.singleton
        .translate(path: "openapi.do", params: params)
        .then((response) {
      LogUtils.e("translatetranslate", "1" + response.toString());
      encCont = response.toString();
    }).catchError((error) {
      LogUtils.e("translatetranslate", "3" + error.toString());
    }).whenComplete(() {});
    setState(() {});
  }

  Future<dynamic> translate(String src) async {
    Map<String, String> params = {
      "keyfrom": 'zhaotranslator',
      "key": "1681711370",
      "type": 'data',
      "doctype": 'json',
      "version": '1.1',
      "q": src,
    };
    DioManager.singleton
        .translate(path: "openapi.do", params: params)
        .then((response) {
      LogUtils.e("translatetranslate", "1" + response.toString());
      var result = response.toString();
      return result;
    }).catchError((error) {
      LogUtils.e("translatetranslate", "3" + error.toString());
    }).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Text(
//              enPoemName,
              poem.nameStr,
//            "Bodhisattva, pretty new, the wine in the cold rain knocked at the window",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                decoration: TextDecoration.none,
              ),
            ),
            padding: EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.white,
            child: Text(
              poem.chaodai + ' / ' + poem.author,
              style: TextStyle(
                color: Colors.black38,
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            alignment: Alignment.center,
            child: Text(
//              encCont,
              showStyle == PoemShowStyle.PoemShowSingleLine
                  ? poem.cont.split("\n\n").first
                  : poem.cont,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          )
        ],
      ),
    );
  }


}
