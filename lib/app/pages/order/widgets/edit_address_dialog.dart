import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class EditAddressDialog extends StatefulWidget {
  final OrderController orderController;

  const EditAddressDialog({Key? key, required this.orderController})
      : super(key: key);

  @override
  State<EditAddressDialog> createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends State<EditAddressDialog> {
  static const mainBlue = Color.fromRGBO(8, 76, 172, 1);
  late String selectedDistrict;
  late String selectedSubDistrict;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    selectedDistrict = 'Serpong';
    selectedSubDistrict = 'Lengkong Karya';
    addressController = TextEditingController(
        text: widget.orderController.deliveryAddressDetail.value);
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Address',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Kecamatan',
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: mainBlue),
                ),
              ),
              value: selectedDistrict,
              items: ['Serpong', 'Ciputat', 'Pamulang', 'Pondok Aren']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDistrict = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Kelurahan',
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: mainBlue),
                ),
              ),
              value: selectedSubDistrict,
              items: [
                'Lengkong Karya',
                'Lengkong Wetan',
                'Lengkong Gudang',
                'Rawa Mekar'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSubDistrict = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Alamat Lengkap',
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
                hintText: 'Nama jalan, gang, nomor rumah',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey.shade400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: mainBlue),
                ),
              ),
              style: const TextStyle(fontFamily: 'Poppins'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.orderController.updateDeliveryAddress(
                        '$selectedDistrict, $selectedSubDistrict',
                        addressController.text,
                      );
                      // TODO: Integrasi ke API jika ingin update address user di backend
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
