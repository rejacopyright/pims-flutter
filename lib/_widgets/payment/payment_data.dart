class PaymentData {
  PaymentData({
    required this.id,
    required this.type,
    required this.name,
    required this.label,
    this.description,
    this.icon,
    this.fee,
  });
  final String id;
  final String type;
  final String name;
  final String label;
  final String? description;
  final String? icon;
  final num? fee;
}

List<PaymentData> paymentData = [
  PaymentData(
    id: 'bca',
    type: 'bank_transfer',
    name: 'bca',
    label: 'BCA',
    description: 'Virtual account',
    icon: 'assets/icons/bca.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'bni',
    type: 'bank_transfer',
    name: 'bni',
    label: 'BNI',
    description: 'Virtual account',
    icon: 'assets/icons/bni.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'mandiri',
    type: 'bank_transfer',
    name: 'mandiri',
    label: 'Mandiri',
    description: 'Virtual account',
    icon: 'assets/icons/mandiri.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'gopay',
    type: 'e_wallet',
    name: 'gopay',
    label: 'Gopay',
    icon: 'assets/icons/gopay.png',
    fee: 5000,
  ),
  PaymentData(
    id: 'shopee_pay',
    type: 'e_wallet',
    name: 'shopee_pay',
    label: 'Shopee Pay',
    icon: 'assets/icons/shopeepay.png',
    fee: 5000,
  ),
  PaymentData(
    id: 'alfamaret',
    type: 'counter',
    name: 'alfamaret',
    label: 'Alfamaret',
    icon: 'assets/icons/alfamaret.png',
    fee: 4000,
  ),
  PaymentData(
    id: 'indomaret',
    type: 'counter',
    name: 'indomaret',
    label: 'Indomaret',
    icon: 'assets/icons/indomaret.png',
    fee: 4000,
  ),
  PaymentData(
    id: 'qris',
    type: 'other',
    name: 'qris',
    label: 'QRIS',
    icon: 'assets/icons/qris.png',
    fee: 3000,
  ),
  PaymentData(
    id: 'cod',
    type: 'other',
    name: 'cod',
    label: 'COD',
    description: 'Bayar di tempat',
    icon: 'assets/icons/cod.png',
  ),
];
