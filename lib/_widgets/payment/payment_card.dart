import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_controller/payment_controller.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    return Obx(() {
      final paymentData = paymentController.paymentData.value;
      return ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Transfer Bank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          paymentData != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: paymentData
                      .where((item) => item.type == 1) // bank_transfer
                      .map((item) => PaymentItem(item: item))
                      .toList(),
                )
              : SizedBox.shrink(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'E - Wallets',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          paymentData != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: paymentData
                      .where((item) => item.type == 2) // e_wallet
                      .map((item) => PaymentItem(item: item))
                      .toList(),
                )
              : SizedBox.shrink(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Bayar di Konter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          paymentData != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: paymentData
                      .where((item) => item.type == 3) // counter
                      .map((item) => PaymentItem(item: item))
                      .toList(),
                )
              : SizedBox.shrink(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Metode Lainnya',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          paymentData != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: paymentData
                      .where((item) => item.type == 4) // other
                      .map((item) => PaymentItem(item: item))
                      .toList(),
                )
              : SizedBox.shrink(),
          SizedBox(height: 20),
        ],
      );
    });
  }
}

class PaymentItem extends StatefulWidget {
  const PaymentItem({super.key, required this.item});

  final PaymentData item;

  @override
  State<PaymentItem> createState() => PaymentItemState();
}

class PaymentItemState extends State<PaymentItem> {
  bool btnIsLoading = false;
  setBtnIsLoading(e) => setState(() => btnIsLoading = e);
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final paymentController = Get.put(PaymentController());
    final item = widget.item;
    return Obx(() {
      final thisPaymentIsChecked =
          item.name == paymentController.selectedPayment.value?.name;
      final paymentAccount = paymentController.paymentAccount.toList();
      bool isGopay = item.name == 'gopay-xxx';
      dynamic gopay;
      if (isGopay) {
        gopay = paymentAccount.firstWhereOrNull((e) => e?['type'] == 'gopay');
      }
      return InkWell(
        splashColor: Colors.transparent,
        onTap: !isGopay || (isGopay && gopay != null)
            ? () {
                paymentController
                    .setSelectedPayment(thisPaymentIsChecked ? null : item);
              }
            : null,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          margin: EdgeInsets.symmetric(vertical: 5),
          // height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: thisPaymentIsChecked ? primaryColor : Color(0xffeaeaea),
            ),
            color: thisPaymentIsChecked
                ? primaryColor.withValues(alpha: 0.05)
                : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Image.asset(
                  item.icon ?? 'assets/icons/no-image.png',
                  width: 60,
                  fit: BoxFit.cover,
                  opacity: AlwaysStoppedAnimation(1),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              child: item.description != null
                                  ? Text(
                                      item.description ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffaaaaaa),
                                        fontSize: 12,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      isGopay && gopay == null
                          ? ElevatedButton(
                              onPressed: btnIsLoading
                                  ? null
                                  : () async {
                                      setBtnIsLoading(true);
                                      await paymentController.createGopayLink();
                                      setBtnIsLoading(false);
                                    },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: Size.zero,
                                shape: StadiumBorder(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 7.5,
                                ),
                              ),
                              child: Text(
                                btnIsLoading ? 'Waiting...' : 'Aktivasi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Icon(
                                Iconsax.tick_circle5,
                                color: thisPaymentIsChecked
                                    ? primaryColor
                                    : Color(0xffdddddd),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
