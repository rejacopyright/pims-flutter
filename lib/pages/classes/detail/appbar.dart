import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pims/_widgets/button.dart';

class ClassDetailAppBar extends StatelessWidget {
  const ClassDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      elevation: 1,
      forceElevated: true,
      pinned: true,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        title: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 10, right: 15),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  clipBehavior: Clip.antiAlias,
                  child: BackWell(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Iconsax.arrow_left),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Text(
                'Rincian Kelas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
