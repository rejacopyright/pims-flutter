class PaymentData {
  PaymentData({
    required this.id,
    required this.type,
    required this.name,
    this.description,
    this.icon,
    this.fee,
  });
  final String id;
  final String type;
  final String name;
  final String? description;
  final String? icon;
  final num? fee;
}

List<PaymentData> paymentData = [
  PaymentData(
    id: 'bca',
    type: 'bank_transfer',
    name: 'BCA',
    description: 'Virtual account',
    icon: 'assets/icons/bca.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'bni',
    type: 'bank_transfer',
    name: 'BNI',
    description: 'Virtual account',
    icon: 'assets/icons/bni.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'mandiri',
    type: 'bank_transfer',
    name: 'Mandiri',
    description: 'Virtual account',
    icon: 'assets/icons/mandiri.png',
    fee: 7000,
  ),
  PaymentData(
    id: 'gopay',
    type: 'e_wallet',
    name: 'Gopay',
    icon: 'assets/icons/gopay.png',
    fee: 5000,
  ),
  PaymentData(
    id: 'shopee_pay',
    type: 'e_wallet',
    name: 'Shopee Pay',
    icon: 'assets/icons/shopeepay.png',
    fee: 5000,
  ),
  PaymentData(
    id: 'alfamaret',
    type: 'counter',
    name: 'Alfamaret',
    icon: 'assets/icons/alfamaret.png',
    fee: 4000,
  ),
  PaymentData(
    id: 'indomaret',
    type: 'counter',
    name: 'Indomaret',
    icon: 'assets/icons/indomaret.png',
    fee: 4000,
  ),
  PaymentData(
    id: 'qris',
    type: 'other',
    name: 'QRIS',
    icon: 'assets/icons/qris.png',
    fee: 3000,
  ),
  PaymentData(
    id: 'cod',
    type: 'other',
    name: 'COD',
    description: 'Bayar di tempat',
    icon: 'assets/icons/cod.png',
  ),
];
