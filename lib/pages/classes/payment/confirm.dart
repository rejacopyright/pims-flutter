import 'package:flutter/material.dart';
import 'package:pims/_widgets/payment/payment_card.dart';
import 'package:pims/pages/classes/payment/appbar.dart';
import 'package:pims/pages/classes/payment/bottom_nav.dart';

class ClassPaymentConfirmation extends StatelessWidget {
  const ClassPaymentConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ClassPaymentAppBar(),
      bottomNavigationBar: ClassPaymentBottomNav(),
      body: SafeArea(
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          scrollBehavior: MaterialScrollBehavior().copyWith(overscroll: false),
          slivers: [
            SliverList.builder(
              itemCount: 1,
              itemBuilder: (sliverContext, index) {
                return Column(
                  children: [
                    Text('xxx'),
                    PaymentCard(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
