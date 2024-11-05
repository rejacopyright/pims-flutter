import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/navbar_controller.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/button.dart';

class NavbarWidget extends StatelessWidget {
  NavbarWidget({super.key, this.name});
  final String? name;
  final navController = Get.put(NavStore());

  @override
  Widget build(BuildContext context) {
    final List<String> childrenOfApp = menusNav
        .firstWhereOrNull((e) => e.name == homeRoute)!
        .children!
        .map((e) => e.name)
        .toList();
    return Obx(
      () {
        if (navController.nav.value) {
          return Container(
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0, -2.5),
                  blurRadius: 5,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    children: menusNav.map(
                      (menu) {
                        final isChildrenOfApp = homeRoute != '/' &&
                            menu.name == homeRoute &&
                            childrenOfApp.contains(name);
                        final isMain = name == '/' && menu.name == homeRoute;
                        final isCurrentRoute =
                            name.toString().startsWith(menu.name) ||
                                isChildrenOfApp ||
                                isMain;
                        if (menu.name == '/spacer') {
                          return Spacer();
                        }
                        return Expanded(
                          child: LinkWell(
                            to: menu.name,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    isCurrentRoute
                                        ? menu.activeIcon
                                        : menu.icon,
                                    color: isCurrentRoute
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                    size: 22.5),
                                const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.5)),
                                Text(
                                  menu.label ?? '',
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: isCurrentRoute
                                          ? Theme.of(context).primaryColor
                                          : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  Positioned(
                    top: -25,
                    left: (MediaQuery.of(context).size.width / 2) - 35,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            offset: const Offset(0, -5),
                            blurRadius: 7.5,
                            spreadRadius: -7.5,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                        clipBehavior: Clip.antiAlias,
                        child: LinkWell(
                          to: '/test',
                          child: Container(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/qr.svg',
                              width: 45,
                              height: 45,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).primaryColor.withOpacity(1),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
