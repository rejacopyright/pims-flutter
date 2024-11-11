import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/button.dart';

class ClassDetailPage extends StatelessWidget {
  const ClassDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    log(Get.rootDelegate.parameters['type'].toString());
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Class Detail ini'),
            BackWell(
              child: Text('KEMBALI'),
            )
          ],
        ),
      )),
    );
  }
}
