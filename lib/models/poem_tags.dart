class PoemSearchConditions {
  List<PoemTagAuthor> authors;
  List<PoemTagCollections> collections;
  List<PoemTagDynasty> dynastys;
  List<PoemTagHotSearch> hotsearchs;
  List<PoemTagSection> tags;

  PoemSearchConditions.parseJSON(Map<String, dynamic> conditions) {
    List<dynamic> authorList = conditions["author"] as List<dynamic>;
    authors = authorList.map<PoemTagAuthor>((item) {
      return PoemTagAuthor.parseJSON(item);
    }).toList();

    collections = (conditions["collections"] as List<dynamic>)
        .map<PoemTagCollections>((item) {
      return PoemTagCollections.parseJSON(item);
    }).toList();

    dynastys =
        (conditions["dynasty"] as List<dynamic>).map<PoemTagDynasty>((item) {
      return PoemTagDynasty.parseJSON(item);
    }).toList();

    hotsearchs = (conditions["hotsearch"] as List<dynamic>)
        .map<PoemTagHotSearch>((item) {
      return PoemTagHotSearch.parseJSON(item);
    }).toList();

    tags = (conditions["tag"] as List<dynamic>).map<PoemTagSection>((tag) {
      return PoemTagSection.parseJSON(tag);
    }).toList();
  }
}

class PoemTagAuthorItem {
  String poet_name = "";
  String poetry_count = "";
  String poet_id = "";
  PoemTagAuthorItem({this.poet_name, this.poetry_count, this.poet_id});

  PoemTagAuthorItem.parseJSON(Map<String, dynamic> author) {
    poet_name = author["poet_name"].toString();
    poetry_count = author["poetry_count"].toString();
    poet_id = author["poet_id"].toString();
  }
}

class PoemTagAuthor {
  String title = "";
  List<PoemTagAuthorItem> list = List<PoemTagAuthorItem>();

  PoemTagAuthor.parseJSON(Map<String, dynamic> author) {
    title = author["title"];
    list = (author["list"] as List<dynamic>).map<PoemTagAuthorItem>((item) {
      return PoemTagAuthorItem.parseJSON(item);
    }).toList();
  }
}

class PoemTagSection {
  String section_title = "";
  List<String> items = List<String>();

  PoemTagSection.parseJSON(Map<String, dynamic> section) {
    section_title = section["section_title"];

    items = (section["items"] as List<dynamic>).map<String>((item) {
      return item.toString();
    }).toList();
  }
}

class PoemTagCollections {
  String name = "";
  String count = "";
  PoemTagCollections({this.name, this.count});
  PoemTagCollections.parseJSON(Map<String, dynamic> collection) {
    name = collection["name"].toString();
    count = collection["count"].toString();
  }
}

class PoemTagDynasty extends PoemTagCollections {
  PoemTagDynasty.parseJSON(Map<String, dynamic> collection)
      : super.parseJSON(collection) {}
}

class PoemTagHotSearch {
  String title = "";
  String type = "";
  List<String> hotkeys = List<String>();
  PoemTagHotSearch({this.title, this.hotkeys});

  PoemTagHotSearch.parseJSON(Map<String, dynamic> hotsearch) {
    title = hotsearch["title"].toString();
    type = hotsearch["type"].toString();
    hotkeys = (hotsearch["hotkeys"] as List<dynamic>).map<String>((item) {
      return item.toString();
    }).toList();
  }
}
