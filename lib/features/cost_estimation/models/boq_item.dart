class BoqItem {
  final String category;
  final String itemName;
  final double quantity;
  final String unit;
  final double rate;
  final double total;

  BoqItem({
    required this.category,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.total,
  });
  
  factory BoqItem.fromJson(Map<String, dynamic> json) {
    return BoqItem(
      category: json['category'] ?? 'General',
      itemName: json['itemName'] ?? 'Unknown',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'Unit',
      rate: (json['rate'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
  
  factory BoqItem.mock(String category, String name, double qty, String unit, double rate) {
    return BoqItem(
      category: category,
      itemName: name,
      quantity: qty,
      unit: unit,
      rate: rate,
      total: qty * rate,
    );
  }
}
