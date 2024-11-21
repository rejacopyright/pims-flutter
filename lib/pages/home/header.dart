import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/helper.dart';

class HomeHeaderController extends GetxController {
  RxBool pageIsReady = true.obs;

  setPageIsReady(val) {
    pageIsReady.value = val;
  }

  @override
  void onReady() {
    // pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      pageIsReady.value = true;
    });
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () {
      onReady();
    });
    super.refresh();
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double expandedHeight = 125;
    double toolbarHeight = 70;
    return SliverLayoutBuilder(
        builder: (BuildContext context, sliverConstraints) {
      final bool isCollapsed =
          sliverConstraints.scrollOffset + toolbarHeight > expandedHeight;
      final Color statusBarColor =
          isCollapsed ? Colors.white : Colors.transparent;
      return SliverAppBar(
        backgroundColor: statusBarColor,
        shadowColor: Colors.black.withOpacity(0.25),
        elevation: 1,
        pinned: true,
        snap: false,
        floating: false,
        stretch: true,
        stretchTriggerOffset: 20,
        expandedHeight: expandedHeight,
        collapsedHeight: toolbarHeight,
        toolbarHeight: toolbarHeight,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          stretchModes: [
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
          ],
          expandedTitleScale: 1.1,
          centerTitle: true,
          titlePadding: EdgeInsets.all(0.0),
          title: HomeHeaderContent(),
          background: HomeHeaderBackground(),
        ),
      );
    });
  }
}

class HomeHeaderContent extends StatelessWidget {
  const HomeHeaderContent({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(HomeHeaderController());
    final box = GetStorage();
    final user = box.read('user');
    var name = user['username'];
    if (user['first_name'] != null && user['last_name'] != null) {
      name = '${user['first_name']} ${user['last_name']}';
    } else if (user['first_name'] != null) {
      name = user['first_name'];
    } else if (user['last_name'] != null) {
      name = user['last_name'];
    }
    name = name.toString().toTitleCase();
    return Obx(() {
      final pageIsReady = state.pageIsReady.value;
      return Container(
        // width: double.infinity,
        margin: EdgeInsets.only(bottom: 5, left: 15, right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: pageIsReady
              ? [
                  Container(
                    height: 60,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black.withOpacity(0.75),
                      elevation: 1,
                      child: InkWell(
                        splashFactory: InkSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: () {},
                        child: Row(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.symmetric(horizontal: 7.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 35,
                              height: 35,
                              child: Image.asset(
                                'assets/avatar/3.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.5),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 2.5,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2.5),
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Icon(
                                          Iconsax.empty_wallet5,
                                          size: 16,
                                          color: primaryColor,
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Wrap(
                                          children: [
                                            Text(
                                              'Rp. ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              currency.format(int.parse(
                                                  (user['wallet'] ?? 0)
                                                      .toString())),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              indent: 10,
                              endIndent: 10,
                              color: Color(0xffdddddd),
                            ),
                            GestureDetector(
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 200), () {
                                  Get.rootDelegate.toNamed(
                                    '${homeRoute != '/' ? '$homeRoute/' : ''}${'/member'}',
                                  );
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xfff0f0f0),
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 3.5,
                                  horizontal: 6,
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3.5),
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        Iconsax.crown5,
                                        size: 18,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Membership',
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          'Miliki Sekarang',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SearchField(),
                ]
              : [
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                ],
        ),
      );
    });
  }
}

class HomeHeaderBackground extends StatelessWidget {
  const HomeHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.antiAlias,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // primaryColor.withOpacity(0),
                primaryColor.withOpacity(0.5),
                primaryColor.withOpacity(0.75),
                primaryColor.withOpacity(0.85),
                primaryColor.withOpacity(1),
              ],
            ),
          ),
        ),
        Positioned(
          right: -375,
          top: -10,
          bottom: -200,
          child: Transform.rotate(
            angle: 0.35,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
        Positioned(
          right: -320,
          top: 0,
          bottom: -125,
          child: Transform.rotate(
            angle: 0.45,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
      ],
    );
  }
}
