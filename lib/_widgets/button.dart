import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:pims/_router/main.dart';

class LinkWell extends StatelessWidget {
  const LinkWell(
      {super.key, required this.to, this.params, required this.child});
  final String? to;
  final Map<String, String>? params;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        if (to != null && to != '') {
          Future.delayed(Duration(milliseconds: 200), () {
            Get.rootDelegate.toNamed(
              '${homeRoute != '/' ? '$homeRoute/' : ''}${to ?? homeRoute}',
              arguments: true,
              parameters: params,
            );
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
    return SizedBox(
      width: 65,
      height: 65,
      child: FittedBox(
        child: FloatingActionButton(
          elevation: 1.5,
          shape: CircleBorder(),
          backgroundColor: Colors.white,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 200), () {
              // Get.rootDelegate.popRoute();
            });
          },
          child: SvgPicture.asset(
            'assets/icons/qr.svg',
            width: 40,
            height: 40,
            colorFilter: ColorFilter.mode(
              Theme.of(context).primaryColor.withOpacity(1),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
