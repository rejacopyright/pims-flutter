// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_config/services.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/pages/classes/detail/appbar.dart';
import 'package:pims/pages/classes/detail/description.dart';
import 'package:pims/pages/classes/detail/image_slider.dart';
import 'package:pims/pages/classes/detail/price.dart';

ScrollController classDetailScrollController = ScrollController();
GlobalKey classDetailTabKey = GlobalKey();

fetchDetailClass(String? id) async {
  try {
    final api = await API().get('/class/$id/detail');
    final result = api.data;
    return result;
  } catch (e) {
    return null;
  }
}

class ProductDetailController extends GetxController {
  RxBool pageIsReady = false.obs;
  RxBool dataIsReady = false.obs;
  final detailClass = Rxn<Map<String, dynamic>>(null);

  @override
  void onInit() {
    pageIsReady.value = true;
    Future.delayed(Duration(milliseconds: 300), () async {
      final id = Get.rootDelegate.parameters['product_id'];
      try {
        final res = await fetchDetailClass(id);
        detailClass.value = res;
      } finally {
        dataIsReady.value = true;
      }
    });
    super.onInit();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () {
      onInit();
    });
    super.refresh();
  }
}

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageController = Get.put(ClassDetailImageSliderController());
    final priceController = Get.put(ClassDetailPriceController());
    final descriptionController = Get.put(ClassDetailDescriptionController());
    final thisController = Get.put(ProductDetailController());

    return Obx(() {
      final detail = thisController.detailClass.value;
      final gallery = detail?['class_gallery'];
      final dataIsReady = thisController.dataIsReady.value;
      dynamic images;
      if (gallery != null && gallery?.length > 0) {
        images = gallery;
      }
      final gender = detail?['gender'] ?? 3;
      final trainer = detail?['trainer'];
      final thisClass = classesList.firstWhereOrNull(
          (item) => item.type == (detail?['service_id'] ?? 2));
      final replacedImageFromDescription =
          (detail?['description'] ?? '')?.replaceAllMapped(
        RegExp(r'(<img[^>]+)(height=)', caseSensitive: false),
        (match) => '${match.group(1)}_${match.group(1)}',
      );
      List open_class = detail?['open_class'] ?? [];

      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [ClassDetailAppBar()];
          },
          body: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            displacement: 30,
            onRefresh: () async {
              thisController.onInit();
              imageController.refresh();
              priceController.refresh();
              descriptionController.refresh();
            },
            child: CustomScrollView(
              controller: classDetailScrollController,
              physics: AlwaysScrollableScrollPhysics(),
              scrollBehavior: MaterialScrollBehavior().copyWith(
                overscroll: false,
              ),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Column(
                      children: [
                        ClassDetailImageSlider(
                          images: images,
                          dataIsReady: dataIsReady,
                        ),
                        trainer != null
                            ? TrainerCard(trainer: trainer)
                            : SizedBox.shrink(),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: ClassBadges(
                            thisClass: thisClass,
                            gender: gender,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            detail?['name'] ?? '???',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.centerLeft,
                          // margin: EdgeInsets.only(bottom: 20),
                          child: HtmlWidget(replacedImageFromDescription),
                        ),
                      ],
                    );
                  }, childCount: 1),
                ),
                open_class.isNotEmpty
                    ? SliverPadding(
                        padding: const EdgeInsets.only(top: 20),
                        sliver: SliverAppBar(
                          pinned: true,
                          backgroundColor: Color(0xfffafafa),
                          surfaceTintColor: Colors.white,
                          toolbarHeight: 0,
                          shadowColor: Colors.black.withValues(alpha: 0.25),
                          elevation: 2,
                          automaticallyImplyLeading: false,
                          centerTitle: false,
                          titleSpacing: 15,
                          flexibleSpace: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Wrap(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Iconsax.calendar5,
                                      size: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    Text(
                                      'Jadwal Kelas',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(padding: EdgeInsets.zero),
                SliverList.list(
                  children: [AvailableOpenClass(open_class: open_class)],
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 50)),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AvailableOpenClass extends StatelessWidget {
  const AvailableOpenClass({
    super.key,
    required this.open_class,
  });

  final List open_class;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ListView.separated(
      separatorBuilder: (context, index) =>
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      padding: EdgeInsets.symmetric(vertical: 15),
      shrinkWrap: true,
      itemCount: open_class.length,
      itemBuilder: (context, index) {
        final item = open_class[index];
        String start_date = '???', start_time = '???';
        if (item?['start_date'] != null) {
          final start_date_format =
              DateTime.parse(item?['start_date']).toLocal();
          start_date =
              DateFormat('EEEE, dd MMMM yyyy').format(start_date_format);
          start_time = '${DateFormat('HH:mm').format(start_date_format)} WIB';
        }
        final trainer = item?['trainer'];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
            onPressed: () {
              Get.rootDelegate.toNamed('$homeRoute/services/class/detail',
                  parameters: {'id': item?['id']});
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              elevation: 2,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              overlayColor: Color(0xffaaaaaa),
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, 48),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shadowColor: Colors.black.withValues(alpha: 0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  width: 1,
                  color: Color(0xffeeeeee),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(2.5),
                  margin: EdgeInsets.only(top: 2.5),
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        start_date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffaaaaaa),
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        start_time,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.only(right: 7.5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 25,
                              height: 25,
                              child: Ink.image(
                                image: trainer?['avatar_link'] != null
                                    ? NetworkImage(trainer['avatar_link'])
                                    : AssetImage('assets/avatar/user.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trainer?['full_name'] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${trainer?['username'] ?? ''}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xff777777),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ClassBadges extends StatelessWidget {
  const ClassBadges({
    super.key,
    required this.thisClass,
    this.gender = 3,
  });

  final ClassItem? thisClass;
  final int gender;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final gendersIcon = {1: 'male', 2: 'female', 3: 'gender'};
    final gendersLabel = {1: 'Pria', 2: 'Wanita', 3: 'Campuran'};
    final genderIcon = gendersIcon[gender];
    final genderLabel = gendersLabel[gender];
    return Wrap(
      spacing: 10,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 7.5,
            vertical: 5,
          ),
          // margin: EdgeInsets.only(top: 15, bottom: 20),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: Text(
            thisClass != null ? 'Kelas ${thisClass?.label}' : '',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 7.5,
            vertical: 5,
          ),
          // margin: EdgeInsets.only(top: 15, bottom: 20),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: [
              Image.asset(
                'assets/icons/$genderIcon.png',
                height: 18,
                fit: BoxFit.contain,
              ),
              Text(
                genderLabel ?? 'Campuran',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrainerCard extends StatelessWidget {
  const TrainerCard({
    super.key,
    required this.trainer,
  });

  final dynamic trainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(right: 7.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              width: 50,
              height: 50,
              child: Ink.image(
                image: trainer?['avatar_link'] != null
                    ? NetworkImage(trainer['avatar_link'])
                    : AssetImage('assets/avatar/user.png'),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer?['full_name'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${trainer?['username'] ?? ''} | ${trainer?['email'] ?? ''}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xff777777),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
