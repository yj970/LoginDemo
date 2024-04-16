import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 获取从上一个页面传递进来的参数
    dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    String url = arguments[0];

    return Scaffold(
        body: WebView(
      initialUrl: url, // 要加载的网页地址
      javascriptMode: JavascriptMode.unrestricted, // 允许执行JavaScript
    ));
  }
}
