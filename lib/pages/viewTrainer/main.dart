import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/_widgets/form.dart';
import 'package:pims/_widgets/navbar.dart';
import 'package:pims/_widgets/user_card.dart';

class ViewTrainerController extends GetxController {
  final ScrollController _viewTrainerController = ScrollController();
  RxBool pageIsReady = false.obs;
  RxList data = [].obs;
  final params = RxMap<String, dynamic>({'page': 1});

  setPageIsReady(e) => pageIsReady.value = e;
  setData(e) => data.value = e;
  setParams(e) => params.value = e;

  fetchTrainer(Map<String, dynamic>? queryParameters) async {
    final params = {'limit': 8, ...(queryParameters ?? {})};
    try {
      final api = await API().get('/users/trainer', queryParameters: params);
      final result = api.data?['data'] ?? [];
      return result;
    } catch (e) {
      return [];
    } finally {
      pageIsReady.value = true;
    }
  }

  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 100), () async {
      pageIsReady.value = false;
      final api = await fetchTrainer({'page': 1});
      setData(api ?? []);
      _viewTrainerController.addListener(() async {
        double maxScroll = _viewTrainerController.position.maxScrollExtent;
        double offset = _viewTrainerController.offset;
        if (maxScroll == offset) {
          final queryParams = {...(params), 'page': params['page'] + 1};
          final api2 = await fetchTrainer(queryParams);
          setParams(queryParams);
          setData([...data, ...(api2 ?? [])]);
        }
      });
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

  @override
  void onClose() {
    _viewTrainerController.dispose();
    super.onClose();
  }
}

class ViewTrainerApp extends StatelessWidget {
  const ViewTrainerApp({super.key});
  final int crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    final store = Get.put(ViewTrainerController());
    double searchPadding = 15;
    double expandedHeight = 100;
    double toolbarHeight = kToolbarHeight + searchPadding;

    return Scaffold(
      bottomNavigationBar: NavbarWidget(name: '/view/trainer'),
      extendBody: true,
      floatingActionButton: QRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() {
        final pageIsReady = store.pageIsReady.value;
        final data = store.data.toList();
        if (pageIsReady) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            displacement: 100,
            onRefresh: () async {
              store.pageIsReady.value = false;
              return Future.delayed(Duration(milliseconds: 300), () {
                store.pageIsReady.value = true;
              });
            },
            child: CustomScrollView(
              controller: store._viewTrainerController,
              // physics: BouncingScrollPhysics(),
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverLayoutBuilder(
                  builder: (context, sliverConstraints) {
                    final bool isCollapsed =
                        sliverConstraints.scrollOffset + toolbarHeight >
                            expandedHeight;
                    final Color statusBarColor =
                        isCollapsed ? Colors.white : Colors.transparent;
                    return SliverAppBar(
                      backgroundColor: statusBarColor,
                      // backgroundColor: Colors.white,
                      pinned: true,
                      floating: false,
                      stretch: true,
                      stretchTriggerOffset: 100,
                      onStretchTrigger: () async {},
                      shadowColor: Colors.black.withValues(alpha: 0.25),
                      automaticallyImplyLeading: false,
                      surfaceTintColor: Colors.transparent,
                      expandedHeight: expandedHeight,
                      toolbarHeight: toolbarHeight,
                      flexibleSpace: FlexibleSpaceBar(
                        expandedTitleScale: 1.1,
                        centerTitle: true,
                        titlePadding: EdgeInsets.all(0.0),
                        title: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin:
                              EdgeInsetsDirectional.only(bottom: searchPadding),
                          child: SearchField(
                            hintText: 'Cari Trainer ...',
                            value: store.params['q'] ?? '',
                            onChange: (e) async {
                              final queryParams = {'page': 1, 'q': e};
                              final api = await store.fetchTrainer(queryParams);
                              store.setParams(queryParams);
                              store.setData(api ?? []);
                            },
                          ),
                        ),
                        // background: HeaderBackgroundOrder(),
                        background: Image.asset(
                          'assets/images/header-6.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 0, vertical: searchPadding),
                      child: GridView.count(
                        clipBehavior: Clip.antiAlias,
                        childAspectRatio: 1.1,
                        crossAxisCount: crossAxisCount,
                        padding: EdgeInsets.only(
                          top: 0,
                          bottom: 15,
                          left: 15,
                          right: 15,
                        ),
                        // physics: NeverScrollableScrollPhysics(),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        // controller:
                        //     ScrollController(keepScrollOffset: false),
                        scrollDirection: Axis.vertical,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: data.map((item) {
                          return Container(
                            width: (MediaQuery.of(context).size.width / 3) - 15,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              clipBehavior: Clip.antiAlias,
                              shadowColor: Colors.black.withValues(alpha: 0.5),
                              elevation: 3.5,
                              child: StackedUserCard(detail: item),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }, childCount: 1),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 125))
              ],
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 125,
              margin: EdgeInsets.only(bottom: 20),
              color: Colors.black.withValues(alpha: 0.05),
            ),
            GridView.count(
              clipBehavior: Clip.antiAlias,
              childAspectRatio: 1,
              crossAxisCount: crossAxisCount,
              padding: EdgeInsets.only(top: 0, bottom: 15, left: 15, right: 15),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // controller:
              //     ScrollController(keepScrollOffset: false),
              scrollDirection: Axis.vertical,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                4,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
