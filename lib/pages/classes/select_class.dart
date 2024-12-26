import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/_config/storage.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/nodata.dart';
import 'package:pims/_widgets/program_booking_card.dart';
import 'package:pims/pages/classes/main.dart';

fetchClass(String classType, String date) async {
// final queryParameters = {'page': 1, 'limit': 2};
  try {
    final api = await API()
        .get('/class/open/$classType', queryParameters: {'date': date});
    final result = List.generate(api.data?['data']?.length ?? 0, (i) {
      return api.data?['data']?[i];
    });
    await storage.write('dataClass', result);
    return result;
  } catch (e) {
    return [];
  }
}

class SelectClassController extends GetxController {
  RxBool pageIsReady = false.obs;
  RxList dataClass = [].obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = true;
      final classType = Get.rootDelegate.parameters['type'];
      final thisClass =
          classesList.firstWhereOrNull((item) => item.name == classType);
      final classController = Get.put(ClassAppController());
      final date =
          DateFormat('yyyy-MM-dd').format(classController.selectedDate.value);
      try {
        final res = await fetchClass(thisClass!.name, date);
        dataClass.value = res;
      } catch (e) {
        //
      }
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 100), () {
      onInit();
    });
    super.refresh();
  }
}

class SelectClass extends StatelessWidget {
  const SelectClass({super.key, this.params});
  final Map<String, String>? params;

  @override
  Widget build(BuildContext context) {
    final classController = Get.put(SelectClassController());

    return Obx(() {
      final pageIsReady = classController.pageIsReady.value;
      final dataClass = classController.dataClass;
      final int crossAxisCount = dataClass.isEmpty ? 1 : 2;
      final classType = params?['type'] == 'studio' ? 'Studio' : 'Fungsional';
      return GridView.count(
        clipBehavior: Clip.antiAlias,
        childAspectRatio: pageIsReady ? 0.65 : 1,
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // controller:
        //     ScrollController(keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: pageIsReady
            ? dataClass.isNotEmpty
                ? dataClass.map((item) {
                    String? image, trainerImage;
                    final gallery = item?['class']?['class_gallery'];
                    if (gallery != null && gallery?.length > 0) {
                      image =
                          '$SERVER_URL/static/images/class/${gallery?[0]?['filename']}';
                    }
                    if (item?['trainer']?['avatar'] != null) {
                      trainerImage =
                          '$SERVER_URL/static/images/user/${item?['trainer']?['avatar']}';
                    }
                    final startDate = item?['start_date'] != null
                        ? DateFormat('HH:mm').format(
                            DateTime.parse(item?['start_date']).toLocal())
                        : '';
                    final endDate = item?['end_date'] != null
                        ? DateFormat('HH:mm')
                            .format(DateTime.parse(item?['end_date']).toLocal())
                        : '';
                    final classTime = '$startDate - $endDate';
                    final gender = item?['class']?['gender'] ?? 3;
                    return ProgramBookingCard(
                      to: '$homeRoute/services/class/detail',
                      params: {'id': item?['id']},
                      item: ProgramBookingState(
                        title: item?['class']?['name'] ?? '',
                        category: classType,
                        image: image,
                        price: item?['fee'] ?? 0,
                        time: classTime,
                        gender: gender,
                        trainerImage: trainerImage,
                        trainerName: item?['trainer']?['full_name'] ??
                            item?['trainer']?['username'] ??
                            '???',
                        quota: item?['quota'] ?? 0,
                        booked: item?['transaction']?.length ?? 0,
                      ),
                      crossAxisCount: crossAxisCount,
                    );
                  }).toList()
                : [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: kBottomNavigationBarHeight * 2),
                      child: NoData(text: 'Tidak ada kelas yang ditemukan'),
                    ),
                  ]
            : List.generate(
                4,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                ),
              ),
      );
    });
  }
}
