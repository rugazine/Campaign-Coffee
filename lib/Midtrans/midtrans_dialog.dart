import 'package:flutter/material.dart';
import 'midtrans_payment_page.dart';

class MidtransDialog {
  /// Menampilkan dialog pembayaran Midtrans
  /// 
  /// Mengembalikan 'success' jika pembayaran berhasil,
  /// 'failed' jika pembayaran gagal atau dibatalkan,
  /// null jika dialog ditutup tanpa menyelesaikan pembayaran
  static Future<String?> showPaymentDialog(BuildContext context, String snapToken) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pembayaran Midtrans',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.7,
                child: MidtransPaymentPage(snapToken: snapToken),
              ),
            ],
          ),
        );
      },
    );
  }
}