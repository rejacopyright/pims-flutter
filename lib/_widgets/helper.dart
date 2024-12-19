import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

NumberFormat currency = NumberFormat.decimalPatternDigits(
  locale: 'id_ID',
  decimalDigits: 0,
);

extension TitleCase on String {
  String toTitleCase() {
    return toLowerCase().replaceAllMapped(
        RegExp(
            r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
        (Match match) {
      return "${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}";
    }).replaceAll(RegExp(r'(_|-)+'), ' ');
  }
}

extension ToFixed on double {
  double toFixed(n) {
    return double.parse(toStringAsFixed(n));
  }
}

extension Uint8ListExtensions on Uint8List {
  bool startsWith(List<int> pattern) {
    if (pattern.length > length) return false;
    for (int i = 0; i < pattern.length; i++) {
      if (this[i] != pattern[i]) return false;
    }
    return true;
  }
}

urlToBase64(String imageUrl) async {
  try {
    final api =
        await Dio(BaseOptions(responseType: ResponseType.bytes)).get(imageUrl);
    final data = api.data;
    if (data != null) {
      final base64Encode = base64.encode(data);
      final decoded = base64.decode(base64Encode);
      dynamic ext = 'jpeg';
      if (decoded.startsWith([0xFF, 0xD8])) {
        ext = 'jpeg';
      } else if (decoded.startsWith([0x89, 0x50, 0x4E, 0x47])) {
        ext = 'png';
      } else if (decoded.startsWith([0x25, 0x50, 0x44, 0x46])) {
        ext = 'pdf';
      } else if (decoded.startsWith([0x00, 0x00, 0x00, 0x18]) ||
          decoded.startsWith([0x00, 0x00, 0x00, 0x20])) {
        ext = 'mp4';
      } else if (decoded.startsWith([0x1A, 0x45, 0xDF, 0xA3])) {
        ext = 'mkv';
      } else if (decoded.startsWith([0x49, 0x44, 0x33])) {
        ext = 'mp3';
      } else if (decoded.startsWith([0x4F, 0x67, 0x67, 0x53])) {
        ext = 'ogg';
      }

      final base64prefix = 'data:image/$ext;base64,';

      return '$base64prefix$base64Encode';
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
