import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    inspect(Get.rootDelegate.parameters['satu']);
    return const Placeholder();
  }
}
