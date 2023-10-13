// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:qr_flutter/qr_flutter.dart'; // Import the qr_flutter package

// class UserController extends GetxController {
//   RxString name = ''.obs;
//   RxString noKk = ''.obs;
//   RxString email = ''.obs;
//   RxString phoneNumber = ''.obs;
//   RxString qrCodeData = ''.obs;

//   // Set the user data
//   void setUser(
//       String userName, String kk, String userEmail, String phone, String qrData) {
//     name.value = userName;
//     noKk.value = kk;
//     email.value = userEmail;
//     phoneNumber.value = phone;
//     qrCodeData.value = qrData;
//   }

// Future<Uint8List?> generateQRCode() async {
//   final qrImage = QrImage(
//     data: qrCodeData.value,
//     version: QrVersions.auto,
//     size: 200,
//   );

//   final img.Image? qrImageData = qrImage.toImage(200, 200);

//   if (qrImageData != null) {
//     final img.Image byteData = img.encodePng(qrImageData);
//     return Uint8List.fromList(img.encodePng(byteData));
//   }

//   return null;
// }
// }
