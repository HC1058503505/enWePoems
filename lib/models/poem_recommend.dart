import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

final String tableCollection = "collections";
final String tableRecords = "records";
final String columnId = "_id";
final String columnIdnew = "idnew"; // 诗词新id
final String columnNameStr = "nameStr"; // 诗名
final String columnAuthor = "author"; // 作者
final String columnChaodai = "chaodai"; // 朝代
final String columnCont = "cont"; // 诗词内容
final String columnTag = "tag"; // 标签
final String columnFrom = "fromType"; // 来源类型
final String columnCollection = "isCollection";
final String columnDateTime = "dateTime";
final String columnLangsongAuthor = "langsongAuthor";
final String columnLangsongAuthorPY = "langsongAuthorPY";

class PoemRecommend {
  String idnew = ""; // 诗词新id
  String nameStr = ""; // 诗名
  String author = ""; // 作者
  String chaodai = ""; // 朝代
  String cont = ""; // 诗词内容
  String tag = ""; // 标签
  String from = "poem"; // 来源类型
  bool isCollection = false;
  String dateTime = "";
  String langsongAuthor = "";
  String langsongAuthorPY = "";
  PoemRecommend(
      {this.idnew,
      this.nameStr,
      this.author,
      this.chaodai,
      this.cont,
      this.tag,
      this.langsongAuthor,
      this.langsongAuthorPY});

  PoemRecommend.parseJSON(Map<String, dynamic> poem) {
    idnew = poem["idnew"].toString().replaceAll(RegExp("null"), "");
    nameStr = poem["nameStr"].toString().replaceAll(RegExp("null"), "");
    author = poem["author"].toString().replaceAll(RegExp("null"), "");
    chaodai = poem["chaodai"].toString().replaceAll(RegExp("null"), "");

    cont = poem["cont"]
        .toString()
        .replaceAll(RegExp("null"), "")
        .replaceAll(RegExp("<(\/)?p>"), "")
        .replaceAll(RegExp("\n"), "\n\n")
        .replaceAll(RegExp("<br(.*?)>"), "\n\n")
        .replaceAll(RegExp("[\(|（].*[\)|）]"), "")
        .replaceAll(RegExp("<span.*span>"), "")
        .replaceAll(RegExp("<div class=\'small\'></div>"), "\n\n")
        .trim();
    tag = poem["tag"].toString().replaceAll(RegExp("null"), "");
    langsongAuthor =
        poem["langsongAuthor"].toString().replaceAll(RegExp("null"), "");
    langsongAuthorPY =
        poem["langsongAuthorPY"].toString().replaceAll(RegExp("null"), "");
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnIdnew: idnew,
      columnNameStr: nameStr,
      columnAuthor: author,
      columnChaodai: chaodai,
      columnCont: cont,
      columnTag: tag,
      columnFrom: from,
      columnCollection: isCollection,
      columnDateTime: dateTime,
      columnLangsongAuthor: langsongAuthor,
      columnLangsongAuthorPY: langsongAuthorPY
    };
  }

  PoemRecommend.fromMap(Map<String, dynamic> map) {
    idnew = map[columnIdnew].toString();
    nameStr = map[columnNameStr].toString().replaceAll(RegExp("null"), "");
    author = map[columnAuthor].toString().replaceAll(RegExp("null"), "");
    chaodai = map[columnChaodai].toString().replaceAll(RegExp("null"), "");
    cont = map[columnCont];
    tag = map[columnTag].toString().replaceAll(RegExp("null"), "");
    isCollection = (map[columnCollection] as int == 1);
    from = map[columnFrom].toString().replaceAll(RegExp("null"), "");
    dateTime = map[columnDateTime].toString().replaceAll(RegExp("null"), "");
    langsongAuthor =
        map[columnLangsongAuthor].toString().replaceAll(RegExp("null"), "");
    langsongAuthorPY =
        map[columnLangsongAuthorPY].toString().replaceAll(RegExp("null"), "");
  }
}

final String DatabasePath = "collections.db";

class PoemRecommendProvider {
  Database db;

  PoemRecommendProvider._init() {}

  static PoemRecommendProvider singleton = PoemRecommendProvider._init();

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table if not exists $tableCollection( 
  $columnId integer primary key autoincrement, 
  $columnIdnew text not null unique,
  $columnNameStr text not null,
  $columnAuthor text not null,
  $columnChaodai text not null,
  $columnCont text not null,
  $columnTag text not null,
  $columnFrom text not null,
  $columnCollection bool not null,
  $columnDateTime text not null,
  $columnLangsongAuthor text not null,
  $columnLangsongAuthorPY text not null)
''');

      await db.execute('''
create table if not exists $tableRecords( 
  $columnId integer primary key autoincrement, 
  $columnIdnew text not null unique,
  $columnNameStr text not null,
  $columnAuthor text not null,
  $columnChaodai text not null,
  $columnCont text not null,
  $columnTag text not null,
  $columnFrom text not null,
  $columnCollection bool not null,
  $columnDateTime text not null,
  $columnLangsongAuthor text not null,
  $columnLangsongAuthorPY text not null)
''');
    });
  }

  Future<void> insert({String tableName, PoemRecommend poemRecom}) async {
    if (tableName == tableCollection) {
      poemRecom.from = "collection";
    }

    poemRecom.dateTime = DateTime.now().toString();
    return await db.insert(tableName, poemRecom.toMap());
  }

  Future<PoemRecommend> getPoemRecom({String tableName, String id}) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnIdnew,
          columnNameStr,
          columnAuthor,
          columnChaodai,
          columnCont,
          columnTag,
          columnFrom,
          columnCollection,
          columnDateTime,
          columnLangsongAuthor,
          columnLangsongAuthorPY
        ],
        where: '$columnIdnew = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return PoemRecommend.fromMap(maps.first);
    }
    return null;
  }

  Future<List<PoemRecommend>> getPoemRecomsPaging(
      {String tableName, int limit, int page}) async {
    List<Map> maps = await db.query(tableName,
        columns: [
          columnIdnew,
          columnNameStr,
          columnAuthor,
          columnChaodai,
          columnCont,
          columnTag,
          columnFrom,
          columnCollection,
          columnDateTime,
          columnLangsongAuthor,
          columnLangsongAuthorPY
        ],
        limit: limit,
        distinct: true,
        orderBy: columnDateTime + " DESC",
        offset: page * limit);

    if (maps.length > 0) {
      return maps.map<PoemRecommend>((item) {
        return PoemRecommend.fromMap(item);
      }).toList();
    }

    return null;
  }

  Future<dynamic> getRecords() async {
    List<Map> maps = await db.rawQuery(
        "select * from records group by strftime('%Y-%m-%d', datetime)");

    print(maps);
  }

  Future delete({String tableName, String id}) async {
    return await db
        .delete(tableName, where: '$columnIdnew = ?', whereArgs: [id]);
  }

  Future deleteAll({String tableName}) async {
    return await db.delete(tableName);
  }

  Future update({String tableName, PoemRecommend poemRecom}) async {
    poemRecom.dateTime = DateTime.now().toString();
    return await db.update(tableName, poemRecom.toMap(),
        where: '$columnIdnew = ?', whereArgs: [poemRecom.idnew]);
  }

  Future close() async => db.close();
}
