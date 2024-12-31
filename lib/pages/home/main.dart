import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_controller/user_controller.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/navbar.dart';
import 'package:pims/_widgets/title_show_all.dart';
import 'package:pims/pages/home/banner_promo.dart';
import 'package:pims/pages/home/header.dart';
import 'package:pims/pages/home/service_card.dart';
import 'package:pims/pages/home/top_user_card.dart';

import 'top_program_card.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Homepage();
  }
}

class HomepageController extends GetxController {
  RxBool pageIsReady = true.obs;

  // @override
  // void onInit() async {
  //   try {
  //     final api = await API().get('/me');
  //     api;
  //   } catch (e) {
  //     e;
  //   }
  //   pageIsReady.value = true;
  //   super.onInit();
  // }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () {
      onInit();
    });
    super.refresh();
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeHeaderController = Get.put(HomeHeaderController());
    final topUserController = Get.put(TopUserCardController());
    final serviceController = Get.put(ServiceSectionController());
    final bannerController = Get.put(BannerPromoController());
    final topProgramCardController = Get.put(TopProgramCardController());
    // final programController = Get.put(ProgramSectionController());
    final userController = Get.put(UserController());
    userController.onInit();

    return Scaffold(
      bottomNavigationBar: NavbarWidget(name: '/app'),
      extendBody: true,
      floatingActionButton: QRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() {
        final user = userController.user.value;
        final avatar = userController.avatar.value;
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          displacement: 60,
          edgeOffset: 190,
          onRefresh: () async {
            userController.onInit();
            homeHeaderController.refresh();
            bannerController.refresh();
            serviceController.refresh();
            topUserController.refresh();
            topProgramCardController.refresh();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            scrollBehavior: MaterialScrollBehavior().copyWith(
              overscroll: false,
            ),
            slivers: [
              HomeHeader(user: user, avatar: avatar),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          child: BannerPromo(),
                        ),
                        // TitleShowAll(title: 'Temukan Tukang'),
                        ServiceSection(user: user),
                        TitleShowAll(
                          title: 'Top Program',
                          margin: EdgeInsets.only(top: 20),
                          onTapMore: () {
                            Get.rootDelegate.toNamed('/product');
                          },
                        ),
                        TopProgramCard(),
                        // Padding(padding: EdgeInsets.only(bottom: 5)),
                        // TitleShowAll(
                        //   title: 'Programs',
                        //   margin: EdgeInsets.only(top: 10),
                        // ),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //     (context, index) => Container(
              //       margin: EdgeInsets.symmetric(vertical: 10),
              //       child: ProgramSection(),
              //     ),
              //     childCount: 1,
              //   ),
              // ),
              SliverPadding(padding: EdgeInsets.only(bottom: 125))
            ],
          ),
        );
      }),
    );
  }
}
