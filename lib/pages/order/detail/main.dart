import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/order_detail_cards.dart';
import 'package:pims/pages/order/detail/appbar.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final params = Get.parameters;
    final status = params['status'];
    final provider = params['provider'] ?? 'bca';

    // VERIFY
    final isUnpaid = status != null && status == 'unpaid';
    final isActive = status != null && status == 'active';
    final isDone = status != null && status == 'done';
    final isCancel = status != null && status == 'cancel';
    return Scaffold(
      appBar: OrderDetailAppBar(),
      body: RefreshIndicator(
        displacement: 30,
        color: primaryColor,
        onRefresh: () async {},
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Column(
                    children: isUnpaid
                        ? [
                            OrderDetailPaymentBank(
                              provider: provider,
                              account_no: '123085766666393',
                            ),
                            OrderDetailPurchaseTime(),
                            OrderDetailPrice(),
                          ]
                        : [SizedBox.shrink()],
                  ),
                  Container(
                    child: isActive ? OrderDetailQR() : SizedBox.shrink(),
                  ),
                  Column(
                    children: isDone
                        ? [
                            OrderDetailPaymentMethod(provider: provider),
                            OrderDetailPrice(),
                          ]
                        : [SizedBox.shrink()],
                  ),
                  Container(
                    child: isCancel ? OrderDetailCancel() : SizedBox.shrink(),
                  ),
                  OrderDetailItem(),
                  Container(
                    child: isActive ? OrderDetailRefund() : SizedBox.shrink(),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 50))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
