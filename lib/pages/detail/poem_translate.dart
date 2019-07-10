import 'package:flutter/material.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/tools/LogUtils.dart';
import 'package:flutterapp/tools/dio_manager.dart';
import 'package:flutter_plugin_tts/flutter_plugin_tts.dart';

class PoemTranslateView extends StatefulWidget {
  final PoemRecommend poem;

  PoemTranslateView({this.poem});

  @override
  State<StatefulWidget> createState() {
    return PoemTranslateViewState(poem: poem);
  }
}

class PoemTranslateViewState extends State<PoemTranslateView> {
  PoemTranslateViewState({this.poem});

  final PoemRecommend poem;
  String enPoemName = "";
  String enAssert = "";
  String enChaodai = "";
  String enCont = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterPluginTts.setLanguage('en-AU').then((v) {
      debugPrint('r = $v');
    });
    translateName(poem.nameStr);
    translateAuthor(poem.author);
    translateChaodai(poem.chaodai);
    translateCont(poem.cont);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FlutterPluginTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: IconButton(
                icon: Icon(
                  Icons.headset,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  FlutterPluginTts.speak(enCont);
                }),
            alignment: Alignment.centerRight,
          ),
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
              enChaodai + ' / ' + enAssert,
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
              enCont,
//              poem.cont,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          )
        ],
      ),
    );
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
      LogUtils.e("translatetranslate111111", "1" + response.toString());
      setState(() {
        poem.nameStr = response.toString();
      });
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
      LogUtils.e("translatetranslate1", "1" + response.toString());
      setState(() {
        enAssert = response.toString();
      });
    }).catchError((error) {
      LogUtils.e("translatetranslate3", "3" + error.toString());
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
          LogUtils.e("translatetranslate333", "1" + response.toString());

          setState(() {
            enChaodai = response.toString();
          });
        })
        .catchError((error) {})
        .whenComplete(() {});
  }

  void translateCont(String cont) {
    var poemList = cont.split("。");
    for (int x = 0; x < poemList.length; x++) {
      var row = poemList[x];
      Map<String, String> params = {
        "keyfrom": 'zhaotranslator',
        "key": "1681711370",
        "type": 'data',
        "doctype": 'json',
        "version": '1.1',
        "q": row,
      };
      DioManager.singleton
          .translate(path: "openapi.do", params: params)
          .then((response) {
        LogUtils.e("translatetranslate", "1" + response.toString());
        setState(() {
          if (x == poemList.length - 1) {
            enCont = enCont + response.toString() + "。";
          } else {
            enCont = enCont + response.toString();
          }
        });
      }).catchError((error) {
        LogUtils.e("translatetranslate", "3" + error.toString());
      }).whenComplete(() {});
    }
  }
}
