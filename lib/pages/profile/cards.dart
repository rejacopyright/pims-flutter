import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/pages/profile/main.dart';

class ProfileCardsController extends ProfileController {}

class ProfileCards extends StatelessWidget {
  const ProfileCards({super.key});

  @override
  Widget build(BuildContext context) {
    final profileCardsController = Get.put(ProfileCardsController());

    return Obx(() {
      final pageIsReady = profileCardsController.pageIsReady.value;
      if (pageIsReady) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            crossAxisCount: 2,
            childAspectRatio: 2 / 1,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.all(7.5),
                child: ProfileCardWallet(),
              ),
              Padding(
                padding: EdgeInsets.all(7.5),
                child: ProfileCardOrder(),
              ),
            ],
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
            (index) => Container(
              width: (Get.width / 2) - 22.5,
              height: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade200,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ProfileCardWallet extends StatelessWidget {
  const ProfileCardWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileCardTemplate(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7.5,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7.5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: Text(
                'Saldo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.only(bottom: 0, right: 10),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 5,
                    ),
                    child: Icon(
                      Iconsax.wallet_2,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  Text(
                    'Rp. 1.200.000',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCardOrder extends StatelessWidget {
  const ProfileCardOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileCardTemplate(
      child: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 2.5,
              ),
              child: Text(
                '21',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pesanan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Selsai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCardTemplate extends StatelessWidget {
  final Widget child;
  final bool? reverse;
  const ProfileCardTemplate({
    super.key,
    required this.child,
    this.reverse,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: primary,
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: reverse == true
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      end: reverse == true
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -5,
                right: -5,
                bottom: -60,
                child: Transform.flip(
                  flipX: reverse != true,
                  child: SvgPicture.asset(
                    'assets/images/path-2.svg',
                    width: Get.width + 5,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor.withOpacity(0.35),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox.expand(child: child),
      ],
    );
  }
}
