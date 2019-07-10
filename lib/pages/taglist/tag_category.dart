import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/poem_tags.dart';
import 'package:flutterapp/pages/taglist/tag_category_collections.dart';
import 'package:flutterapp/pages/taglist/tag_category_dynasty.dart';
import 'package:flutterapp/pages/taglist/tag_category_label.dart';
import 'package:flutterapp/pages/taglist/tag_category_poet.dart';
import 'package:flutterapp/pages/find/search_controller.dart';

class TagCategoryView extends StatefulWidget {

  TagCategoryView({this.searchConditions, this.index});
  final PoemSearchConditions searchConditions;
  final int index;

  @override
  _TagCategoryViewState createState() => _TagCategoryViewState();
}

class _TagCategoryViewState extends State<TagCategoryView> with SingleTickerProviderStateMixin {

  TabController _tabController;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(initialIndex: widget.index, length: 4, vsync: this);
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("古诗文斋"),
        bottom: bottomTabBar(),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context){
                    return SearchController();
                  })
                );
              }
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          TagCategoryPoet(authors: widget.searchConditions.authors),
          TagCategoryDynasty(dynastys: widget.searchConditions.dynastys),
          TagCategoryLabel(labels: widget.searchConditions.tags),
          TagCategoryCollections(collections: widget.searchConditions.collections)
        ],
        onPageChanged: (index){
          _tabController.index = index;
        },
      ),
    );
  }

  Widget bottomTabBar() {
    return TabBar(
      onTap: (index){
        _pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.decelerate);
      },
      controller: _tabController,
      tabs: <Widget>[
        Tab(
          text: "诗人",
        ),
        Tab(
          text: "朝代",
        ),
        Tab(
          text: "标签",
        ),
        Tab(
          text: "诗集",
        )
      ],
    );
  }
}
