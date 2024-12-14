import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/title_show_all.dart';

import 'appbar.dart';
import 'more_member.dart';

class MemberController extends GetxController {
  RxBool pageIsReady = false.obs;

  @override
  void onReady() {
    pageIsReady.value = true;
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onReady();
    });
    super.refresh();
  }
}

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(MemberController());
    return Scaffold(
      // appBar: MemberAppBar(),
      extendBody: true,
      floatingActionButton: ExploreButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: NestedScrollView(
        floatHeaderSlivers: false,
        physics: ClampingScrollPhysics(),
        scrollBehavior: MaterialScrollBehavior().copyWith(
          overscroll: false,
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: DecoratedBox(
                    decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.5),
                )),
              ),
            )
          ];
        },
        body: RefreshIndicator(
          color: primaryColor,
          // displacement: 15,
          onRefresh: () async {
            state.refresh();
          },
          child: CustomScrollView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            slivers: [
              MemberAppBar(),
              SliverPadding(padding: EdgeInsets.only(top: 20)),
              SliverList.builder(
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        'Fitur Member',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: FeatureItem(
                        icon: 'assets/icons/dumbbell.png',
                        text: 'Gym Visit',
                        rightText: 'Unlimited',
                        description:
                            'Booking Gym visit sepuasnya selama member masih aktif',
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: FeatureItem(
                        icon: 'assets/icons/yoga.png',
                        text: 'Kelas Studio',
                        rightText: 'Unlimited Kelas Studio',
                        description:
                            'Booking Kelas Studio sepuasnya sesuka hatimu kapan saja selama member masih aktif',
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: FeatureItem(
                        icon: 'assets/icons/bike.png',
                        text: 'Kelas Fungsional',
                        rightText: 'Unlimited Kelas Studio',
                        description:
                            'Booking Kelas Fungsional sepuasnya se-endasmu kapan saja selama member masih aktif',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: 15,
                        right: 15,
                      ),
                      child: Text(
                        'Syarat & Ketentuan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ...List.generate(10, (i) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                            "${i + 1}. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s , when an unknown printer took a galley of type and scrambled it to make a type"),
                      );
                    }),
                  ],
                ),
                itemCount: 1,
              ),
              SliverPadding(padding: EdgeInsets.only(bottom: 100))
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
    required this.icon,
    required this.text,
    required this.rightText,
    this.description = '',
  });
  final String icon;
  final String text;
  final String rightText;
  final String description;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.5,
          color: Color(0xffdddddd),
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 1,
            offset: Offset(-1, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: description != ''
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            padding: EdgeInsets.all(7.5),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Image.asset(icon),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(color: Color(0xff777777)),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    rightText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreButton extends StatelessWidget {
  const ExploreButton({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      // width: 65,
      // height: 65,
      child: FittedBox(
        child: FloatingActionButton.extended(
          icon: Icon(
            Iconsax.crown5,
            color: Colors.white,
            size: 25,
          ),
          label: Text(
            'Jelajahi Paket',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          isExtended: true,
          // elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: primaryColor,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 200), () {
              Get.rootDelegate.toNamed(
                '$homeRoute${'/member/explore'}',
              );
            });
          },
        ),
      ),
    );
  }
}
