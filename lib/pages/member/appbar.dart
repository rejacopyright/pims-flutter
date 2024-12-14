import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/button.dart';

class MemberAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MemberAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    double expandedHeight = 200;
    double toolbarHeight = 80;
    return SliverLayoutBuilder(builder: (context, sliverConstraints) {
      final bool isCollapsed =
          sliverConstraints.scrollOffset + toolbarHeight > expandedHeight;
      final statusBarColor = isCollapsed ? Colors.white : Colors.transparent;
      final textColor = isCollapsed ? Colors.black : Colors.white;
      return SliverAppBar(
        backgroundColor: statusBarColor,
        shadowColor: Colors.black.withOpacity(0.25),
        elevation: 1,
        pinned: true,
        expandedHeight: expandedHeight,
        collapsedHeight: toolbarHeight,
        toolbarHeight: toolbarHeight,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(0),
          expandedTitleScale: 1.1,
          centerTitle: false,
          background: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              HeaderBackgroundMember(),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: MemberCard(),
              ),
            ],
          ),
          title: Container(
            // height: 150,
            // color: Colors.red,
            padding: const EdgeInsets.only(bottom: 15),
            child: BackWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 1),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Iconsax.arrow_left_2,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/avatar/3.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Wrap(
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      Text(
                        'Reja Jamil',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        isCollapsed ? 'Paket Gold 3 Bulan' : '085766666393',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ElevatedButton.icon(
                      onPressed: () => Get.rootDelegate.offNamed(homeRoute),
                      icon: Icon(
                        Iconsax.home5,
                        color: isCollapsed ? Colors.black : Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        'Home',
                        style: TextStyle(
                          color: isCollapsed ? Colors.black : Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.black.withOpacity(0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      // width: Get.width / 2,
      height: 150,
      // padding: EdgeInsets.all(15),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.25),
            offset: Offset(-2.5, -2.5),
            blurRadius: 15,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor.withOpacity(0.15),
            primaryColor.withOpacity(0.5),
            primaryColor.withOpacity(0.85),
            primaryColor.withOpacity(1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -5,
            right: -5,
            bottom: -60,
            child: Transform.flip(
              // flipY: true,
              flipX: true,
              child: SvgPicture.asset(
                'assets/images/path-2.svg',
                width: 500,
                // width: Get.width + 5,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.1),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.5),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent.shade100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Iconsax.crown5,
                        size: 35,
                        color: Colors.orange.shade900,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Paket Gold 3 Bulan',
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: 0.3,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      valueColor:
                          AlwaysStoppedAnimation(primaryColor.withGreen(165)),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '18 Mei 1992',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Sisa 30 hari',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellowAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderBackgroundMember extends StatelessWidget {
  const HeaderBackgroundMember({super.key});

  @override
  Widget build(BuildContext context) {
    // final primaryColor = Theme.of(context).primaryColor;
    final primaryColor = Theme.of(context).primaryColor;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.antiAlias,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withOpacity(0.5),
                primaryColor.withOpacity(0.75),
                primaryColor.withOpacity(0.85),
                primaryColor.withOpacity(1),
              ],
            ),
          ),
        ),
        Positioned(
          right: -390,
          top: 20,
          bottom: -200,
          child: Transform.rotate(
            angle: 0.35,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
        Positioned(
          right: -300,
          top: 40,
          bottom: -125,
          child: Transform.rotate(
            angle: 0.45,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
      ],
    );
  }
}
