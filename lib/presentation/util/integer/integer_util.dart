class IntegerUtil {

  String getPluralSuffix({required int count}) {
    switch (count) {
      case 1: return "";
      default: return "s";
    }
  }
}