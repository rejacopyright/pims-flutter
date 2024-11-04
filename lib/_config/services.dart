class ProductService {
  final String label;
  final String name;
  final String? icon;
  final bool? home;
  ProductService(
      {required this.label, required this.name, this.icon, this.home});
}

List<ProductService> servicesList = [
  ProductService(
    label: 'Gym Visit',
    name: '/services/visit',
    icon: 'assets/icons/dumbbell.png',
    home: true,
  ),
  ProductService(
    label: 'Kelas Studio',
    name: '/services/studio',
    icon: 'assets/icons/yoga.png',
    home: true,
  ),
  ProductService(
    label: 'Kelas Fungsional',
    name: '/services/functional',
    icon: 'assets/icons/bike.png',
    home: true,
  ),
];
