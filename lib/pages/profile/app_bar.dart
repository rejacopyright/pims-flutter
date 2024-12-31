import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_controller/user_controller.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    super.key,
    required this.pageIsReady,
    this.order,
  });
  final bool pageIsReady;
  final Map<String, dynamic>? order;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    double headerHeight = 200;
    final thisState = Get.put(UserController());
    return SliverAppBar(
      // backgroundColor: pageIsReady ? Colors.transparent : Colors.white,
      pinned: false,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: headerHeight,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(0.0),
        background: Obx(() {
          final userAvatar = thisState.avatar.value;
          final user = thisState.user.value;
          final avatar = userAvatar != null
              ? '$SERVER_URL/static/images/user/$userAvatar'
              : null;
          return Container(
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
                              Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.65),
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
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.05),
                              Colors.white.withValues(alpha: 0),
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
                              GestureDetector(
                                onTap: () async {
                                  showModalBottomSheet(
                                    useSafeArea: true,
                                    isScrollControlled: true,
                                    constraints: BoxConstraints(
                                      minHeight: 100,
                                      maxHeight: Get.height * 0.85,
                                    ),
                                    context: context,
                                    builder: (context) => TakePictureWidget(),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Image(
                                    image: avatar != null
                                        ? NetworkImage(avatar)
                                        : AssetImage('assets/avatar/user.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?['full_name'] ?? '???',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.mail,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        user?['email'] ?? '???',
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
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            (order?['unpaid_count'] ?? 0)
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Belum bayar',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            (order?['active_count'] ?? 0)
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Jadwal Aktif',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                          onPressed: () {
                                            Get.rootDelegate
                                                .toNamed('/profile/edit');
                                          },
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
          );
        }),
      ),
    );
  }
}

class TakePictureWidget extends StatelessWidget {
  const TakePictureWidget({super.key});

  uploadImage(e) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: e == 'camera' ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 600,
        maxHeight: 600,
      );
      final uint8Image = await image?.readAsBytes();
      if (uint8Image != null) {
        final imageByte = uint8Image.toList();
        // final sizeInKB = (uint8Image.lengthInBytes / 1024);
        final arrStrImage = image?.path.split('.') ?? [];
        final ext = (arrStrImage[arrStrImage.length - 1]).toString();
        final base64prefix =
            'data:image/${ext == 'png' ? 'png' : 'jpeg'};base64,';
        final base64Data = base64Encode(imageByte);
        final base64Str = '$base64prefix$base64Data';
        final api =
            await API().post('update/avatar', data: {'avatar': base64Str});
        if (api.data?['status'] == 'success') {
          final box = GetStorage();
          final profileStore = Get.put(UserController());
          await box.write('user', api.data?['data']);
          profileStore.setAvatar(api.data?['data']?['avatar']);
          Get.rootDelegate.popRoute();
        }
      }
    } catch (err) {
      return err;
    }
    return e;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 7.5,
              width: 75,
              margin: EdgeInsets.symmetric(
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black.withValues(alpha: 0.75),
                      elevation: 1,
                      child: InkWell(
                        onTap: () => uploadImage('camera'),
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Icon(
                                  Iconsax.camera5,
                                  size: 45,
                                  color: primaryColor,
                                ),
                              ),
                              Text('kamera'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black.withValues(alpha: 0.75),
                      elevation: 1,
                      child: InkWell(
                        onTap: () {
                          uploadImage('gallery');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Icon(
                                  Iconsax.gallery5,
                                  size: 45,
                                  color: primaryColor,
                                ),
                              ),
                              Text('Galeri'),
                            ],
                          ),
                        ),
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
