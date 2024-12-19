import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:pims/_router/main.dart';

class LinkWell extends StatelessWidget {
  const LinkWell({
    super.key,
    required this.to,
    this.params,
    this.method = 'toNamed',
    required this.child,
  });
  final String? to;
  final Map<String, String>? params;
  final String? method;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        if (to != null && to != '') {
          Future.delayed(Duration(milliseconds: 200), () {
            if (method == 'toNamed') {
              Get.rootDelegate.toNamed(
                to ?? homeRoute,
                arguments: true,
                parameters: params,
              );
            }
            if (method == 'offAllNamed') {
              Get.rootDelegate.offAndToNamed(
                to ?? homeRoute,
                arguments: true,
                parameters: params,
              );
            }
          });
        }
      },
      child: child,
    );
  }
}

class BackWell extends StatelessWidget {
  const BackWell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        Future.delayed(Duration(milliseconds: 200), () {
          Get.rootDelegate.popRoute();
        });
      },
      child: child,
    );
  }
}

class QRButton extends StatelessWidget {
  const QRButton({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      width: 65,
      height: 65,
      child: FittedBox(
        child: FloatingActionButton(
          elevation: 1.5,
          shape: CircleBorder(
            side: BorderSide(color: primaryColor.withOpacity(0.75)),
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 200), () {
              Get.rootDelegate.toNamed(
                '/order',
                parameters: {'order_tab': 'active'},
              );
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SvgPicture.asset(
              'assets/icons/cart.svg',
              width: 40,
              height: 40,
              colorFilter: ColorFilter.mode(
                primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
