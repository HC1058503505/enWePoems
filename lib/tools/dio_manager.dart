import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutterapp/tools/LogUtils.dart';

class DioManager {
  Dio _dio;

  DioManager._init() {
    BaseOptions options = BaseOptions(
        method: "get",
        connectTimeout: 5000,
        receiveTimeout: 3000,
        contentType: ContentType('application', 'x-www-form-urlencoded',
            charset: 'utf-8'));
    _dio = Dio(options);
  }

  static DioManager singleton = DioManager._init();

  factory DioManager() => singleton;

  Future<String> translate({path, params}) async {
    _dio.options.baseUrl = "http://fanyi.youdao.com/";
    Response response = await _dio.get(path, queryParameters: params);
    var responseStr = response.data as Map<String, dynamic>;
    var arr = responseStr['translation'] as List<dynamic>;
//    String responseStr = "{"translation": "LimeYin", "query": "石灰吟", "errorCode": "0"}";
//    var responseJson = json.decode(responseStr);

    return arr[0];
  }

  Future<dynamic> get({path, params}) async {
    _dio.options.baseUrl = "https://app.gushiwen.org/";
    Response response = await _dio.get(path, queryParameters: params);
    String responseStr = response.data.toString();
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  Future<dynamic> post({path, data}) async {
    _dio.options.baseUrl = "https://app.gushiwen.org/";
    _dio.options.method = "post";
    Response response = await _dio.post(path, data: data);
    String responseStr = response.data.toString();
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  void cancle() {
    CancelToken cancleT = CancelToken();
    cancleT.cancel("cancelled");
  }
}
