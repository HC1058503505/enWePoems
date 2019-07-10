import 'package:flutter/material.dart';
import 'package:flutterapp/pages/recommand/recommand_page.dart';
import 'package:flutterapp/pages/me/me_page.dart';
import 'package:flutterapp/pages/find/find_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_recommend.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Map<String, String>> _tabItems = <Map<String, String>>[
    {"title": "推荐", "icon": "lib/images/recommand"},
    {"title": "发现", "icon": "lib/images/poem_search"},
    {"title": "我", "icon": "lib/images/me"}
  ];

  int _tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: IndexedStack(
          children: <Widget>[RecommandPage(), FindPage(), MePage()],
          index: _tabIndex,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
        items: _tabItems.map<BottomNavigationBarItem>((item) {
          return BottomNavigationBarItem(
            icon: Image.asset(item["icon"] + ".png"),
            title: Text(item["title"]),
            activeIcon: Image.asset(
              item["icon"] + "_selected.png",
              color: Theme.of(context).primaryColor,
            ),
          );
        }).toList(),
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        currentIndex: _tabIndex,
      ),
    );
  }
}
