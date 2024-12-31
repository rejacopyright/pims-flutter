// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/helper.dart';

class MemberAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MemberAppBar({super.key, this.me});
  final Map<String, dynamic>? me;

  @override
  Size get preferredSize => Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final membership = me?['membership'];
    final member = me?['member'];
    bool isMember = false;
    if (membership?['end_date'] != null) {
      final end_date = DateTime.parse(membership['end_date']).toLocal();
      final now = DateTime.now();
      isMember = now.isBefore(end_date);
    }
    double toolbarHeight = 70;
    double expandedHeight = isMember ? 200 : toolbarHeight;
    return SliverLayoutBuilder(builder: (context, sliverConstraints) {
      final bool isCollapsed =
          sliverConstraints.scrollOffset + toolbarHeight > expandedHeight;
      final statusBarColor = isCollapsed ? Colors.white : Colors.transparent;
      final textColor = isCollapsed && isMember ? Colors.black : Colors.white;
      return SliverAppBar(
        backgroundColor: statusBarColor,
        shadowColor: Colors.black.withValues(alpha: 0.25),
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
              isMember
                  ? Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: MemberCard(me: me),
                    )
                  : SizedBox.shrink(),
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
                    child: Image(
                      image: me?['avatar_link'] != null
                          ? NetworkImage(
                              me?['avatar_link'],
                            )
                          : AssetImage('assets/avatar/user.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // direction: Axis.vertical,
                      // alignment: WrapAlignment.center,
                      // runAlignment: WrapAlignment.center,
                      children: [
                        Text(
                          me?['full_name'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          isCollapsed && isMember
                              ? (member?['name'] ?? '')
                              : me?['phone'] ?? '',
                          maxLines: 2,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ElevatedButton.icon(
                      onPressed: () => Get.rootDelegate.offNamed(homeRoute),
                      icon: Icon(
                        Iconsax.home5,
                        color: textColor,
                        size: 18,
                      ),
                      label: Text(
                        'Home',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.black.withValues(alpha: 0.05),
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
  const MemberCard({super.key, this.me});
  final Map<String, dynamic>? me;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final member = me?['member'];
    final membership = me?['membership'];

    DateTime end_at;
    String end_date = '???';
    int day_left = 0;
    int duration = membership?['duration'] ?? 0;
    if (membership != null && membership['end_date'] != null) {
      end_at = DateTime.parse(membership['end_date']).toLocal();
      // end_date = DateFormat('EEEE, d MMMM yyyy').format(end_at);
      end_date = DateFormat('d MMMM yyyy').format(end_at);
      day_left = end_at.difference(DateTime.now()).inDays;
    }

    final daysPercentage =
        ((100 - ((100 / duration) * day_left)) / 100).toFixed(2);

    return Container(
      // width: Get.width / 2,
      height: 150,
      // padding: EdgeInsets.all(15),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.25),
            offset: Offset(-2.5, -2.5),
            blurRadius: 15,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor.withValues(alpha: 0.15),
            primaryColor.withValues(alpha: 0.5),
            primaryColor.withValues(alpha: 0.85),
            primaryColor.withValues(alpha: 1),
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
                  Colors.white.withValues(alpha: 0.1),
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
                        color: member?['badge'] != null
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.amberAccent.shade100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: member?['badge'] != null
                          ? Image(
                              width: 40,
                              image: NetworkImage(member?['badge']),
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Iconsax.crown5,
                                  size: 35,
                                  color: Colors.orange.shade900,
                                );
                              },
                            )
                          : Icon(
                              Iconsax.crown5,
                              size: 35,
                              color: Colors.orange.shade900,
                            ),
                    ),
                    Expanded(
                      child: Text(
                        member?['name'] ?? '???',
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
                      value: daysPercentage,
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
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
                            end_date,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Sisa $day_left hari',
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
                primaryColor.withValues(alpha: 0.5),
                primaryColor.withValues(alpha: 0.75),
                primaryColor.withValues(alpha: 0.85),
                primaryColor.withValues(alpha: 1),
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
