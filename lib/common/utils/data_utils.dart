import 'dart:convert';

import '../const/data.dart';

class DataUtils {

  // @author zosu
  // @since 2024-03-24
  // @comment Model에서 image url 속성 변경 위한 static method

  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  // @author zosu
  // @since 2024-06-26
  // @comment image가 List로 올 때 속성 변경
  static List<String> listPathToUrl(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }


  static String plainToBase64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    // Encoding
    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}