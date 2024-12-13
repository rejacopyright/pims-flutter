import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/pages/profile/edit/main.dart';

class TakeNIKWidget extends StatelessWidget {
  const TakeNIKWidget({super.key});

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
        final api = await API().post('update/nik', data: {'nik': base64Str});
        if (api.data?['status'] == 'success') {
          final box = GetStorage();
          final profileEditController = Get.put(ProfileEditController());
          await box.write('user', api.data?['data']);
          final nikUrl =
              '$SERVER_URL/static/images/nik/${api.data?['data']?['nik_file']}';
          profileEditController.setNIKUrl(nikUrl);
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
                color: Colors.black.withOpacity(0.15),
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
                      shadowColor: Colors.black.withOpacity(0.75),
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
                      shadowColor: Colors.black.withOpacity(0.75),
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

class UploadNIKButton extends StatelessWidget {
  const UploadNIKButton({super.key, this.text = 'Upload KTP'});
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: Get.height * 0.85,
          ),
          context: context,
          builder: (context) => TakeNIKWidget(),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 200,
        height: 125,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffdddddd),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.camera,
              size: 35,
            ),
            SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.25),
            )
          ],
        ),
      ),
    );
  }
}

class NIKImage extends StatelessWidget {
  NIKImage({super.key});

  final state = Get.put(ProfileEditController());

  deleteImage() async {
    try {
      final api = await API().delete('delete/nik');
      if (api.data?['status'] == 'success') {
        final box = GetStorage();

        await box.write('user', api.data?['data']);
        state.setNIKUrl('');
        state.setNIKFile('');
      }
    } catch (err) {
      return err;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              state.nik_url.value,
              width: 200,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => UploadNIKButton(
                // text: 'Terjadi kesalahan. Mohon ulangi beberapa saat lagi.',
                text: error.toString(),
              ),
            ),
          ),
          Wrap(
            spacing: 10,
            children: [
              MaterialButton(
                highlightColor: Color(0xfffafafa),
                color: Colors.white,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xffdddddd),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                      minHeight: 100,
                      maxHeight: Get.height * 0.85,
                    ),
                    context: context,
                    builder: (context) => TakeNIKWidget(),
                  );
                },
                child: Text('Ubah'),
              ),
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: () {
                  deleteImage();
                },
                child: Text('Hapus'),
              ),
            ],
          )
        ],
      );
    });
  }
}
