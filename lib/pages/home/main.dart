import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/navbar.dart';
import 'package:pims/pages/home/banner_promo.dart';
import 'package:pims/pages/home/header.dart';
import 'package:pims/pages/home/program_card.dart';
import 'package:pims/pages/home/service_card.dart';
import 'package:pims/pages/home/top_user_card.dart';

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
    List<Widget> content = [
      Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: BannerPromo(),
      ),
      // TitleShowAll(title: 'Temukan Tukang'),
      ServiceSection(),
      // TitleShowAll(
      //   title: 'Trainers',
      //   margin: EdgeInsets.only(top: 5, bottom: 5),
      // ),
      // TopUserCard(),
      // Padding(padding: EdgeInsets.only(bottom: 5)),
      // TitleShowAll(
      //   title: 'Programs',
      //   margin: EdgeInsets.only(top: 10),
      // ),
    ];

    final homeHeaderController = Get.put(HomeHeaderController());
    final topUserController = Get.put(TopUserCardController());
    final serviceController = Get.put(ServiceSectionController());
    final bannerController = Get.put(BannerPromoController());
    final programController = Get.put(ProgramSectionController());

    return Scaffold(
      bottomNavigationBar: NavbarWidget(name: '/app'),
      extendBody: true,
      floatingActionButton: QRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [HomeHeader()];
        },
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          displacement: 30,
          onRefresh: () async {
            homeHeaderController.refresh();
            bannerController.refresh();
            serviceController.refresh();
            topUserController.refresh();
            programController.refresh();
          },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            scrollBehavior: MaterialScrollBehavior().copyWith(
              overscroll: false,
            ),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Column(children: content);
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
              SliverPadding(padding: EdgeInsets.only(bottom: 100))
            ],
          ),
        ),
      ),
    );
  }
}
