import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_widgets/member_detail_cards.dart';

import 'appbar.dart';

class MemberDetailPage extends StatelessWidget {
  const MemberDetailPage({super.key});

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
      appBar: MemberDetailAppBar(),
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
                            MemberDetailPaymentBank(
                              provider: provider,
                              account_no: '123085766666393',
                            ),
                            MemberDetailPurchaseTime(),
                            MemberDetailPrice(),
                          ]
                        : [SizedBox.shrink()],
                  ),
                  Column(
                    children: isActive
                        ? [MemberDetailQR(), MemberDetailQuota()]
                        : [SizedBox.shrink()],
                  ),
                  Column(
                    children: isDone
                        ? [
                            MemberDetailPaymentMethod(provider: provider),
                            MemberDetailPrice(),
                          ]
                        : [SizedBox.shrink()],
                  ),
                  Container(
                    child: isCancel ? MemberDetailCancel() : SizedBox.shrink(),
                  ),
                  MemberDetailItem(),
                  Container(
                    child: isActive ? MemberDetailRefund() : SizedBox.shrink(),
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
