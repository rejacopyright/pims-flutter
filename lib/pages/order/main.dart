import 'package:flutter/material.dart';
import 'package:pims/_widgets/navbar.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(child: NavbarWidget(name: '/order')),
      body: Center(
        child: Text('Order List'),
      ),
    );
  }
}
