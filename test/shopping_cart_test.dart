import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/core/cart_logic.dart';

void main() {
  late ShoppingCartLogic cartLogic;

  setUp(() {
    cartLogic = ShoppingCartLogic();
  });

  group('ShoppingCart - Duplicate Items', () {
    test('Adding a new item adds it to the cart', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      expect(cartLogic.items.length, 1);
      expect(cartLogic.items.first.quantity, 1);
    });

    test(
      'Adding duplicate item increases quantity instead of creating new entry',
      () {
        cartLogic.addItem('1', 'iPhone', 1000);
        cartLogic.addItem('1', 'iPhone', 1000);
        expect(cartLogic.items.length, 1);
        expect(cartLogic.items.first.quantity, 2);
      },
    );

    test('Adding multiple different items', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.addItem('2', 'Galaxy', 900);
      expect(cartLogic.items.length, 2);
      expect(cartLogic.totalItems, 2);
    });

    test('Edge Case: Adding multiple duplicates in sequence', () {
      for (int i = 0; i < 5; i++) {
        cartLogic.addItem('1', 'iPhone', 1000);
      }
      expect(cartLogic.items.first.quantity, 5);
    });

    test('Edge Case: Adding new item after duplicates', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.addItem('2', 'Galaxy', 900);
      expect(cartLogic.items.length, 2);
      expect(cartLogic.items.first.quantity, 2);
      expect(cartLogic.items[1].quantity, 1);
    });
  });

  group('ShoppingCart - Discount', () {
    test('Single item discount', () {
      cartLogic.addItem('1', 'iPhone', 1000, discount: 0.1);
      expect(cartLogic.totalDiscount, 100);
    });

    test('Multiple quantity discount', () {
      cartLogic.addItem('1', 'iPhone', 1000, discount: 0.1);
      cartLogic.addItem('1', 'iPhone', 1000, discount: 0.1);
      expect(cartLogic.totalDiscount, 200);
    });

    test('Multiple items discount', () {
      cartLogic.addItem('1', 'iPhone', 1000, discount: 0.1);
      cartLogic.addItem('2', 'Galaxy', 900, discount: 0.15);
      expect(cartLogic.totalDiscount, 100 + 135);
    });

    test('Edge case: 100% discount', () {
      cartLogic.addItem('3', 'iPad', 500, discount: 1.0);
      expect(cartLogic.totalDiscount, 500);
    });
  });

  group('ShoppingCart - Total Amount', () {
    test('Single item without discount', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      final subtotal = 1000;
      final discount = 0;
      final totalAmount = subtotal - discount;
      expect(
        cartLogic.items.first.price * cartLogic.items.first.quantity -
            cartLogic.totalDiscount,
        totalAmount,
      );
    });

    test('Single item with discount', () {
      cartLogic.addItem('1', 'iPhone', 1000, discount: 0.1);
      final subtotal = 1000;
      final discount = 100;
      final totalAmount = subtotal - discount;
      expect(
        cartLogic.items.first.price * cartLogic.items.first.quantity -
            cartLogic.totalDiscount,
        totalAmount,
      );
    });

    test('Multiple items with mixed discounts', () {
      cartLogic.addItem('1', 'iPhone', 1000, discount: 0.1);
      cartLogic.addItem('2', 'Galaxy', 900, discount: 0.15);
      final subtotal = 1000 + 900;
      final discount = 100 + 135;
      final totalAmount = subtotal - discount;
      final calculatedTotal = (1000 + 900) - cartLogic.totalDiscount;
      expect(calculatedTotal, totalAmount);
    });

    test('Edge case: empty cart', () {
      expect(cartLogic.items.isEmpty, true);
      expect(cartLogic.totalDiscount, 0);
    });

    test('Edge case: 100% discount on an item', () {
      cartLogic.addItem('3', 'iPad', 500, discount: 1.0);
      final subtotal = 500;
      final discount = 500;
      final totalAmount = subtotal - discount;
      final calculatedTotal =
          cartLogic.items.first.price * cartLogic.items.first.quantity -
          cartLogic.totalDiscount;
      expect(calculatedTotal, totalAmount);
    });
  });

  group('ShoppingCart - Remove & Update Quantity', () {
    test('Update quantity of existing item', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.updateQuantity('1', 5);
      expect(cartLogic.items.first.quantity, 5);
    });

    test('Update quantity to 1 keeps item in cart', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.updateQuantity('1', 1);
      expect(cartLogic.items.length, 1);
      expect(cartLogic.items.first.quantity, 1);
    });

    test('Update quantity to 0 removes the item from cart', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.updateQuantity('1', 0);
      expect(cartLogic.items.isEmpty, true);
    });

    test('Remove existing item by ID', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.removeItem('1');
      expect(cartLogic.items.isEmpty, true);
    });

    test('Remove non-existing item does nothing', () {
      cartLogic.addItem('1', 'iPhone', 1000);
      cartLogic.removeItem('99');
      expect(cartLogic.items.length, 1);
    });

    test('Edge Case: Update quantity of non-existent item', () {
      cartLogic.updateQuantity('99', 5);
      expect(cartLogic.items.isEmpty, true);
    });
  });
}
