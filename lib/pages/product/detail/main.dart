import 'package:flutter/material.dart';
import 'package:pims/_widgets/button.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Class Detail'),
            BackWell(
              child: Text('KEMBALI'),
            )
          ],
        ),
      )),
    );
  }
}
