import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';
import 'package:pims/pages/classes/select_days.dart';

class StudioClassHeader extends StatelessWidget {
  const StudioClassHeader({super.key, required this.pageIsReady});
  final bool pageIsReady;

  @override
  Widget build(BuildContext context) {
    const double expandedHeight = 225;
    const double toolbarHeight = 150;
    return SliverLayoutBuilder(
        builder: (BuildContext context, sliverConstraints) {
      final bool isCollapsed =
          sliverConstraints.scrollOffset + toolbarHeight > expandedHeight;
      final Color statusBarColor =
          isCollapsed ? Colors.white : Colors.transparent;
      return SliverAppBar(
        backgroundColor: statusBarColor,
        shadowColor: Colors.black.withOpacity(0.25),
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
          background: HeaderBackgroundStudio(),
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
      margin: const EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(
                  color: Colors.black.withOpacity(0),
                  width: 1,
                ),
              ),
              color: Colors.white.withOpacity(0.15),
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
                'Kelas Studio',
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

class HeaderBackgroundStudio extends StatelessWidget {
  const HeaderBackgroundStudio({super.key});

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
                // primaryColor.withOpacity(0),
                primaryColor.withOpacity(0.5),
                primaryColor.withOpacity(0.75),
                primaryColor.withOpacity(0.85),
                primaryColor.withOpacity(1),
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
              opacity: const AlwaysStoppedAnimation(0.05),
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
              opacity: const AlwaysStoppedAnimation(0.05),
            ),
          ),
        ),
      ],
    );
  }
}
