import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrCameraResult extends StatelessWidget {
  const QrCameraResult({super.key});

  @override
  Widget build(BuildContext context) {
    // dynamic scanQR;
    Future<void> scanQR() async {
      String barcodeScanRes;
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff5722', 'Cancel', true, ScanMode.QR);
        debugPrint(barcodeScanRes);
      } on PlatformException {
        barcodeScanRes = 'Failed to get Flatform version';
      }
      //  if (!mounted) return;
      //  setState(() {});
    }

    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Scan Kode QR',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        child: Center(
          child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('scan barcode'),
                ElevatedButton(onPressed: (){
                 scanQR();
                }, child: const Text('Scan QR'))
              ],
            ),
            
            
          
        ),
      ),
    );
  }
}
