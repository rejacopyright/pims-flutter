import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/pages/visit/select_days.dart';

class VisitHeader extends StatelessWidget {
  const VisitHeader({super.key, required this.pageIsReady});
  final bool pageIsReady;

  @override
  Widget build(BuildContext context) {
    double expandedHeight = 225;
    double toolbarHeight = 150;
    return SliverLayoutBuilder(
        builder: (BuildContext context, sliverConstraints) {
      final bool isCollapsed =
          sliverConstraints.scrollOffset + toolbarHeight > expandedHeight;
      final Color statusBarColor =
          isCollapsed ? Colors.white : Colors.transparent;
      return SliverAppBar(
        backgroundColor: statusBarColor,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        elevation: 1,
        forceElevated: true,
        pinned: true,
        snap: false,
        floating: false,
        stretch: false,
        stretchTriggerOffset: 20,
        expandedHeight: expandedHeight,
        collapsedHeight: toolbarHeight,
        toolbarHeight: toolbarHeight,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.symmetric(vertical: 5),
          centerTitle: false,
          expandedTitleScale: 1.35,
          background: HeaderBackgroundVisit(),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeaderTitle(isCollapsed: isCollapsed),
              SelectDays(isCollapsed: isCollapsed)
            ],
          ),
        ),
      );
    });
  }
}

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
    required this.isCollapsed,
  });

  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(
                  color: Colors.black.withValues(alpha: 0),
                  width: 1,
                ),
              ),
              color: Colors.white.withValues(alpha: 0.15),
              clipBehavior: Clip.antiAlias,
              child: BackWell(
                child: Container(
                  margin: EdgeInsets.only(bottom: 1),
                  width: 30,
                  height: 30,
                  child: Icon(
                    Iconsax.arrow_left_2,
                    color: isCollapsed ? Colors.black : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          BackWell(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'Gym Visit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCollapsed
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HeaderBackgroundVisit extends StatelessWidget {
  const HeaderBackgroundVisit({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.antiAlias,
      children: [
        DecoratedBox(
          // decoration: BoxDecoration(
          //   color: Theme.of(context).primaryColor,
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // primaryColor.withValues(alpha: 0),
                primaryColor.withValues(alpha: 0.5),
                primaryColor.withValues(alpha: 0.75),
                primaryColor.withValues(alpha: 0.85),
                primaryColor.withValues(alpha: 1),
              ],
            ),
          ),
        ),
        Positioned(
          right: -375,
          top: -10,
          bottom: -200,
          child: Transform.rotate(
            angle: 0.35,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
        Positioned(
          right: -320,
          top: 0,
          bottom: -125,
          child: Transform.rotate(
            angle: 0.45,
            child: Image.asset(
              'assets/images/shape-2.png',
              fit: BoxFit.fitHeight,
              color: Colors.black,
              opacity: AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
      ],
    );
  }
}
