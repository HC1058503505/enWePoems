import 'package:flutter/material.dart';
import 'package:flutterapp/models/colors.dart';
import 'package:flustars/flustars.dart';
import 'package:flutterapp/models/strings.dart';
import 'package:flutterapp/tools/bus_event.dart';

class MineSettings extends StatefulWidget {
  @override
  _MineSettingsState createState() => _MineSettingsState();
}

class _MineSettingsState extends State<MineSettings> {
  bool _isExpansionChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).indicatorColor),
        centerTitle: true,
        title: Text("设置"),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            ExpansionTile(
              onExpansionChanged: (changed) {
                setState(() {
                  _isExpansionChanged = changed;
                });
              },
              title: Row(
                children: <Widget>[
                  Icon(Icons.color_lens,
                      color: _isExpansionChanged
                          ? Theme.of(context).primaryColor
                          : Colors.black38),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text("主题", style: TextStyle(color: _isExpansionChanged ? Theme.of(context).primaryColor : Colors.black38, fontWeight: FontWeight.bold),),
                  )
                ],
              ),
              children: <Widget>[
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: themeColorMap.keys.map<Widget>((item) {
                    return InkWell(
                      onTap: () {
                        SpUtil.getInstance().then((value) {
                          SpUtil.putString(Constant.KEY_THEME_COLOR, item);
                          bus.emit(Constant.KEY_THEME_CHANGE);
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        color: themeColorMap[item],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10)
              ],
            )
          ],
        ),
      ),
    );
  }
}
