import 'package:ems_v4/views/widgets/builder/ems_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlaceMap extends StatelessWidget {
  const PlaceMap({super.key});
  @override
  Widget build(BuildContext context) {
    // final WebViewController controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int progress) {
    //         // Update loading bar.
    //       },
    //       onPageStarted: (String url) {},
    //       onPageFinished: (String url) {},
    //       onWebResourceError: (WebResourceError error) {},
    //       onNavigationRequest: (NavigationRequest request) {
    //         if (request.url.startsWith('https://www.youtube.com/')) {
    //           return NavigationDecision.prevent;
    //         }
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..loadHtmlString(
    //       "<iframe width='1000' height='800' frameborder='0' style='border:0' src='https://www.google.com/maps/embed/v1/place?key=AIzaSyAiGzgFITTlOuq5BTzbwA0Kpm3z_kOj7ms&center=14.5828,121.0535&zoom=18&q=14.5828,121.0535' allowfullscreen></iframe>");

    return EMSContainer(
      child: Column(
        children: [
          const Text("View map"),
          // SizedBox(
          //   height: Get.height * .5,
          //   width: Get.width,
          //   // child: WebViewWidget(controller: controller),
          // ),
        ],
      ),
    );
  }
}
