import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  final avatar = Rxn<String>();
  setAvatar(e) => avatar.value = e;

  @override
  void onInit() {
    final box = GetStorage();
    final user = box.read('user');
    avatar.value = user?['avatar'];
    super.onInit();
  }
}
