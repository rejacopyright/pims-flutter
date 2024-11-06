import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pims/_widgets/navbar.dart';

import '_config/theme.dart';
import '_controller/navbar_controller.dart';
import '_router/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'id';
    initializeDateFormatting();
    return GetMaterialApp(
      title: 'Flutter Demos',
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: themeConfig(),
      opaqueRoute: true,
      getPages: routes(),
      builder: (ctxParent, state) => GetRouterOutlet.builder(
        routerDelegate: Get.rootDelegate,
        // key: navKey,
        builder: (ctx, delegate, currentRoute) {
          final String name =
              currentRoute != null ? currentRoute.currentPage!.name : homeRoute;
          final NavStore navController = Get.put(NavStore());
          return Scaffold(
            body: GetRouterOutlet(
              navigatorKey: delegate.navigatorKey,
              delegate: delegate,
              initialRoute: homeRoute,
              anchorRoute: '/',
            ),
            bottomNavigationBar:
                pageHasNav.contains(name) || navController.nav.value
                    ? SafeArea(
                        child: NavbarWidget(
                          name: name != homeRoute
                              ? name.replaceAll(homeRoute, '')
                              : name,
                        ),
                      )
                    : const SafeArea(
                        child: SizedBox.shrink(),
                      ),
          );
        },
      ),
    );
  }
}
