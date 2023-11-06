import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/dio/communication.dart';
import 'package:mudda/dio/method/delete.dart';
import 'package:mudda/dio/method/get.dart';
import 'package:mudda/dio/method/patch.dart';
import 'package:mudda/dio/method/post.dart';
import 'package:mudda/dio/method/uploadPost.dart';
import 'package:mudda/ui/screens/login_screen/view/login_screen.dart';

class Api {
  static ApiClient apiClient = ApiClient(
    host: "userapi-dev.mudda.app",
    hostScheme: "https",
    hostPath: "api",
    onResponse: (context, method, response, statusCode, bool isLoading) {
      if (isLoading) {
        Const.progressDialog.dismissProgressDialog(context);
      }
      return response['status'] == 1;
    },
    onError: (context, method, error, bool isLoading) {
      if (isLoading) {
        Const.progressDialog.dismissProgressDialog(context);
      }
      if (error.contains('SocketException')) {
        error = 'No Internet Connection';
      }
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(error),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('retry'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    },
    onMsg: (context, method, response, statusCode, bool isLoading) {
      if (response['message'].toString().contains('Invalid Token')) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Const.progressDialog.dismissProgressDialog(context);
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(response['message'].toString(),
                  style: const TextStyle(color: Colors.black)),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      print("MSG:::$response");
    },
    onStart: (context, method, bool isLoading) {
      // Api.apiClient.defaultHeaderMap.putIfAbsent("Authorization", () => "Bearer ${SessionManager.getString(Session.AUTH_KEY)}");
      if (isLoading) {
        if (!Const.progressDialog.isDismissed) {
          Const.progressDialog.dismissProgressDialog(context);
          Const.progressDialog.showProgressDialog(context);
        } else {
          Const.progressDialog.showProgressDialog(context);
        }
      }
    },
  );
  static Get get = Get(apiClient);
  static Post post = Post(apiClient);
  static Delete delete = Delete(apiClient);
  static UploadPost uploadPost = UploadPost(apiClient);
  static Patch patch = Patch(apiClient);
}

class ApiForLogin {
  static ApiClient apiClient = ApiClient(
    host: "login.mudda.app",
    hostScheme: "https",
    hostPath: "api",
    onResponse: (context, method, response, statusCode, bool isLoading) {
      if (isLoading) {
        Const.progressDialog.dismissProgressDialog(context);
      }
      return response['status'] == 1;
    },
    onError: (context, method, error, bool isLoading) {
      if (isLoading) {
        Const.progressDialog.dismissProgressDialog(context);
      }
      if (error.contains('SocketException') ||
          error.contains('Connection closed')) {
        error = 'No Internet Connection';
      }
      return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(error),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('retry'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    },
    onMsg: (context, method, response, statusCode, bool isLoading) {
      if (response['message'].toString().contains('Invalid Token')) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Const.progressDialog.dismissProgressDialog(context);
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(response['message'].toString(),
                  style: const TextStyle(color: Colors.black)),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      print("MSG:::$response");
    },
    onStart: (context, method, bool isLoading) {
      // Api.apiClient.defaultHeaderMap.putIfAbsent("Authorization", () => "Bearer ${SessionManager.getString(Session.AUTH_KEY)}");
      if (isLoading) {
        if (!Const.progressDialog.isDismissed) {
          Const.progressDialog.dismissProgressDialog(context);
          Const.progressDialog.showProgressDialog(context);
        } else {
          Const.progressDialog.showProgressDialog(context);
        }
      }
    },
  );
  static Get get = Get(apiClient);
  static Post post = Post(apiClient);
  static Delete delete = Delete(apiClient);
  static UploadPost uploadPost = UploadPost(apiClient);
  static Patch patch = Patch(apiClient);
}
