import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/pages/auth/login/main.dart';
import 'package:pims/pages/auth/register/confirm.dart';
import 'package:pims/pages/auth/register/main.dart';
import 'package:pims/pages/classes/detail/main.dart';
import 'package:pims/pages/classes/main.dart';
import 'package:pims/pages/classes/payment/confirm.dart';
import 'package:pims/pages/home/main.dart';
import 'package:pims/pages/member/detail/main.dart';
import 'package:pims/pages/member/explore/detail/main.dart';
import 'package:pims/pages/member/explore/main.dart';
import 'package:pims/pages/member/main.dart';
import 'package:pims/pages/order/detail/main.dart';
import 'package:pims/pages/order/main.dart';
import 'package:pims/pages/product/detail/main.dart';
import 'package:pims/pages/product/main.dart';
import 'package:pims/pages/profile/edit/main.dart';
import 'package:pims/pages/profile/main.dart';
import 'package:pims/pages/trainer/main.dart';
import 'package:pims/pages/viewTrainer/main.dart';
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

class AuthMiddleware extends GetMiddleware {
  final box = GetStorage();

  @override
  Future<GetNavConfig?> redirectDelegate(route) async {
    bool hasToken = box.hasData('token');
    if (!hasToken) {
      return Get.rootDelegate.toNamed('/login');
    }
    return await super.redirectDelegate(route);
  }
}

const String homeRoute = '/app';

class Scoper extends StatelessWidget {
  const Scoper({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        // final history = Get.rootDelegate.history;
        // final prevRoute = history.length < 2
        //     ? history.last.currentTreeBranch.firstOrNull!.name
        //     // ? history.last.currentPage!.name
        //     : history[history.length - 2].currentPage!.name;

        // final bool isNavMenu = menusNav.map((m) => m.name).contains(name);
        if (didPop) {
          // Navigator.pushNamedAndRemoveUntil(context, homeRoute, predicate)
          // Get.offAllNamed('/home', predicate: (route) => Get.currentRoute == '/home');
          // return;
        }

        // if (!['/', homeRoute].contains(name)) {
        //   if (!isNavMenu) {
        //     history.isEmpty
        //         ? Get.offNamed(homeRoute)
        //         // : Get.offNamed(prevRoute);
        //         : Get.back();
        //     // : Get.backUntil(prevRoute, popMode: PopMode.History);
        //   } else if (isNavMenu) {
        //     // Get.offNamed(homeRoute);
        //   }
        // }
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
    page: Scoper(child: HomeApp()),
    label: 'Beranda',
    icon: Iconsax.home_2,
    activeIcon: Iconsax.home_25,
    children: [
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
      GetPage(
        name: '/member',
        page: () => MemberPage(),
        children: [
          GetPage(name: '/detail', page: () => MemberDetailPage()),
          GetPage(
            name: '/explore',
            page: () => MemberExplorePage(),
            children: [
              GetPage(name: '/detail', page: () => MemberExploreDetailPage()),
            ],
          ),
        ],
      ),
      GetPage(
        name: '/trainer',
        page: () => TrainerPage(),
      ),
    ],
  ),
  Route(
    name: '/product',
    page: Scoper(child: ProductApp()),
    // page: ProductApp(),
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
    page: Scoper(child: ProductApp()),
  ),
  Route(
    name: '/view/trainer',
    page: Scoper(child: ViewTrainerApp()),
    label: 'Trainer',
    icon: Iconsax.profile_2user,
    activeIcon: Iconsax.profile_2user5,
    middlewares: [AuthMiddleware()],
    children: [
      GetPage(
        name: '/detail',
        page: () => Placeholder(),
        participatesInRootNavigator: true,
      ),
    ],
  ),
  Route(
    name: '/profile',
    page: Scoper(child: ProfilePage()),
    label: 'Akun',
    icon: Iconsax.profile_circle,
    activeIcon: Iconsax.profile_tick5,
    children: [
      GetPage(
        name: '/edit',
        page: () => ProfileEditPage(),
        participatesInRootNavigator: true,
      ),
    ],
  ),
];

List<String> pageHasNav = [
  '/likes',
  ...(menusNav.map((e) => e.name)),
].map((e) => e != homeRoute ? '$homeRoute$e' : e).toList();

List<GetPage> publicRoutes() {
  return [
    GetPage(
      name: '/login',
      preventDuplicates: true,
      participatesInRootNavigator: true,
      transition: Transition.noTransition,
      transitionDuration: Duration.zero,
      page: () => Scoper(child: LoginPage()),
    ),
    GetPage(
      name: '/register',
      preventDuplicates: true,
      participatesInRootNavigator: true,
      page: () => Scoper(child: RegisterPage()),
      children: [
        GetPage(
          name: '/confirm',
          page: () => Scoper(child: RegisterConfirmPage()),
        ),
      ],
    ),
  ];
}

List<GetPage> routes() {
  return [
    GetPage(
        name: '/',
        preventDuplicates: true,
        participatesInRootNavigator: true,
        page: () => HomeApp(),
        transition: Transition.noTransition,
        transitionDuration: Duration.zero,
        children: [
          ...publicRoutes(),
          ...menusNav.map(
            (e) => GetPage(
              name: e.name,
              preventDuplicates: true,
              participatesInRootNavigator: true,
              page: () => e.page,
              transition: Transition.noTransition,
              transitionDuration: Duration.zero,
              middlewares: e.middlewares,
              children: e.children ?? [],
            ),
          ),
          GetPage(
            name: '/order',
            page: () => Scoper(child: OrderPage()),
            middlewares: [AuthMiddleware()],
            children: [
              GetPage(
                name: '/detail',
                page: () => OrderDetailPage(),
                participatesInRootNavigator: true,
              ),
            ],
          ),
        ]),
  ];
}
