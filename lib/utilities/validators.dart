bool isYouTubeChannelValid(String url) {
  final List<String> words =
      url.split('/').where((e) => e.isNotEmpty).toList(growable: false);

  if (url.contains('https://www.youtube.com/@')) {
    return (words.length == 3) && (words[2].length > 1);
  }

  if (url.contains('https://www.youtube.com/channel/')) {
    return (words.length == 4) && (words[3].length == 24);
  }

  return false;
}

bool isYouTubeVideoValid(String url) {
  return ((url.contains('https://www.youtube.com/watch?v=')) &&
      (url.split('=')[1].length == 11));
}

bool isAtPrefixedNameValid(String name) {
  return (name[0] == '@') && (name.length > 1);
}
