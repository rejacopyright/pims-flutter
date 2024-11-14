import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/pages/classes/detail/main.dart';
import 'package:pims/pages/classes/main.dart';
import 'package:pims/pages/classes/payment/confirm.dart';
import 'package:pims/pages/home/main.dart';
import 'package:pims/pages/order/detail/main.dart';
import 'package:pims/pages/order/main.dart';
import 'package:pims/pages/product/detail/main.dart';
import 'package:pims/pages/product/main.dart';
import 'package:pims/pages/visit/main.dart';

// class PageMiddelware extends GetMiddleware {
//   @override
//   void onPageDispose() {
//     super.onPageDispose();
//   }

//   @override
//   GetPage? onPageCalled(GetPage? page) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       systemStatusBarContrastEnforced: true,
//       statusBarIconBrightness: Brightness.dark, // Android
//       statusBarBrightness: Brightness.dark, // IOS
//     ));
//     return super.onPageCalled(page);
//   }
// }

const String homeRoute = '/app';

class Scoper extends StatelessWidget {
  const Scoper({
    super.key,
    required this.name,
    required this.child,
  });
  final String name;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        final history = Get.rootDelegate.history;
        // final prevRoute = history.length < 2
        //     ? history.last.currentTreeBranch.firstOrNull!.name
        //     // ? history.last.currentPage!.name
        //     : history[history.length - 2].currentPage!.name;

        final bool isNavMenu = menusNav.map((m) => m.name).contains(name);

        if (!['/', homeRoute].contains(name)) {
          if (!isNavMenu) {
            history.isEmpty
                ? Get.rootDelegate.offNamed(homeRoute)
                // : Get.rootDelegate.offNamed(prevRoute);
                : Get.rootDelegate.popRoute(popMode: PopMode.Page);
            // : Get.rootDelegate
            //     .backUntil(prevRoute, popMode: PopMode.History);
          } else if (isNavMenu) {
            // Get.rootDelegate.offNamed(homeRoute);
          }
        }
      },
      child: child,
    );
  }
}

class Route {
  final String name;
  final Widget page;
  final List<GetMiddleware>? middlewares;
  final String? label;
  final IconData? icon;
  final IconData? activeIcon;
  final List<GetPage>? children;

  Route({
    required this.name,
    required this.page,
    this.middlewares,
    this.label,
    this.icon,
    this.activeIcon,
    this.children,
  });
}

List<Route> menusNav = [
  Route(
    name: homeRoute,
    page: Scoper(name: homeRoute, child: HomeApp()),
    label: 'Beranda',
    icon: Iconsax.home_2,
    activeIcon: Iconsax.home_25,
    children: [
      GetPage(
        name: '/home/product/detail',
        page: () => ProductDetailPage(),
      ),
      GetPage(
        name: '/services/visit',
        page: () => VisitPage(),
        // transition: Transition.fade,
      ),
      GetPage(name: '/services/class', page: () => ClassPage(), children: [
        GetPage(name: '/detail', page: () => ClassDetailPage(), children: [
          GetPage(name: '/payment', page: () => ClassPaymentConfirmation()),
        ]),
      ]),
    ],
  ),
  Route(
    name: '/product',
    page: Scoper(name: '/product', child: ProductApp()),
    label: 'Program',
    icon: Iconsax.search_status,
    activeIcon: Iconsax.search_status4,
    children: [
      GetPage(
        name: '/detail',
        preventDuplicates: true,
        participatesInRootNavigator: true,
        page: () => ProductDetailPage(),
      ),
    ],
  ),
  Route(
    name: '/spacer',
    page: Scoper(name: '/spacer', child: ProductApp()),
  ),
  Route(
      name: '/order',
      page: Scoper(name: '/order', child: OrderPage()),
      label: 'Pesanan',
      icon: Iconsax.shopping_cart,
      activeIcon: Iconsax.shopping_cart5,
      children: [
        GetPage(name: '/detail', page: () => OrderDetailPage()),
      ]),
  Route(
    name: '/account',
    page: Scoper(name: '/account', child: ProductApp()),
    label: 'Akun',
    icon: Iconsax.profile_circle,
    activeIcon: Iconsax.profile_circle5,
  ),
];

List<String> pageHasNav = [
  '/likes',
  ...(menusNav.map((e) => e.name)),
].map((e) => e != homeRoute ? '$homeRoute$e' : e).toList();

List<GetPage> routes() {
  return [
    GetPage(
      name: '/',
      preventDuplicates: true,
      participatesInRootNavigator: true,
      page: () => Scoper(name: '/', child: HomeApp()),
      children: [
        GetPage(
          name: homeRoute,
          preventDuplicates: true,
          participatesInRootNavigator: true,
          page: () => Scoper(name: homeRoute, child: HomeApp()),
          children: [
            ...(menusNav
                    .firstWhereOrNull((e) => e.name == homeRoute)!
                    .children ??
                []),
            ...menusNav.where((e) => e.name != homeRoute).map((e) => GetPage(
                  name: e.name,
                  preventDuplicates: true,
                  participatesInRootNavigator: true,
                  page: () => e.page,
                  transition: Transition.noTransition,
                  transitionDuration: Duration.zero,
                  // middlewares: e.middlewares,
                  children: e.children ?? [],
                )),
            // GetPage(
            //   name: '/services/visit',
            //   preventDuplicates: true,
            //   participatesInRootNavigator: true,
            //   page: () => Scoper(
            //     name: '/services/visit',
            //     child: ProductApp(),
            //   ),
            // ),
          ],
        ),
      ],
    )
  ];
}
