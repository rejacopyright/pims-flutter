// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/storage.dart';
import 'package:pims/_widgets/nodata.dart';
import 'package:pims/_widgets/order_item_card.dart';

fetchOrderCancel() async {
// final queryParameters = {'page': 1, 'limit': 2};
  final api = await API().get('/order/cancel');
  // await API().get('/order/cancel', queryParameters: queryParameters);
  final result = List.generate(api.data?['data']?.length ?? 0, (i) {
    return api.data?['data']?[i];
  });
  await storage.write('order_cancel', result);
  return result;
}

class CancelOrderController extends GetxController {
  RxBool isReady = false.obs;
  RxList order_cancel = [].obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      isReady.value = true;
      try {
        final res = await fetchOrderCancel();
        order_cancel.value = res;
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

class CancelOrderPage extends StatelessWidget {
  const CancelOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(CancelOrderController());
    store.onInit();
    final primaryColor = Theme.of(context).primaryColor;
    return Obx(() {
      List data = store.order_cancel;
      final isReady = store.isReady.value;
      return RefreshIndicator(
        color: primaryColor,
        displacement: 20,
        onRefresh: () async {
          store.refresh();
        },
        child: ListView.builder(
          padding: EdgeInsets.only(top: 15, bottom: 150, left: 15, right: 15),
          itemCount: data.length,
          itemBuilder: (ctx, index) => isReady
              ? data.isEmpty
                  ? SizedBox(
                      height: Get.height / 1.5,
                      child: NoData(text: 'Tidak ada transaksi'))
                  : OrderItem(params: {'status': 'cancel'}, data: data[index])
              : OrderItemLoader(),
        ),
      );
    });
  }
}
