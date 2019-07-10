import 'package:flutterapp/tools/LogUtils.dart';
import 'package:flutterapp/tools/dio_manager.dart';

class TranslatePoem {
  static const APP_ID = "20190619000308709";
  static const SECURITY_KEY = "1681711370";

  static String transResult(String chinesePoem) {
    Map<String, String> params = {
      "keyfrom": 'zhaotranslator',
      "key": SECURITY_KEY,
      "type": 'data',
      "doctype": 'json',
      "version": '1.1',
      "q": chinesePoem,
    };

    DioManager.singleton
        .translate(path: "openapi.do", params: params)
        .then((response) {
      LogUtils.e("translatetranslate", "1" + response.toString());
      return response.toString();
    }).catchError((error) {
      LogUtils.e("translatetranslate", "3" + error.toString());
    }).whenComplete(() {});
  }
}
