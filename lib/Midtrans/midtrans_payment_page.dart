import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPaymentPage extends StatefulWidget {
  final String snapToken;
  const MidtransPaymentPage({Key? key, required this.snapToken})
      : super(key: key);

  @override
  State<MidtransPaymentPage> createState() => _MidtransPaymentPageState();
}

class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
  late final WebViewController _controller;
  late String paymentUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    paymentUrl =
        'https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('finish')) {
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            } else if (request.url.contains('unfinish') ||
                request.url.contains('failed')) {
              Navigator.pop(context, 'failed');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return WebViewWidget(controller: _controller);
  }
}
