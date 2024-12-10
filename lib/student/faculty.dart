
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';



class FacultyPage extends StatefulWidget {
  const FacultyPage({super.key});



  @override
  _FacultyPage createState() => _FacultyPage();
}

class _FacultyPage extends State<FacultyPage> {
  //create webview controller

  WebViewController controller  = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://muhendislik.mu.edu.tr/'));



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          //add progress bar whil site is loading
          child: openPage(controller)
          //child: Center(child:Text("Faculty Page")),
        ),
      //create webview for faculty page

    );
  }
}
WebViewWidget openPage(controller){
  const CircularProgressIndicator();
  return WebViewWidget(controller:controller);
}