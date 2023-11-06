import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/dio/communication.dart';
import 'package:mudda/dio/excep/dio_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Get {
  ApiClient client;
  bool isLoading = true;
  Get(this.client);

  void call(BuildContext context,
      {required String method,
      required Map<String, dynamic> param,
      Function(Map object)? onResponseSuccess,
      Function(double percentage)? onProgress,bool? isLoading}) async{
    this.isLoading = isLoading ?? true;
    AppPreference _appPreference = AppPreference();
    if(_appPreference.getString(PreferencesKey.userToken).isNotEmpty) {
      client.addDefaultHeader(
          "Authorization", "Bearer ${_appPreference.getString(PreferencesKey.userToken)}");
    }
    var options = Options(
        method: "GET",
        contentType: 'application/json',
        headers: client.defaultHeaderMap);
      var request = client.dio.getUri(
        Uri(
            scheme: client.hostScheme,
            host: client.host,
            path: "${client.hostPath}/$method",
            queryParameters: param),
        options: options,
        onReceiveProgress: (count, total) {
          if (onProgress != null) {
            onProgress(total / count);
          }
        },
      );
    log("URI:::-=-=- ${Uri(
        scheme: client.hostScheme,
        host: client.host,
        path: "${client.hostPath}/$method",
        queryParameters: param)}");
    log("HEAD:::-=-=- ${client.defaultHeaderMap}");
    if (param != null) {
        log("PARAMS::: -=- $param");
      }

      client.startCall(context, method,this.isLoading);
      request.then((response) {
        if (response.statusCode == 200) {
          log("-=-=- get response -=- ${response.data}");
          if (client.checkStatus(context, method, response.data, response.statusCode!,this.isLoading)) {
            if (onResponseSuccess != null) {
              onResponseSuccess(response.data);
            }
          } else {
            client.onMsg(context, method, response.data, response.statusCode!,this.isLoading);
          }
        } else {
          client.onError(context, method, "Something went wrong!",this.isLoading);
        }
      },onError: (e){
        debugPrint("ERRORR:::${e.toString()}");
        client
            .onError(
            context,
            method,
            e is DioError
                ? DioExceptions.fromDioError(e).message!
                : e.toString(),this.isLoading)
            .then((value) async {
              if(value != null && value) {
                retry(e, context, method, onResponseSuccess!, this.isLoading);
              }
        });
      });
  }

  Future<Response<Map>> futureCall(BuildContext context,
      {required String method,
        required Map<String, dynamic> param,bool? isLoading}) {
    this.isLoading = isLoading ?? true;
    AppPreference _appPreference = AppPreference();
    if(_appPreference.getString(PreferencesKey.userToken).isNotEmpty) {
      client.addDefaultHeader(
          "Authorization", "Bearer ${_appPreference.getString(PreferencesKey.userToken)}");
    }
    var options = Options(
        method: "GET",
        contentType: 'application/json',
        headers: client.defaultHeaderMap);
    var request = client.dio.get<Map>(
      "/$method",
      options: options,
      queryParameters: param,
      onReceiveProgress: (count, total) {

      },
    );
    log("URI:::-=-=-=-=- ${Uri(
        scheme: client.hostScheme,
        host: client.host,
        path: "${client.hostPath}/$method",
        queryParameters: param)}");
    log("HEAD:::-=-=- ${client.defaultHeaderMap}");
    if (param != null) {
      log("PARAMS::: -=-=- $param");
    }

    client.startCall(context, method,this.isLoading);
    return request;
  }

  Future<Response<Map>> futureGoogleAddressCall(BuildContext context,
      {required String method,
        required Map<String, dynamic> param,bool? isLoading}) {
    this.isLoading = isLoading ?? true;
    var options = Options(
        method: "GET",
        contentType: 'application/json',
        headers: client.defaultHeaderMap);
    var request = Dio().getUri<Map>(
      Uri(
          scheme: "https",
          host: "maps.googleapis.com",
          path: "maps/api/$method",
          queryParameters: param),
      options: options,
      onReceiveProgress: (count, total) {

      },
    );
    print("URI:::${Uri(
        scheme: client.hostScheme,
        host: client.host,
        path: "${client.hostPath}/$method",
        queryParameters: param)}");
    print("HEAD:::${client.defaultHeaderMap}");
    if (param != null) {
      print("PARAMS:::$param");
    }

    client.startCall(context, method,this.isLoading);
    return request;
  }

  void retry(e, BuildContext context, String method,
      Function(Map object) onResponseSuccess,bool isLoading) async {
    if (e is DioError) {
        var response = await client.dio.request(
          e.requestOptions.path,
          cancelToken: e.requestOptions.cancelToken,
          data: e.requestOptions.data,
          onReceiveProgress: e.requestOptions.onReceiveProgress,
          onSendProgress: e.requestOptions.onSendProgress,
          queryParameters: e.requestOptions.queryParameters,
        ).then((response) {
          if (response.statusCode == 200) {
            if (client.checkStatus(
                context, method, response.data, response.statusCode!,isLoading)) {
              if (onResponseSuccess != null) {
                onResponseSuccess(response.data);
              }
            } else {
              client.onMsg(context, method, response.data, response.statusCode!,isLoading);
            }
          } else {
            client.onError(context, method, "Something went wrong!",isLoading)
                .then((value) {
              if(value!) {
                retry(e,context,method,onResponseSuccess,isLoading);
              }
            });
          }
        },onError: (e){
          print("ONRETRY:::${e.toString()}");
          client.onError(
              context,
              method,
              e is DioError
                  ? DioExceptions.fromDioError(e).message!
                  : e.toString(),isLoading)
              .then((value) async {
            retry(e, context, method, onResponseSuccess,isLoading);
          });
        });
    }
  }
}
