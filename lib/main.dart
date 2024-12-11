import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '_config/theme.dart';
import '_router/main.dart';

void main() async {
  await GetStorage.init();
  runApp(AppState());
}

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => MyApp();
}

class MyApp extends State<AppState> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'id';
    initializeDateFormatting();
    final box = GetStorage();
    bool hasToken = box.hasData('token');
    box.listen(() {
      setState(() {
        hasToken = false;
      });
      if (box.read('token') == null) {
        Get.rootDelegate.toNamed('/login');
      } else {
        // Get.rootDelegate.toNamed(homeRoute);
        // Get.rootDelegate
        //     .toNamed(Get.rootDelegate.currentConfiguration!.locationString);
      }
    });
    return GetMaterialApp(
      title: 'Flutter Demos',
      localizationsDelegates: [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('id'),
      ],
      // defaultTransition: Transition.rightToLeft,
      // transitionDuration: Duration.zero,
      debugShowCheckedModeBanner: !hasToken,
      showPerformanceOverlay: false,
      theme: themeConfig(),
      opaqueRoute: true,
      enableLog: false,
      getPages: routes(),
      // routes: routes(),
      // home: HomeApp(),
      // routes: ,
      builder: (ctxParent, state) => GetRouterOutlet.builder(
        routerDelegate: Get.rootDelegate,
        // key: navKey,
        builder: (ctx, delegate, currentRoute) {
          // final String name =
          //     currentRoute != null ? currentRoute.currentPage!.name : homeRoute;
          // final NavStore navController = Get.put(NavStore());
          return Scaffold(
            body: GetRouterOutlet(
              navigatorKey: delegate.navigatorKey,
              delegate: delegate,
              // initialRoute: homeRoute,
              initialRoute: hasToken ? homeRoute : '/login',
              anchorRoute: '/',
            ),
            // bottomNavigationBar:
            //     pageHasNav.contains(name) || navController.nav.value
            //         ? SafeArea(
            //             child: NavbarWidget(
            //               name: name != homeRoute
            //                   ? name.replaceAll(homeRoute, '')
            //                   : name,
            //             ),
            //           )
            //         : SafeArea(
            //             child: SizedBox.shrink(),
            //           ),
          );
        },
      ),
    );
  }
}
