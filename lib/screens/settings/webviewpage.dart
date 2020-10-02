import 'dart:async';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:kuku/utils/customfirestore.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String privacypolicylink = '';
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    loadPrivacyUrl();
  }

  loadPrivacyUrl() async {
    try {
      CustomFirestore _customFirestore = CustomFirestore();
      privacypolicylink = await _customFirestore.loadPrivacyPolicyUrl();
      setState(() {
        //update view
        print('privacypolicylink: ' + privacypolicylink);
      });
    } catch (error) {
      setState(() {
        print('Error here: '+error);
        errorMsg = error.toString();
        print(error.code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constant.primiumThemeSelected
              ? Constant.gradientStartColor
              : Constant.selectedColor,
          title: Text('Privacy Policy'),
        ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return errorMsg != ''
            ? Text(errorMsg, style: TextStyle(color: Colors.black),)
            : (privacypolicylink == ''
                ? Center(child: CircularProgressIndicator())
                : WebView(
                    initialUrl: privacypolicylink,
                    javascriptMode: JavascriptMode.unrestricted,
                  ));
      }),
    );
  }
}
