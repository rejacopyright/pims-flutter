import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/navbar.dart';
import 'package:pims/pages/profile/app_bar.dart';
import 'package:pims/pages/profile/cards.dart';
import 'package:pims/pages/profile/order_status.dart';

class ProfileController extends GetxController {
  RxBool pageIsReady = false.obs;
  final order = Rxn<Map<String, dynamic>>(null);
  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = false;
      try {
        final api = await API().get('/profile');
        order.value = api.data?['order'];
      } catch (e) {
        //
      } finally {
        pageIsReady.value = true;
      }
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 500), () {
      onInit();
    });
    super.refresh();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(ProfileController());
    final profileOrderStatusController =
        Get.put(ProfileOrderStatusController());
    final profileCardsController = Get.put(ProfileCardsController());
    return Obx(() {
      final pageIsReady = state.pageIsReady.value;
      final order = state.order.value;
      return Scaffold(
        bottomNavigationBar: NavbarWidget(name: '/profile'),
        extendBody: true,
        floatingActionButton: QRButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: NestedScrollView(
          floatHeaderSlivers: false,
          physics: ClampingScrollPhysics(),
          scrollBehavior: MaterialScrollBehavior().copyWith(
            overscroll: false,
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverLayoutBuilder(
                builder: (context, sliverConstraints) {
                  final isOffset = sliverConstraints.scrollOffset > 5;
                  return SliverAppBar(
                    pinned: true,
                    toolbarHeight: 0,
                    backgroundColor:
                        isOffset ? Colors.white : Colors.transparent,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: DecoratedBox(
                          decoration: BoxDecoration(
                        color: isOffset
                            ? Colors.white
                            : Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.85),
                      )),
                    ),
                  );
                },
              )
            ];
          },
          body: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            displacement: 30,
            onRefresh: () async {
              state.refresh();
              profileOrderStatusController.refresh();
              profileCardsController.refresh();
            },
            child: CustomScrollView(
              physics: ClampingScrollPhysics(),
              scrollBehavior: MaterialScrollBehavior().copyWith(
                overscroll: false,
              ),
              slivers: [
                ProfileAppBar(pageIsReady: pageIsReady, order: order),
                SliverList.builder(
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 25),
                        child: Text(
                          'Pesanan Saya',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ProfileOrderStatus(),
                      // ProfileCards(),
                      Padding(padding: EdgeInsets.only(top: 20)),
                    ],
                  ),
                  itemCount: 1,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
