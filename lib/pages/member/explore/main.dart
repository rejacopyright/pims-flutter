import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';

import 'appbar.dart';
import 'item.dart';

fetchMemberPackage(Map<String, dynamic> queryParameters) async {
  try {
    final api =
        await API().get('/member/package', queryParameters: queryParameters);
    final result = List.generate(api.data?['data']?.length ?? 0, (i) {
      return api.data?['data']?[i];
    });
    return result;
  } catch (e) {
    return [];
  }
}

class MemberExploreController extends GetxController {
  RxBool pageIsReady = false.obs;
  RxList dataPackage = [].obs;

  @override
  void onInit() {
    // pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 100), () async {
      try {
        final res = await fetchMemberPackage({'page': 1, 'limit': 100});
        dataPackage.value = res;
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

class MemberExplorePage extends StatelessWidget {
  const MemberExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final store = Get.put(MemberExploreController());
    return Scaffold(
      appBar: MemberExploreAppBar(),
      body: RefreshIndicator(
        color: primaryColor,
        displacement: 20,
        onRefresh: () async {
          store.refresh();
        },
        child: Obx(() {
          final dataPackage = store.dataPackage;
          final pageIsReady = store.pageIsReady.value;
          return ListView.builder(
            padding: EdgeInsets.only(top: 15, bottom: 150, left: 15, right: 15),
            itemCount: pageIsReady ? dataPackage.length : 3,
            itemBuilder: (ctx, index) {
              return pageIsReady
                  ? MemberExploreItem(detail: dataPackage[index])
                  : MemberExploreItemLoader();
            },
          );
        }),
      ),
    );
  }
}
