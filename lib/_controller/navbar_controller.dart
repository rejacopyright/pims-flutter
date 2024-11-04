import 'package:get/get.dart';

class NavStore extends GetxController {
  RxString activePage = '/'.obs;
  RxBool nav = true.obs;
  setActivePage(e) => activePage.value = e;
  setNav(e) => nav.value = e;
}
