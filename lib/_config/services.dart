class ProductService {
  final String label;
  final String name;
  final String? icon;
  final String type;
  final bool? home;
  ProductService({
    required this.label,
    required this.name,
    this.icon,
    this.home,
    this.type = '',
  });
}

class ClassItem {
  final String name;
  final String label;
  final int type;
  ClassItem({required this.name, required this.label, this.type = 2});
}

List<ProductService> servicesList = [
  ProductService(
    label: 'Gym Visit',
    name: '/services/visit',
    icon: 'assets/icons/bike.png',
    home: true,
  ),
  ProductService(
    label: 'Kelas Studio',
    name: '/services/class/studio',
    icon: 'assets/icons/yoga.png',
    home: true,
    type: 'studio',
  ),
  ProductService(
    label: 'Kelas Fungsional',
    name: '/services/class/functional',
    icon: 'assets/icons/dumbbell.png',
    home: true,
    type: 'functional',
  ),
];

List<ClassItem> classesList = [
  ClassItem(
    type: 2,
    name: 'studio',
    label: 'Studio',
  ),
  ClassItem(
    type: 3,
    name: 'functional',
    label: 'Fungsional',
  ),
];
