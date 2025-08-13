import 'package:flutter/material.dart';
import 'midtrans_payment_page.dart';

class MidtransDialog {
  /// Menampilkan dialog pembayaran Midtrans
  ///
  /// Mengembalikan 'success' jika pembayaran berhasil,
  /// 'failed' jika pembayaran gagal atau dibatalkan,
  /// null jika dialog ditutup tanpa menyelesaikan pembayaran
  static Future<String?> showPaymentDialog(
      BuildContext context, String snapToken) async {
    String? paymentResult;

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Show confirmation dialog when user tries to close
            final shouldClose = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text(
                    'Apakah Anda yakin ingin menutup halaman pembayaran? Jika pembayaran sudah berhasil, pesanan akan tetap diproses.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Ya, Tutup'),
                  ),
                ],
              ),
            );
            return shouldClose ?? false;
          },
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () async {
                            // Show confirmation dialog
                            final shouldClose = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah Anda yakin ingin menutup halaman pembayaran? Jika pembayaran sudah berhasil, pesanan akan tetap diproses.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Ya, Tutup'),
                                  ),
                                ],
                              ),
                            );
                            if (shouldClose == true) {
                              Navigator.of(context).pop('closed');
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      child: MidtransPaymentPage(snapToken: snapToken),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return result;
  }
}
