import 'package:flutter/material.dart';
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
          Future.delayed(const Duration(milliseconds: 200), () {
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
        Future.delayed(const Duration(milliseconds: 200), () {
          Get.rootDelegate.popRoute();
        });
      },
      child: child,
    );
  }
}
