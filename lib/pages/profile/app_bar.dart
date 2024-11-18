import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class ProfileAppBar extends StatelessWidget {
  final bool pageIsReady;
  const ProfileAppBar({
    super.key,
    required this.pageIsReady,
  });

  @override
  Widget build(BuildContext context) {
    double headerHeight = 200;
    return SliverAppBar(
      // backgroundColor: pageIsReady ? Colors.transparent : Colors.white,
      pinned: false,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: headerHeight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(0.0),
        background: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: pageIsReady
              ? Stack(
                  fit: StackFit.expand,
                  // clipBehavior: Clip.none,
                  children: [
                    ...List.generate(
                      3,
                      (index) => Positioned(
                        left: -5,
                        right: -5,
                        bottom: index == 2 ? 0 : 10,
                        child: SvgPicture.asset(
                          'assets/images/path-${index + 1}.svg',
                          width: Get.width + 5,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).primaryColor.withOpacity(0.65),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 35,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        // alignment: Alignment.centerLeft,
                        alignment: Alignment.topLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Image.asset(
                                'assets/avatar/5.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reja Jamil',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Wrap(
                                  spacing: 5,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'reja.copyright@gmail.com',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '3',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Member',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: VerticalDivider(
                                        width: 35,
                                        thickness: 1,
                                        indent: 10,
                                        endIndent: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '24',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Jadwal',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            side: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        child: Wrap(
                                          spacing: 7.5,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(
                                              Iconsax.setting,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Edit Profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () {
                                          final box = GetStorage();
                                          box.remove('token');
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Colors.redAccent.shade200,
                                        ),
                                        child: Wrap(
                                          spacing: 7.5,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Keluar',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                height: 0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ProfilePageLoader(),
        ),
      ),
    );
  }
}

class ProfilePageLoader extends StatelessWidget {
  const ProfilePageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey.shade200,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width / 4,
                  height: 15,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade200,
                  ),
                ),
                Container(
                  width: Get.width / 2.5,
                  height: 15,
                  margin: EdgeInsets.only(bottom: 75),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade200,
                  ),
                ),
                Container(
                  width: 125,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade200,
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
