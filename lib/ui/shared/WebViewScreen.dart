import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  String name;

  WebViewScreen(this.name);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: true,
        iconTheme: const IconThemeData(color: black),
        toolbarHeight: ScreenUtil().setHeight(61),
        backgroundColor: appBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text.rich(TextSpan(children: <TextSpan>[
          TextSpan(
              text: widget.name,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  color: lightRed,
                  fontSize: ScreenUtil().setSp(18))),
        ])),
      ),
      body:  WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.name == "Terms of Service"?'https://mudda.app/terms.html':widget.name == "FAQ section"?'https://mudda.app/faqs.html':widget.name == "Community Guidelines"?'https://mudda.app/community.html':'https://mudda.app/privacy.html',
      ),
    );
  }
}
