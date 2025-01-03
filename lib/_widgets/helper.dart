import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class DownloaderState {
  DownloaderState({required this.fileName, required this.baseUrl});
  String fileName;
  String baseUrl;
}

class FileDownloader {
  Dio dio = Dio();
  bool isSuccess = false;

  void startDownloading(BuildContext context, DownloaderState params,
      final Function okCallback) async {
    String path = await getFilePath('/${params.fileName}');

    try {
      await dio.download(
        params.baseUrl,
        path,
        onReceiveProgress: (recivedBytes, totalBytes) {
          okCallback(recivedBytes, totalBytes);
        },
        deleteOnError: true,
      ).then((_) {
        isSuccess = true;
      });
    } catch (e) {
      //
    }

    if (isSuccess) {
      Get.rootDelegate.popRoute();
    }
  }

  Future<String> getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      //
    }
    return "${dir?.path}$filename";
  }
}
