library communication;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class ResponseStatus {
  bool checkStatus(
      BuildContext context, String method, Map response, int statusCode,bool isLoading);

  void startCall(BuildContext context, String method,bool isLoading);

  void callError(BuildContext context, String method, String error,bool isLoading);

  void callMsg(
      BuildContext context, String method, Map response, int statusCode,bool isLoading);
}

/// A ApiClient.
class ApiClient implements ResponseStatus {
  String host;
  String hostScheme;
  int hostPort;
  final Map<String, dynamic> _defaultHeaderMap = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    "Access-Control-Allow-Origin": "*", // Required  CORS support to work
    "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS, GET, HEAD, PATCH"
  };
  Dio? _dio;

  bool Function(
          BuildContext context, String method, Map response, int statusCode,bool isLoading)
      onResponse;
  void Function(BuildContext context, String method,bool isLoading) onStart;

  Future<bool?> Function(BuildContext context, String method, String error,bool isLoading) onError;
  void Function(
      BuildContext context, String method, Map response, int statusCode,bool isLoading) onMsg;

  String hostPath;

  ApiClient(
      {required this.host,
      required this.hostScheme,
      this.hostPort = 80,
      this.hostPath = "",
      required this.onResponse,
      required this.onError,
      required this.onMsg,
      required this.onStart}) {
    var options = BaseOptions(
      baseUrl: Uri(
        scheme: hostScheme,
        host: host,
        path: hostPath,
      ).toString(),
      connectTimeout: 500000,
      receiveTimeout: 300000,
    );
    _dio = Dio(options);

  }

  void addDefaultHeader(String key, String value) {
    _defaultHeaderMap[key] = value;
  }

  Map<String, dynamic> get defaultHeaderMap => _defaultHeaderMap;

  @override
  bool checkStatus(BuildContext context, String method,
      Map<dynamic, dynamic> response, int statusCode,bool isLoading) {
    bool b =  onResponse(context, method, response, statusCode,isLoading);
    return b;
  }

  @override
  void startCall(BuildContext context, String method,bool isLoading) {
    print("${_dio!.options.baseUrl}/$method");
    onStart(context, method,isLoading);
  }

  @override
  void callError(BuildContext context, String method, String error,bool isLoading) {
    onError(context, method, error,isLoading);
  }

  @override
  void callMsg(BuildContext context, String method,
      Map<dynamic, dynamic> response, int statusCode,bool isLoading) {
    onMsg(context, method, response, statusCode,isLoading);
  }

  Dio get dio {
    _dio!.options.headers.addAll(_defaultHeaderMap);
    return _dio!;
  }
}
