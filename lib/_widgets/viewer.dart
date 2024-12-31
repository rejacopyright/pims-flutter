import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({super.key, this.type = 'asset', required this.image});
  final String image;
  final String type;
  final imageController = TransformationController();

  @override
  Widget build(BuildContext context) {
    // TapDownDetails? doubleTapDetails;
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            // onDoubleTapDown: (d) => doubleTapDetails = d,
            child: SizedBox.expand(),
          ),
          InteractiveViewer(
            transformationController: imageController,
            // constrained: false,
            clipBehavior: Clip.none,
            maxScale: 3,
            child: GestureDetector(
              onDoubleTap: () {
                if (imageController.value != Matrix4.identity()) {
                  imageController.value = Matrix4.identity();
                } else {
                  // final position = doubleTapDetails!.localPosition;
                  imageController.value = Matrix4.identity()
                    // ..translate(-position.dx, -position.dy)
                    ..translate(-(MediaQuery.of(context).size.width / 2),
                        -(MediaQuery.of(context).size.height / 6))
                    ..scale(2.0);
                }
              },
              child: Ink.image(
                image:
                    type == 'asset' ? AssetImage(image) : NetworkImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
