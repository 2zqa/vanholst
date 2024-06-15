extension StringUtils on String {
  String retrieveBetween(String start, String end) {
    final startIndex = indexOf(start);
    if (startIndex == -1) {
      return '';
    }
    final endIndex = indexOf(end, startIndex + start.length);
    if (endIndex == -1) {
      return '';
    }
    return substring(startIndex + start.length, endIndex);
  }
}
