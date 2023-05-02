import 'package:collection/collection.dart';

/// Takes first word of given text.
String takeFirst(String text) {
  return text.split(" ").firstOrNull ?? '';
}

/// Truncates given text at given cutoff and replaces the rest with ellipsis.
String truncateWithEllipsis(int cutoff, String text) {
  return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
}
