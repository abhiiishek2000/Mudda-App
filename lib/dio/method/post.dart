import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/dio/excep/dio_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../communication.dart';


class Post {
  ApiClient client;
  bool isLoading = true;
  Post(this.client);

  void call(BuildContext context,
      {required String method,
      required Map<String, dynamic> param,
      Function(Map object)? onResponseSuccess,
        Function(String message)? onRetry,
      Function(double percentage)? onProgress,bool? isLoading}) async {
    this.isLoading = isLoading ?? true;
    log("PARAMS:::$param:::$isLoading");
    AppPreference _appPreference = AppPreference();
    if(_appPreference.getString(PreferencesKey.userToken).isNotEmpty) {
      client.addDefaultHeader(
          "Authorization", "Bearer ${_appPreference.getString(PreferencesKey.userToken)}");
    }
    // log("URI:::-=-= ${Uri(
    //     scheme: client.hostScheme,
    //     host: client.host,
    //     path: "${client.hostPath}/$method",
    //     queryParameters: param)
    // }");
    client.startCall(context, method,this.isLoading);
    try {
      client.addDefaultHeader("Content-Type", "application/json");
      log("HEADER:::${client.defaultHeaderMap}");
      var response = await client.dio.post<Map>(
        "/$method",
        onReceiveProgress: (count, total) {
          if (onProgress != null) {
            //onProgress(total);
          }
        },
        data: jsonEncode(param),
        onSendProgress: (count, total) {
          if (onProgress != null) {
            onProgress((count / total) * 100);
          }
        },
      );

      if (response.statusCode == 200) {
        log("rs -------------   ${response.data is Map}");
        if (client.checkStatus(
            context, method, response.data!, response.statusCode!,this.isLoading)) {
          if (onResponseSuccess != null) {
            onResponseSuccess(response.data!);
          }
        } else {
          client.onMsg(context, method, response.data!, response.statusCode!,this.isLoading);
        }
      } else {
        client.onError(context, method, "Something went wrong!",this.isLoading).then((value) {
          if(onRetry != null){
            onRetry("Something went wrong!");
          }
        });
      }
    } catch (e) {
      print(e.toString());
      client.onError(context, method,e is DioError? DioExceptions.fromDioError(e).message!:e.toString(),this.isLoading).then((value)async {
        if(onRetry != null && value!){
          onRetry(e is DioError? DioExceptions.fromDioError(e).message!:e.toString());
          retry(e,context,method,onResponseSuccess!,this.isLoading);
        }
      });
    }
  }

  void retry(e, BuildContext context, String method, Function(Map object) onResponseSuccess,bool isLoading) async{
    if(e is DioError){
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
          client.onError(context, method, "Something went wrong!",isLoading).then((value) {
            if(value!) {
              retry(e, context, method, onResponseSuccess, isLoading);
            }
          });
        }
      },onError: (e){
        client.onError(context, method, "Something went wrong!",isLoading).then((value) {
          if(value!) {
            retry(e,context,method,onResponseSuccess,isLoading);
          }
        });
      });
    }
  }
}
