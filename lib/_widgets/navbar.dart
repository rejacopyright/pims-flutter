import 'package:flutter/material.dart';
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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, -5),
                  blurRadius: 5,
                  spreadRadius: -2.5,
                ),
              ],
            ),
            child: BottomAppBar(
              height: 65,
              shadowColor: Colors.black,
              elevation: 50,
              padding: EdgeInsets.zero,
              shape: CircularNotchedRectangle(),
              color: Colors.white,
              surfaceTintColor: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              notchMargin: 10,
              child: Row(
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
                        method: 'offAllNamed',
                        to: menu.name,
                        params: menu.name == '/order'
                            ? {'order_tab': 'active'}
                            : {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isCurrentRoute ? menu.activeIcon : menu.icon,
                                color: isCurrentRoute
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                size: 22.5),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.5)),
                            Text(
                              menu.label ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCurrentRoute
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
