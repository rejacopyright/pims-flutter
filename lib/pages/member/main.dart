// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pims/_config/dio.dart';
import 'package:pims/_router/main.dart';
import 'package:pims/_widgets/member_explore_detail_cards.dart';
import 'package:pims/pages/member/explore/item.dart';

import 'appbar.dart';

fetchMe() async {
  try {
    final api = await API().get('/me');
    return api.data;
  } catch (e) {
    return null;
  }
}

class MemberController extends GetxController {
  RxBool pageIsReady = false.obs;
  final me = Rxn<Map<String, dynamic>>(null);

  @override
  void onInit() {
    pageIsReady.value = false;
    Future.delayed(Duration(milliseconds: 200), () async {
      try {
        me.value = await fetchMe();
      } finally {
        pageIsReady.value = true;
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

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(MemberController());
    state.onInit();
    return Scaffold(
      // appBar: MemberAppBar(),
      extendBody: true,
      floatingActionButton: ExploreButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Obx(() {
        final pageIsReady = state.pageIsReady.value;
        final me = state.me.value;
        final membership = me?['membership'];
        bool isUnpaidMember = membership?['status'] == 1;
        bool isMember = false;
        if (membership?['end_date'] != null) {
          final end_date = DateTime.parse(membership['end_date']).toLocal();
          final now = DateTime.now();
          isMember = now.isBefore(end_date);
        }
        return NestedScrollView(
          floatHeaderSlivers: false,
          physics: ClampingScrollPhysics(),
          scrollBehavior: MaterialScrollBehavior().copyWith(
            overscroll: false,
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              isMember
                  ? SliverAppBar(
                      pinned: false,
                      toolbarHeight: 0,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: DecoratedBox(
                            decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.5),
                        )),
                      ),
                    )
                  : SliverPadding(padding: EdgeInsets.zero),
            ];
          },
          body: RefreshIndicator(
            color: primaryColor,
            displacement: Get.height / 8,
            edgeOffset: 135,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              state.refresh();
            },
            child: pageIsReady
                ? CustomScrollView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    slivers: [
                      MemberAppBar(me: me),
                      SliverPadding(padding: EdgeInsets.only(top: 20)),
                      isMember
                          ? SliverMember(me: me)
                          : SliverToBoxAdapter(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 35),
                                        child: Image.asset(
                                          'assets/icons/woman_1.png',
                                          width: Get.width * 0.6,
                                          fit: BoxFit.contain,
                                          opacity: AlwaysStoppedAnimation(0.25),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          'Halo ${me?['full_name']} !!!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: isUnpaidMember
                                            ? UnpaidMember(
                                                membership: membership)
                                            : NotMember(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                      SliverPadding(padding: EdgeInsets.only(bottom: 100))
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: 100,
                        backgroundColor: primaryColor.withOpacity(0.5),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return MemberExploreItemLoader();
                        },
                      )
                    ],
                  ),
          ),
        );
      }),
    );
  }
}

class NotMember extends StatelessWidget {
  const NotMember({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                'Saat ini kamu tidak memiliki langganan yang aktif. Silahkan klik tombol',
          ),
          TextSpan(
            text: ' Jelajahi Paket ',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'untuk memilih paket yang cocok',
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xff777777),
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}

class UnpaidMember extends StatelessWidget {
  const UnpaidMember({super.key, this.membership});
  final Map<String, dynamic>? membership;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    DateTime expired_at;
    String expired_date = '???', expired_time = '???';
    if (membership != null && membership?['purchase_expired'] != null) {
      expired_at = DateTime.parse(membership?['purchase_expired']).toLocal();
      expired_date = DateFormat('EEEE, d MMMM yyyy').format(expired_at);
      expired_time = DateFormat('HH.mm').format(expired_at);
    }
    return Column(
      children: [
        Text(
          'Segera aktivasi member dengan menyelsaikan pembayaran',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Text(
            'Batas akhir pembayaran sampai :',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        Text(
          expired_date,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30,
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Pukul :'),
              Text(
                '$expired_time WIB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          clipBehavior: Clip.antiAlias,
          onPressed: () {
            final redirectParams = {
              'id': membership?['id']?.toString() ?? '',
              'status': 'unpaid',
              'origin': 'confirm',
            };
            Get.rootDelegate.toNamed(
              '$homeRoute/member/detail',
              parameters: redirectParams,
            );
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryColor,
            disabledBackgroundColor: primaryColor.withOpacity(0.25),
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            minimumSize: Size(double.infinity, 48),
            shape: StadiumBorder(),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              'Aktivasi Sekarang',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SliverMember extends StatelessWidget {
  const SliverMember({super.key, this.me});
  final Map<String, dynamic>? me;

  @override
  Widget build(BuildContext context) {
    final member = me?['member'];
    List features = member?['member_features'] ?? [];

    return SliverList.builder(
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Text(
              'Fitur Member',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ...features.map((item) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.only(bottom: 10),
              child: FeatureItem(
                icon: 'assets/icons/check.png',
                text: item?['title'] ?? '???',
                rightText: item?['value'] ?? '???',
                description: item?['sub_title'] ?? '???',
              ),
            );
          }),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.only(bottom: 25),
            child: MemberExploreDetailDescription(
              headerText: 'Syarat & Ketentuan',
              text: member?['tnc'],
            ),
          ),
        ],
      ),
      itemCount: 1,
    );
  }
}

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
    required this.icon,
    required this.text,
    required this.rightText,
    this.description = '',
  });
  final String icon;
  final String text;
  final String rightText;
  final String description;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.5,
          color: Color(0xffdddddd),
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 1,
            offset: Offset(-1, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: description != ''
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Image.asset(icon),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(color: Color(0xff777777)),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    rightText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreButton extends StatelessWidget {
  const ExploreButton({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return SizedBox(
      // width: 65,
      // height: 65,
      child: FittedBox(
        child: FloatingActionButton.extended(
          icon: Icon(
            Iconsax.crown5,
            color: Colors.white,
            size: 25,
          ),
          label: Text(
            'Jelajahi Paket',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          isExtended: true,
          // elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: primaryColor,
          onPressed: () {
            Future.delayed(Duration(milliseconds: 200), () {
              Get.rootDelegate.toNamed(
                '$homeRoute${'/member/explore'}',
              );
            });
          },
        ),
      ),
    );
  }
}
