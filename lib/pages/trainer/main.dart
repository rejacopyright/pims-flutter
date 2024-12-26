import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';

import 'appbar.dart';
import 'item.dart';

fetchTtrainerSchedule() async {
  try {
    final api = await API().get('/trainer/my-schedule');
    final result = List.generate(api.data?['data']?.length ?? 0, (i) {
      return api.data?['data']?[i];
    });
    return result;
  } catch (e) {
    return [];
  }
}

class TrainerController extends GetxController {
  RxBool pageIsReady = false.obs;
  RxList mySchedules = [].obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = false;
      try {
        final res = await fetchTtrainerSchedule();
        mySchedules.value = res;
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

class TrainerPage extends StatelessWidget {
  const TrainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final store = Get.put(TrainerController());
    return Scaffold(
      appBar: TrainerAppBar(),
      body: RefreshIndicator(
        color: primaryColor,
        displacement: 20,
        onRefresh: () async {
          store.refresh();
        },
        child: Obx(() {
          final mySchedules = store.mySchedules;
          final pageIsReady = store.pageIsReady.value;
          return ListView.builder(
            padding: EdgeInsets.only(top: 15, bottom: 150, left: 15, right: 15),
            itemCount: pageIsReady ? mySchedules.length : 3,
            itemBuilder: (ctx, index) {
              return pageIsReady
                  ? TrainerScheduleItem(detail: mySchedules[index])
                  : TrainerScheduleItemLoader();
            },
          );
        }),
      ),
    );
  }
}
