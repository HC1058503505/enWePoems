import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/models/poem_recommend.dart';
import 'package:flutterapp/pages/detail/poem_translate.dart';
import 'package:flutterapp/tools/LogUtils.dart';
import 'package:flutterapp/tools/dio_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterapp/models/poem_detail_model.dart';
import 'package:flutterapp/pages/recommand/poem_cell.dart';
import 'package:flutterapp/pages/detail/poem_anlyze_page.dart';
import 'package:flutterapp/pages/detail/poem_author.dart';
import 'dart:math' as math;
import 'package:flutterapp/pages/detail/poem_tag_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'dart:core';
import 'dart:io';
import 'package:flutterapp/pages/detail/loading.dart';
import 'package:flutterapp/pages/detail/error_retry_page.dart';

class PoemDetail extends StatefulWidget {
  PoemDetail({this.poemRecom});
  final PoemRecommend poemRecom;

  @override
  _PoemDetailState createState() => _PoemDetailState();
}

class _PoemDetailState extends State<PoemDetail>
    with SingleTickerProviderStateMixin {
  PoemDetailModel _detailModel;
  List<Map<String, String>> _tabs = <Map<String, String>>[
    {"title": "译注"},
    {"title": "赏析"},
    {"title": "作者"},
    {"title": "英文翻译"}
  ];
  TabController _tabController;
//  PageController _pageController = PageController();
  PoemAnalyzeView _fanyisAnalyzeView;
  PoemAnalyzeView _shangxisAnalyzeView;
  PoemAuthorView _authorView;
  PoemTranslateView _translateView;
  bool _collectionEnable = true;
  bool _isLoading = false;
  List<PoemRecommend> _poemRecoms = <PoemRecommend>[];
  List<PoemAnalyze> _analyzes = <PoemAnalyze>[];
  PoemAuthor _authorInfo = PoemAuthor();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    selectedCollection();
  }

  void selectedCollection() async {
    if (widget.poemRecom.from == "collection") {
      _getPoemDetail();
      return;
    }

    PoemRecommendProvider provider = PoemRecommendProvider.singleton;
    if (!provider.db.isOpen) {
      await provider.open(DatabasePath);
    }
    provider
        .getPoemRecom(tableName: tableCollection, id: widget.poemRecom.idnew)
        .then((poem) {
          if (poem != null) {
            widget.poemRecom.isCollection = poem.isCollection;
            widget.poemRecom.nameStr = poem.nameStr;
            widget.poemRecom.author = poem.author;
            widget.poemRecom.chaodai = poem.chaodai;
            widget.poemRecom.cont = poem.cont;
            widget.poemRecom.tag = poem.tag;
            widget.poemRecom.from = "recommend";
            widget.poemRecom.dateTime = poem.dateTime;
          } else {
            widget.poemRecom.isCollection = false;
          }
        })
        .catchError((error) {})
        .whenComplete(() {
          _getPoemDetail();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    DioManager.singleton.cancle();
    Fluttertoast.cancel();
  }

  void _scanRecord() async {
    if (_detailModel == null || widget.poemRecom.idnew.length == 0) {
      return;
    }
    PoemRecommendProvider provider = PoemRecommendProvider.singleton;
    await provider.open(DatabasePath);
    provider
        .getPoemRecom(tableName: tableRecords, id: widget.poemRecom.idnew)
        .then((poem) {
      if (poem != null) {
        provider.update(
            tableName: tableRecords, poemRecom: _detailModel.gushiwen);
      } else {
        provider.insert(
            tableName: tableRecords, poemRecom: _detailModel.gushiwen);
      }
    });
  }

  void _getPoemDetail() async {
    setState(() {
      _isLoading = true;
    });
    var postData = {"token": "gswapi", "id": widget.poemRecom.idnew};
    String path = widget.poemRecom.from == "mingju"
        ? "api/mingju/juv2.aspx"
        : "api/shiwen/shiwenv.aspx";

    DioManager.singleton.post(path: path, data: postData).then((response) {
      setState(() {
        _detailModel = PoemDetailModel.parseJSON(response);
        if (widget.poemRecom.from == "collection") {
          _detailModel.gushiwen.from = "collection";
          _detailModel.gushiwen.isCollection = true;
        }
      });

      _getAuthorMsg();
      _scanRecord();
    }).catchError((error) {
      if (error is DioError) {
        DioError dioError = error as DioError;
        if (dioError.type == DioErrorType.CONNECT_TIMEOUT) {
          Fluttertoast.showToast(
              msg: "网络连接超时，请检查网络",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
        }
      }

      if (error is FlutterError) {
        FlutterError flutterError = error as FlutterError;
      }
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _getAuthorMsg() async {
    if (_detailModel == null ||
        _detailModel.author == null ||
        _detailModel.author.idnew.length == 0) {
      _authorInfo = PoemAuthor(nameStr: widget.poemRecom.author);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    var postData = {'token': 'gswapi', 'id': _detailModel.author.idnew};
    DioManager.singleton
        .post(path: "api/author/author2.aspx", data: postData)
        .then((response) {
          PoemAuthor authorTemp = PoemAuthor.parseJSON(response["tb_author"]);

          var tb_gushiwens = response["tb_gushiwens"] as Map<String, dynamic>;
          var gushiwens = tb_gushiwens["gushiwens"] as List<dynamic>;
          var gushiwensList = gushiwens.map<PoemRecommend>((poem) {
            return PoemRecommend.parseJSON(poem);
          }).toList();

          setState(() {
            _authorInfo = authorTemp;
            _poemRecoms = gushiwensList;
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MaterialApp(
          theme: Theme.of(context),
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon((Platform.isMacOS || Platform.isIOS)
                      ? Icons.arrow_back_ios
                      : Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              actions: <Widget>[collectionButtonAction()],
            ),
            body: Offstage(
              offstage: _detailModel == null,
              child: Container(
                color: Colors.white,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: poemHeader(),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 55,
                        maxHeight: 55,
                        child: poemAnalyzeTabBar(),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: poemAnalyzePageView(index),
                          );
                        },
                        childCount: analyzesCount(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        LoadingIndicator(isLoading: _isLoading),
        RetryPage(
          offstage: _detailModel != null || _isLoading,
          onTap: () {
            _getPoemDetail();
          },
        ),
      ],
    );
  }

  IconButton collectionButtonAction() {
    return IconButton(
      icon: Icon(
          widget.poemRecom.isCollection ||
                  (_detailModel != null && _detailModel.gushiwen.isCollection)
              ? Icons.star
              : Icons.star_border,
          color: Colors.white),
      onPressed: () {
        Fluttertoast.cancel();

        if (_detailModel == null || widget.poemRecom.idnew.length == 0) {
          return;
        }

        if (_collectionEnable == false) {
          Fluttertoast.showToast(
              msg: "您的操作太频繁了，稍等！",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
          return;
        }

        PoemRecommendProvider provider = PoemRecommendProvider.singleton;
        provider.open(DatabasePath).then((dyanmic) {
          if (!_detailModel.gushiwen.isCollection) {
            _collectionEnable = false;
            _detailModel.gushiwen.isCollection =
                !_detailModel.gushiwen.isCollection;
            provider
                .insert(
                    tableName: tableCollection,
                    poemRecom: _detailModel.gushiwen)
                .then((dynamic) {
              Fluttertoast.showToast(
                  msg: "收藏成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER);
              setState(() {});
            }).catchError((error) {
              Fluttertoast.showToast(
                  msg: "收藏失败",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER);
            }).whenComplete(() {
              _collectionEnable = true;
            });
          } else {
            _collectionEnable = false;
            _detailModel.gushiwen.isCollection =
                !_detailModel.gushiwen.isCollection;
            provider
                .delete(
                    tableName: tableCollection, id: _detailModel.gushiwen.idnew)
                .then((dynamic) {
              Fluttertoast.showToast(
                  msg: "取消收藏成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER);
              setState(() {});
            }).catchError((error) {
              Fluttertoast.showToast(
                  msg: "取消收藏失败",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER);
            }).whenComplete(() {
              _collectionEnable = true;
            });
          }
        });
      },
    );
  }

  int analyzesCount() {
    switch (_tabController.index) {
      case 0:
        return _detailModel == null
            ? 0
            : (_detailModel.fanyis.length == 0
                ? 1
                : _detailModel.fanyis.length);
      case 1:
        return _detailModel == null
            ? 0
            : (_detailModel.shagnxis.length == 0
                ? 1
                : _detailModel.shagnxis.length);
      case 2:
        return 1;
      case 3:
        return 1;
    }
  }

  Container poemHeader() {
    if (_detailModel == null && widget.poemRecom.from != "recommend") {
      return Container();
    }

    PoemRecommend source =
        _detailModel == null ? widget.poemRecom : _detailModel.gushiwen;

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PoemCell(poem: source),
          PoemTagPage(
            tagStr: source.tag,
            pushContext: context,
          )
        ],
      ),
    );
  }

  Container poemAnalyzeTabBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black45,
            tabs: _tabs.map<Tab>((tab) {
              int index = _tabs.indexOf(tab);
              bool isCurrentTab = _tabController.index == index;
              return Tab(
                child: Text(tab["title"]),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget sliverPoemAnalyzeCell(List<PoemAnalyze> analyze, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            analyze[index].nameStr,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        Html(
          data: analyze[index].cont,
        )
      ],
    );
  }

  Widget poemAnalyzePageView(int index) {
    switch (_tabController.index) {
      case 0:
        if (_fanyisAnalyzeView == null) {
          _fanyisAnalyzeView = PoemAnalyzeView(
              analyzes: _detailModel.fanyis,
              index: index,
              pageType: AnalyzePageType.AnalyzePageFanyi);
        }
        return _fanyisAnalyzeView;
      case 1:
        if (_shangxisAnalyzeView == null) {
          _shangxisAnalyzeView = PoemAnalyzeView(
            analyzes: _detailModel.shagnxis,
            index: index,
            pageType: AnalyzePageType.AnalyzePageShangxi,
          );
        }
        return _shangxisAnalyzeView;
      case 2:
        if (_authorView == null) {
          _authorView = PoemAuthorView(
            poemRecoms: _poemRecoms,
            analyzes: _analyzes,
            authorInfo: _authorInfo,
            pushContext: context,
          );
        }
        return _authorView;

      case 3:
        if (_translateView == null) {
          LogUtils.e("translat222", _poemRecoms.toString());
          _translateView = PoemTranslateView(
           poem: _detailModel.gushiwen
          );
        }
        return _translateView;
    }
  }
}

// 常驻表头代理
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
