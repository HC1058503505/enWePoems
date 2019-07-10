import 'dart:collection';

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutterapp/tools/LogUtils.dart';

class TransApi {
  static const String TRANS_API_HOST =
      "http://api.fanyi.baidu.com/api/trans/vip/translate";
  static const _platform = const MethodChannel('com.demo/md5');
  static const _platform_get = const MethodChannel('com.demo/get');

  String appid;
  String securityKey;

  TransApi(this.appid, this.securityKey);

  String getTransResult(String query, String from, String to) {
    Map<String, String> params = buildParams(query, from, to);
    String get = _platform_get.invokeMethod<String>('get', {'host': TRANS_API_HOST,'params':params}) as String;
    return get;
  }

  String getRandom() {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strlenght = 30;

    /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  Map<String, String> buildParams(String query, String from, String to) {
    String salt = getRandom();
    // 签名
    String src = appid + query + salt + securityKey; // 加密前的原文
//    params.put("sign", MD5.md5(src));
    String md5 = _platform.invokeMethod<String>('md5', {'input': src}) as String;
    LogUtils.e("chinesepoem", md5);

    Map<String, String> params = {
      "q": query,
      "to": to,
      "appid": appid,
      "salt": salt,
      "sign": 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM',
    };
    return params;
  }

}
