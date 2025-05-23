// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class MidtransPaymentPage extends StatefulWidget {
//   final int orderId;
//   final String
//       userToken; // token autentikasi user, sesuaikan kalau pakai sistem lain

//   const MidtransPaymentPage({
//     Key? key,
//     required this.orderId,
//     required this.userToken,
//   }) : super(key: key);

//   @override
//   _MidtransPaymentPageState createState() => _MidtransPaymentPageState();
// }

// class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
//   String? paymentUrl;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSnapToken();
//   }

//   Future<void> _fetchSnapToken() async {
//     final url = Uri.parse(
//         'https://campaign.rplrus.com/api/payment');
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': 'Bearer ${widget.userToken}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'order_id': widget.orderId}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final snapToken = data['snap_token'];

//         setState(() {
//           // URL untuk Snap Payment Midtrans
//           paymentUrl =
//               'https://app.sandbox.midtrans.com/snap/v1/pay?token=$snapToken';
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         _showError('Gagal mengambil snap token');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       _showError('Terjadi kesalahan: $e');
//     }
//   }

//   void _showError(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: Text('OK'),
//             onPressed: () => Navigator.of(ctx).pop(),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Memuat Pembayaran')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (paymentUrl == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Pembayaran')),
//         body: Center(child: Text('Tidak dapat memuat halaman pembayaran')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text('Pembayaran Midtrans')),
//       body: Webview(
//         initialUrl: paymentUrl,
//         javascriptMode: JavaScriptMode.unrestricted,
//         navigationDelegate: (NavigationRequest request) {
//           // Ganti URL sukses dan gagal sesuai pengaturan redirect di dashboard Midtrans kamu
//           if (request.url.contains('your-success-url')) {
//             Navigator.pop(context, 'success');
//           } else if (request.url.contains('your-failed-url')) {
//             Navigator.pop(context, 'failed');
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//   }
// }
