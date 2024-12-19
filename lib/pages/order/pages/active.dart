// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/storage.dart';
import 'package:pims/_widgets/nodata.dart';
import 'package:pims/_widgets/order_item_card.dart';

fetchOrderActive() async {
// final queryParameters = {'page': 1, 'limit': 2};
  final api = await API().get('/order/active');
  // await API().get('/order/active', queryParameters: queryParameters);
  final result = List.generate(api.data?['data']?.length ?? 0, (i) {
    return api.data?['data']?[i];
  });
  await storage.write('order_active', result);
  return result;
}

class ActiveOrderController extends GetxController {
  RxBool isReady = false.obs;
  RxList order_active = [].obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      isReady.value = true;
      try {
        final res = await fetchOrderActive();
        order_active.value = res;
      } catch (e) {
        //
      }
    });
    super.onInit();
  }

  @override
  void refresh() {
    isReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onInit();
    });
    super.refresh();
  }

  @override
  void onClose() {
    isReady.value = false;
    super.onClose();
  }
}

class ActiveOrderPage extends StatelessWidget {
  const ActiveOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(ActiveOrderController());
    store.onInit();
    final primaryColor = Theme.of(context).primaryColor;
    return Obx(() {
      List data = store.order_active;
      final isReady = store.isReady.value;
      return RefreshIndicator(
        color: primaryColor,
        displacement: 20,
        onRefresh: () async {
          store.refresh();
        },
        child: ListView.builder(
          padding: EdgeInsets.only(top: 15, bottom: 150, left: 15, right: 15),
          itemCount: data.isEmpty ? 1 : data.length,
          itemBuilder: (ctx, index) => isReady
              ? data.isEmpty
                  ? SizedBox(
                      height: Get.height / 1.5,
                      child: NoData(text: 'Tidak ada transaksi'))
                  : OrderItem(params: {'status': 'active'}, data: data[index])
              : OrderItemLoader(),
        ),
      );
    });
  }
}
