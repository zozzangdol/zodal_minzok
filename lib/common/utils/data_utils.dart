import '../const/data.dart';

class DataUtils {

  // @author zosu
  // @since 2024-03-24
  // @comment Model에서 image url 속성 변경 위한 static method

  static pathToUrl(String value) {
    return 'http://$ip$value';
  }

}