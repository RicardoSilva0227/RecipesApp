String removeHtmlTags(String html) {
  final RegExp regExp = RegExp(r'<[^>]*>');
  return html.replaceAll(regExp, '');
}