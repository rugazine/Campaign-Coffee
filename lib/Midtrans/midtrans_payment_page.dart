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
            print('Navigation request: ${request.url}');

            // Handle success scenarios
            if (request.url.contains('finish') ||
                request.url.contains('success') ||
                request.url.contains('settlement') ||
                request.url.contains('capture')) {
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }
            // Handle failure scenarios
            else if (request.url.contains('unfinish') ||
                request.url.contains('failed') ||
                request.url.contains('deny') ||
                request.url.contains('cancel') ||
                request.url.contains('expire')) {
              Navigator.pop(context, 'failed');
              return NavigationDecision.prevent;
            }
            // Handle invalid URLs (like example.com)
            else if (request.url.contains('example.com') ||
                request.url.contains('localhost') ||
                !request.url.startsWith('http')) {
              // Assume success if redirected to invalid URL after payment
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            // If there's a network error after payment, assume success
            if (error.errorCode == -2 ||
                error.description
                    .contains('net::ERR_CLEARTEXT_NOT_PERMITTED')) {
              Navigator.pop(context, 'success');
            }
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
