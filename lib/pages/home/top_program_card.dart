import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';

class TopProgramCardController extends GetxController {
  RxBool pageIsReady = true.obs;
  RxList data = [].obs;

  @override
  void onReady() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = false;
      try {
        final api = await API().get('class/top');
        data.value = api.data?['data'] ?? [];
      } catch (e) {
        //
      } finally {
        pageIsReady.value = true;
      }
    });
    super.onReady();
  }

  @override
  void refresh() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 400), () {
      onReady();
    });
    super.refresh();
  }
}

class TopProgramCard extends StatelessWidget {
  const TopProgramCard({super.key});

  @override
  Widget build(BuildContext context) {
    final topProgramController = Get.put(TopProgramCardController());
    return Obx(() {
      final pageIsReady = topProgramController.pageIsReady.value;
      final data = topProgramController.data.toList();
      if (pageIsReady) {
        return Container(
          constraints: BoxConstraints(maxHeight: 175),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            children: data
                .map(
                  (detail) => Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black.withValues(alpha: 0.5),
                      elevation: 3.5,
                      child: InkWell(
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 200), () {
                            Get.rootDelegate.toNamed(
                              '/product/detail',
                              parameters: {'product_id': detail?['id'] ?? ''},
                            );
                          });
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: Image(
                                    image: detail?['image'] != null
                                        ? NetworkImage(detail?['image'])
                                        : AssetImage(
                                            'assets/images/no-image.png'),
                                    fit: BoxFit.cover,
                                    opacity: AlwaysStoppedAnimation(
                                        detail?['image'] != null ? 1 : 1),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  margin: EdgeInsets.only(top: 7.5),
                                  child: Text(
                                    detail?['name'] ?? '???',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 7.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Kelas ${detail?['service_name'] ?? '???'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffaaaaaa),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: List.generate(
            3,
            (index) => Container(
              width: (MediaQuery.of(context).size.width / 3) - 17.5,
              height: 125,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(7.5),
              ),
            ),
          ),
        ),
      );
    });
  }
}
