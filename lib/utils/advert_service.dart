import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {

      //test
      //return 'ca-app-pub-3940256099942544/6300978111';
      //original
      return 'ca-app-pub-8721131084537312/4465530794';
    } else if (Platform.isIOS) {
      //test
      //return 'ca-app-pub-3940256099942544/6300978111';
      //original
      return 'ca-app-pub-8721131084537312/5675504832';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }


}