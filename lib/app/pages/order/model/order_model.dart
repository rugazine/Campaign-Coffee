
class OrderModel {
  final int id;
  final double totalPrice;
  final String status;
  final String orderType;
  final String? address;
  final List<OrderItemModel> items;
  final String paymentMethod;
  final String? createdAt;

  OrderModel({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.orderType,
    this.address,
    required this.items,
    required this.paymentMethod,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0,
      status: json['status'] ?? '',
      orderType: json['order_type'] ?? '',
      address: json['address'],
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      paymentMethod: json['payment_method'] ?? '',
      createdAt: json['created_at'],
    );
  }
}

class OrderItemModel {
  final int id;
  final int productId;
  final String? productName;
  final String? productImage;
  final double price;
  final int quantity;
  final String? size;
  final String? sugar;
  final String? temperature;

  OrderItemModel({
    required this.id,
    required this.productId,
    this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.size,
    this.sugar,
    this.temperature,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      quantity: json['quantity'],
      size: json['size'],
      sugar: json['sugar'],
      temperature: json['temperature'],
);}
}
