import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

class QRCode {
  // QR Code Scanner
  static Future<String> scanBarcode() async {
    String _barcode;
    try {
      _barcode = await BarcodeScanner.scan();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _barcode = 'The user did not grant the camera permission!';
      } else {
        _barcode = 'Unknown error: $e';
      }
    } on FormatException {
      _barcode =
          'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      _barcode = 'Unknown error: $e';
    }
    return _barcode;
  }
}
