import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/member_explore_detail_cards.dart';
import 'package:pims/pages/member/explore/item.dart';

import 'appbar.dart';
import 'bottom_nav.dart';

fetchDetailMemberPackage(String? id) async {
  try {
    final api = await API().get('/member/package/$id/detail');
    return api.data;
  } catch (e) {
    return null;
  }
}

class MemberExploreDetailController extends GetxController {
  RxBool pageIsReady = false.obs;
  final detailPackage = Rxn<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    // pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () async {
      try {
        final id = Get.rootDelegate.parameters['id'];
        final res = await fetchDetailMemberPackage(id);
        detailPackage.value = res;
      } finally {
        pageIsReady.value = true;
      }
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onInit();
    });
    super.refresh();
  }
}

class MemberExploreDetailPage extends StatelessWidget {
  const MemberExploreDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final store = Get.put(MemberExploreDetailController());
    return Scaffold(
      appBar: MemberExploreDetailAppBar(),
      bottomNavigationBar: SafeArea(child: MemberExploreDetailBottomNav()),
      body: RefreshIndicator(
        displacement: 30,
        color: primaryColor,
        onRefresh: () async {
          store.refresh();
        },
        child: Obx(() {
          final pageIsReady = store.pageIsReady.value;
          final detailPackage = store.detailPackage.value;
          final features = detailPackage?['member_features'] != null
              ? detailPackage!['member_features']
              : [];

          return ListView.builder(
            shrinkWrap: true,
            itemCount: pageIsReady ? 1 : 3,
            itemBuilder: (BuildContext context, int index) {
              return pageIsReady
                  ? Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          MemberExploreItem(detail: detailPackage),
                          MemberExploreDetailDescription(
                            headerText: 'Description',
                            text: detailPackage?['description'],
                          ),
                          MemberExploreDetailFeatures(features: features),
                          MemberExploreDetailDescription(
                            headerText: 'Syarat & Ketentuan',
                            headerTextColor: Colors.white,
                            headerBackgroundColor: primaryColor,
                            text: detailPackage?['tnc'],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: MemberExploreItemLoader(),
                    );
            },
          );
        }),
      ),
    );
  }
}
