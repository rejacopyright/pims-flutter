import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';

fetchMe() async {
  try {
    final api = await API().get('/me');
    return api.data;
  } catch (e) {
    return null;
  }
}

class UserController extends GetxController {
  final user = Rxn<Map<String, dynamic>>(null);
  final avatar = Rxn<String>();
  setAvatar(e) => avatar.value = e;

  @override
  void onInit() async {
    // final box = GetStorage();
    try {
      final api = await fetchMe();
      user.value = api;
      avatar.value = api?['avatar'];
    } finally {}
    // final user = box.read('user');
    super.onInit();
  }
}
