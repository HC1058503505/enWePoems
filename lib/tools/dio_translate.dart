import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class DioManager {
  Dio _dio;

  DioManager._init() {
    BaseOptions options = BaseOptions(
        method: "get",
        baseUrl: "https://app.gushiwen.org/",
        connectTimeout: 5000,
        receiveTimeout: 3000,
        contentType: ContentType('application', 'x-www-form-urlencoded',
            charset: 'utf-8'));
    _dio = Dio(options);
  }


  static DioManager singleton = DioManager._init();

  factory DioManager() => singleton;

  Future<dynamic> translate({path}) async {
    _dio.options.baseUrl = "http://fanyi.youdao.com/openapi.do";
    Response response = await _dio.get(path);
    String responseStr = response.data.toString();
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  Future<dynamic> get({path, params}) async {
    Response response = await _dio.get(path, queryParameters: params);
    String responseStr = response.data.toString();
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  Future<dynamic> post({path, data}) async {
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
