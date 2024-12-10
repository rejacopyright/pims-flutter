// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/storage.dart';
import 'package:pims/_widgets/nodata.dart';
import 'package:pims/_widgets/order_item_card.dart';

fetchOrderUnpaid() async {
// final queryParameters = {'page': 1, 'limit': 2};
  final api = await API().get('/order/unpaid');
  // await API().get('/order/unpaid', queryParameters: queryParameters);
  final result = List.generate(api.data?['data']?.length ?? 0, (i) {
    return api.data?['data']?[i];
  });
  await storage.write('order_unpaid', result);
  return result;
}

class UnpaidOrderController extends GetxController {
  RxBool isReady = false.obs;
  RxList order_unpaid = [].obs;

  setOrderUnpaid(e) => order_unpaid.value = e;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      isReady.value = true;
      try {
        final res = await fetchOrderUnpaid();
        order_unpaid.value = res;
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

class UnpaidOrderPage extends StatelessWidget {
  const UnpaidOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Get.put(UnpaidOrderController());
    store.onInit();
    final primaryColor = Theme.of(context).primaryColor;
    return Obx(() {
      List data = store.order_unpaid;
      final isReady = store.isReady.value;
      return RefreshIndicator(
        color: primaryColor,
        displacement: 20,
        onRefresh: () async {
          store.refresh();
        },
        // NoData(text: 'Tidak ada transaksi'),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 15, bottom: 150, left: 15, right: 15),
          shrinkWrap: true,
          itemCount: data.isEmpty ? 1 : data.length,
          itemBuilder: (ctx, index) {
            return isReady
                ? data.isEmpty
                    ? SizedBox(
                        height: Get.height / 1.5,
                        child: NoData(text: 'Tidak ada transaksi'))
                    : OrderItem(params: {'status': 'unpaid'}, data: data[index])
                : OrderItemLoader();
          },
        ),
      );
    });
  }
}
