import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/form.dart';
import 'package:pims/_widgets/navbar.dart';
import 'package:pims/_widgets/program_card.dart';

class ProductController extends GetxController {
  RxBool pageIsReady = false.obs;
  @override
  void onReady() {
    Future.delayed(Duration(milliseconds: 100), () {
      pageIsReady.value = true;
    });
    super.onReady();
  }
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});
  final int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final store = Get.put(ProductController());
    double searchPadding = 15;
    double expandedHeight = 100;
    double toolbarHeight = kToolbarHeight + searchPadding;

    List<ProgramState> programData = [
      ProgramState(
        title: 'Jiu Jitsu',
        category: 'Fungsional',
        image: 'assets/images/sample/jujutsu.jpg',
        price: 100000,
        userImage: 'assets/avatar/1.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Tai Chi',
        category: 'Studio',
        image: 'assets/images/sample/taichi.jpg',
        price: 150000,
        userImage: 'assets/avatar/2.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Karate',
        category: 'Fungsional',
        image: 'assets/images/sample/karate.jpg',
        price: 100000,
        userImage: 'assets/avatar/3.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Muay Thai',
        category: 'Studio',
        image: 'assets/images/sample/muaythai.jpg',
        price: 25000,
        userImage: 'assets/avatar/4.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Kung Fu',
        category: 'Fungsional',
        image: 'assets/images/sample/kungfu.jpg',
        price: 35000,
        userImage: 'assets/avatar/5.png',
        userName: 'Reja Jamil',
      ),
      ProgramState(
        title: 'Taekwondo',
        category: 'Studio',
        image: 'assets/images/sample/taekwondo.jpg',
        price: 3000000,
        userImage: 'assets/avatar/6.png',
        userName: 'Reja Jamil',
      ),
    ];

    return Scaffold(
      bottomNavigationBar: NavbarWidget(name: '/product'),
      extendBody: true,
      floatingActionButton: QRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() {
        final pageIsReady = store.pageIsReady.value;
        if (pageIsReady) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            displacement: 75,
            onRefresh: () async {
              store.pageIsReady.value = false;
              return Future.delayed(Duration(milliseconds: 300), () {
                store.pageIsReady.value = true;
              });
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverLayoutBuilder(
                  builder: (context, sliverConstraints) {
                    // final bool isCollapsed =
                    //     sliverConstraints.scrollOffset + toolbarHeight >
                    //         expandedHeight;
                    // final Color statusBarColor =
                    //     isCollapsed ? Colors.white : Colors.transparent;
                    return SliverAppBar(
                      // backgroundColor: statusBarColor,
                      backgroundColor: Colors.white,
                      pinned: true,
                      floating: false,
                      stretch: true,
                      stretchTriggerOffset: 20,
                      onStretchTrigger: () async {},
                      shadowColor: Colors.black.withOpacity(0.25),
                      automaticallyImplyLeading: false,
                      surfaceTintColor: Colors.transparent,
                      expandedHeight: expandedHeight,
                      toolbarHeight: toolbarHeight,
                      flexibleSpace: FlexibleSpaceBar(
                        expandedTitleScale: 1.15,
                        centerTitle: true,
                        titlePadding: EdgeInsets.all(0.0),
                        title: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin:
                              EdgeInsetsDirectional.only(bottom: searchPadding),
                          child: SearchField(),
                        ),
                        background: Image.asset(
                          'assets/images/header-gym-1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 0, vertical: searchPadding),
                      child: GridView.count(
                        clipBehavior: Clip.antiAlias,
                        childAspectRatio: 5 / 6,
                        crossAxisCount: crossAxisCount,
                        padding: EdgeInsets.only(
                            top: 0, bottom: 15, left: 15, right: 15),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        // controller:
                        //     ScrollController(keepScrollOffset: false),
                        scrollDirection: Axis.vertical,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: programData.map((item) {
                          return ProgramCard(
                              item: item, crossAxisCount: crossAxisCount);
                        }).toList(),
                      ),
                    );
                  }, childCount: 1),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 100))
              ],
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 125,
              margin: EdgeInsets.only(bottom: 20),
              color: Colors.black.withOpacity(0.05),
            ),
            GridView.count(
              clipBehavior: Clip.antiAlias,
              childAspectRatio: 1,
              crossAxisCount: crossAxisCount,
              padding: EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // controller:
              //     ScrollController(keepScrollOffset: false),
              scrollDirection: Axis.vertical,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                4,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
