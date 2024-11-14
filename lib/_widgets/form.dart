import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        maxLines: 1,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xffeeeeee).withOpacity(0.9),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          hintText: 'Cari program disini ...',
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.75)),
          prefixIcon: Icon(Iconsax.search_normal_1, size: 15),
          prefixIconColor: Theme.of(context).primaryColor,
          prefixIconConstraints: BoxConstraints(
            minWidth: 50,
          ),
        ),
      ),
    );
  }
}
