import 'package:color/color.dart';

class TransColor {
  static int trancolor(int red, int green, int blue) {
    Color rgbColor = new Color.rgb(red, green, blue);
    HexColor hexColor = rgbColor.toHexColor();
    String hexvalue = hexColor.toString();

    String colorStr = "FF" + hexvalue;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  static String trancolortostring(String colorStr) {
    int pos = colorStr.indexOf("x");
    String color = colorStr.substring(pos + 3, pos + 9);
    return color;
  }

  static RGB trancolortorgb(String colorStr) {
    print(colorStr);
    int pos = colorStr.indexOf("x");
    String subcolor = colorStr.substring(pos + 3, pos + 9);
    HexColor hexColor = new HexColor(subcolor);
    RgbColor rgbColor = hexColor.toRgbColor();
    int red = rgbColor.r;
    int green = rgbColor.g;
    int blue = rgbColor.b;
    print('trancolorred$red');
    print('trancolorgreen$green');
    print('trancolorblue$blue');
    RGB color = new RGB();
    color.red = red;
    color.green = green;
    color.blue = blue;
    return color;
  }
}

class RGB {
  int red;
  int green;
  int blue;
}
