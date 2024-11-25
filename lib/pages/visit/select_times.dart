// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/storage.dart';
import 'package:pims/pages/visit/main.dart';

// class MyVisits {
//   String? start_date;
//   MyVisits({
//     this.start_date,
//   });
//   factory MyVisits.fromJson(Map<String, dynamic> item) => MyVisits(
//         start_date: item['start_date'],
//       );
// }

class SelectTimesController extends GetxController {
  RxBool pageIsReady = false.obs;
  RxList mybookedTimes = [].obs;

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 200), () async {
      try {
        final visitController = Get.put(VisitAppController());
        final selectedDate =
            DateFormat('yyyy-MM-dd').format(visitController.selectedDate.value);

        final api = await API()
            .get('/my-visit', queryParameters: {'date': selectedDate});

        // final result = (api.data as List).map((item) {
        //   return MyVisits.fromJson(item);
        // }).toList();
        final result = List.generate(
            api.data?.length ?? 0, (i) => api.data?[i]?['start_date']);

        mybookedTimes.value = result;
        storage.write(selectedDate, result);
        super.onInit();
      } catch (e) {
        //
      }
    });
  }

  @override
  void onReady() {
    pageIsReady.value = true;
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 100), () {
      onInit();
      onReady();
    });
    super.refresh();
  }
}

class SelectTimes extends StatelessWidget {
  const SelectTimes({super.key});

  @override
  Widget build(BuildContext context) {
    final visitController = Get.put(VisitAppController());
    final selectTimesController = Get.put(SelectTimesController());
    final primaryColor = Theme.of(context).primaryColor;

    return Obx(() {
      final selectedDay = visitController.selectedDate.value;
      final pageIsReady = selectTimesController.pageIsReady.value;
      final openHours = selectedDay.copyWith(hour: 6, minute: 0);
      final times = List.generate(32, (i) {
        return openHours.add(Duration(minutes: 30 * i));
      });
      final selectedValue = visitController.selectedTime.value;
      final selectedTime = selectedValue != null
          ? DateTime(selectedValue.year, selectedValue.month, selectedValue.day,
              selectedValue.hour, selectedValue.minute)
          : null;
      final mybookedTimes = storage.read(
          DateFormat('yyyy-MM-dd').format(visitController.selectedDate.value));
      final now = DateTime.now();
      return GridView.count(
        clipBehavior: Clip.antiAlias,
        childAspectRatio: 10 / 5,
        crossAxisCount: 4,
        padding: EdgeInsets.only(top: 0, bottom: 15, left: 0, right: 0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // controller:
        //     ScrollController(keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: times.map((item) {
          final thisTime =
              DateTime(item.year, item.month, item.day, item.hour, item.minute);
          final isSelected = selectedTime == thisTime;
          final isPastTime = now.isAfter(thisTime);
          final timeWithoutSeconds =
              DateFormat('yyyy-MM-dd HH:mm').format(item);
          bool isBooked = mybookedTimes.contains(timeWithoutSeconds);
          return Material(
            color: isPastTime
                ? Color(0xfff5f5f5)
                : isBooked
                    ? primaryColor.withOpacity(0.1)
                    : isSelected
                        ? primaryColor
                        : Colors.white,
            clipBehavior: Clip.antiAlias,
            shadowColor: Colors.black.withOpacity(0.25),
            elevation: isPastTime || !pageIsReady || isBooked ? 0 : 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isBooked && !isPastTime
                    ? primaryColor
                    : Colors.black.withOpacity(0.1),
                width: isPastTime ? 0.5 : 0.75,
              ),
            ),
            child: pageIsReady
                ? InkWell(
                    splashFactory: InkSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (!isPastTime && !isBooked) {
                        visitController
                            .setSelectedTime(isSelected ? null : item);
                      }
                    },
                    child: Center(
                      child: Text(
                        DateFormat('HH:mm').format(item),
                        style: TextStyle(
                          color: isPastTime
                              ? Colors.black.withOpacity(0.25)
                              : isBooked
                                  ? primaryColor
                                  : isSelected
                                      ? Colors.white
                                      : Colors.black.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Container(color: Color(0xfffafafa)),
          );
        }).toList(),
      );
    });
  }
}
