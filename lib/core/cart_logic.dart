class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; // Discount percentage (0.0 to 1.0)

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  });
}

class ShoppingCartLogic {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(
        CartItem(id: id, name: name, price: price, discount: discount),
      );
    }
  }

  double get totalDiscount {
    double discount = 0;
    for (var item in _items) {
      discount += item.price * item.discount * item.quantity;
    }
    return discount;
  }

  void removeItem(String id) {
  _items.removeWhere((item) => item.id == id);
}

void updateQuantity(String id, int quantity) {
  final index = _items.indexWhere((item) => item.id == id);
  if (index != -1) {
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
  }
}

}
