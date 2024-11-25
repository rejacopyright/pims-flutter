// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/storage.dart';

class ConfigController extends GetxController {
  final visit_fee = RxInt(storage.read('visit_fee') ?? 0);
  final app_fee = RxInt(storage.read('app_fee') ?? 0);
  final visit_time_interval = RxInt(storage.read('visit_time_interval') ?? 0);
  @override
  void onInit() async {
    try {
      final api = await API().get('/global/config');
      visit_fee.value = api.data?['visit_fee'];
      app_fee.value = api.data?['app_fee'];
      visit_time_interval.value = api.data?['visit_time_interval'];
      storage.write('visit_fee', api.data?['visit_fee']);
      storage.write('app_fee', api.data?['app_fee']);
      storage.write('visit_time_interval', api.data?['visit_time_interval']);
    } catch (e) {
      //
    }
    super.onInit();
  }
}
