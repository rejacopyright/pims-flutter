import 'package:flutter/material.dart';
import 'package:pims/_widgets/member_explore_detail_cards.dart';
import 'package:pims/pages/member/explore/item.dart';

import 'appbar.dart';
import 'bottom_nav.dart';

class MemberExploreDetailPage extends StatelessWidget {
  const MemberExploreDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: MemberExploreDetailAppBar(),
      bottomNavigationBar: SafeArea(child: MemberExploreDetailBottomNav()),
      body: RefreshIndicator(
        displacement: 30,
        color: primaryColor,
        onRefresh: () async {},
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  MemberExploreItem(),
                  MemberExploreDetailQuota(),
                  MemberExploreDetailDescription(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
