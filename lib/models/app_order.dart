

class Order {
  final String orderId;
  final double totalCost;
  final String paymentMethod;
  final String location;  
  final String userId;
  final String status;
  final String createdAt;  
  final List<Map<String, dynamic>> products;  

  Order({
    required this.orderId,
    required this.totalCost,
    required this.paymentMethod,
    required this.location,  
    required this.userId,
    this.status = "Pending",
    required this.createdAt,
    required this.products,  
  });

 
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'totalCost': totalCost,
      'paymentMethod': paymentMethod,
      'location': location,  
      'userId': userId,
      'status': status,
      'createdAt': createdAt,
      'products': products,  
    };
  }


  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      totalCost: (map['totalCost'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      location: map['location'] ?? '', 
      userId: map['userId'] ?? '',
      status: map['status'] ?? 'Pending',
      createdAt: map['createdAt'] ?? '',
      products: List<Map<String, dynamic>>.from(map['products'] ?? []),
    );
  }
}
