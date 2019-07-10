import 'package:flutter/material.dart';
import 'package:flutterapp/pages/root/root_page.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/tools/bus_event.dart';
import 'package:flutterapp/models/strings.dart';
import 'package:flustars/flustars.dart';
import 'package:flutterapp/models/colors.dart';
import 'package:flutterapp/pages/ad/ad_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _themeColor;
  bool _hideAd = false;
  @override
  void initState() {
    SpUtil.getInstance().then((value) {
      setState(() {
        _themeColor = themeColorMap[
            SpUtil.getString(Constant.KEY_THEME_COLOR, defValue: "blue")];
      });
    });

    // TODO: implement initState
    super.initState();

    bus.add(Constant.KEY_THEME_CHANGE, (dynamic) {
      SpUtil.getInstance().then((value) {
        setState(() {
          _themeColor = themeColorMap[
              SpUtil.getString(Constant.KEY_THEME_COLOR, defValue: "blue")];
        });
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 建表
    createCollectionTable();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
      ),
      home: Stack(
        children: <Widget>[
          RootPage(title: '古诗文斋'),
          Offstage(
            offstage: true,
            child: ADPage((finished) {
              setState(() {
                _hideAd = finished;
              });
            }),
          )
        ],
      ),
    );
  }

  void createCollectionTable() async {
    PoemRecommendProvider provider = PoemRecommendProvider.singleton;
    await provider.open(DatabasePath);
  }
}
