// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pims/_widgets/helper.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.value = '',
    this.onChange,
    this.hintText = 'Cari program disini ...',
  });
  final String value;
  final String hintText;
  final ValueChanged<dynamic>? onChange;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool isLoading = false;
  setLoading(e) => setState(() => isLoading = e);
  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 1000);
    return SizedBox(
      height: 40,
      child: TextFormField(
        initialValue: widget.value,
        maxLines: 1,
        style: TextStyle(fontSize: 14),
        onTapOutside: (e) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: (val) {
          if (val != '') {
            setLoading(true);
            _debouncer.run(() {
              setLoading(false);
              widget.onChange!(val);
            });
          } else {
            setLoading(false);
            widget.onChange!('');
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffeeeeee).withOpacity(0.9),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 16,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.only(left: 5),
            width: 40,
            child: Icon(
              Iconsax.search_normal,
              size: 18,
            ),
          ),
          prefixIconColor: Theme.of(context).primaryColor,
          prefixIconConstraints: BoxConstraints(minWidth: 0),
          suffix: isLoading
              ? SizedBox(
                  width: 35,
                  height: 15,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 1,
                        right: 20,
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
