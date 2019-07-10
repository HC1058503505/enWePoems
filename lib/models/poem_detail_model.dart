import 'package:flutterapp/models/poem_recommend.dart';

class PoemAuthor {
  String chaodai = "";
  String cont = "";
  String creTime = "";
  int id = 0;
  String idnew = "";
  String ipStr = "";
  String nameStr = "";
  int likes = 0;
  String pic = "";
  int shiCount = 0;

  PoemAuthor(
      {this.chaodai,
      this.cont,
      this.creTime,
      this.id,
      this.idnew,
      this.ipStr,
      this.nameStr,
      this.likes,
      this.pic,
      this.shiCount});

  PoemAuthor.parseJSON(Map<String, dynamic> author) {
    chaodai = author["chaodai"].toString().replaceAll(RegExp("null"), "");
    cont = author["cont"]
        .toString()
        .replaceAll(RegExp("null"), "")
        .replaceAll(RegExp("<(.*?)p>"), "");
    creTime = author["creTime"].toString().replaceAll(RegExp("null"), "");
    id = author["id"] as int;
    idnew = author["idnew"].toString().replaceAll(RegExp("null"), "");
    ipStr = author["ipStr"].toString().replaceAll(RegExp("null"), "");
    nameStr = author["nameStr"].toString().replaceAll(RegExp("null"), "");
    likes = author["likes"] as int;
    pic = author["pic"].toString().replaceAll(RegExp("null"), "");
    shiCount = author["shiCount"] as int;
  }
}

class PoemAnalyze {
  String cont = "";
  String nameStr = "";

  PoemAnalyze.parseJSON(Map<String, dynamic> analyze) {
    cont = analyze["cont"].toString();
    nameStr = analyze["nameStr"].toString();
  }
}

class PoemDetailModel {
  PoemAuthor author = PoemAuthor();
  PoemRecommend gushiwen = PoemRecommend();
  List<PoemAnalyze> fanyis = <PoemAnalyze>[];
  List<PoemAnalyze> shagnxis = <PoemAnalyze>[];

  PoemDetailModel.parseJSON(Map<String, dynamic> poemDetail) {
    author = PoemAuthor.parseJSON(poemDetail["tb_author"]);

    Map<String, dynamic> tb_gushiwen =
        poemDetail["tb_gushiwen"] as Map<String, dynamic>;
    gushiwen = PoemRecommend.parseJSON(tb_gushiwen);

    Map<String, dynamic> tb_fanyis =
        poemDetail["tb_fanyis"] as Map<String, dynamic>;
    List<dynamic> fanyiList = tb_fanyis["fanyis"] as List<dynamic>;
    fanyis = fanyiList.map((fanyi) {
      return PoemAnalyze.parseJSON(fanyi);
    }).toList();

    Map<String, dynamic> tb_shangxis =
        poemDetail["tb_shangxis"] as Map<String, dynamic>;
    List<dynamic> shangxiList = tb_shangxis["shangxis"] as List<dynamic>;
    shagnxis = shangxiList.map((shangxi) {
      return PoemAnalyze.parseJSON(shangxi);
    }).toList();
  }
}
