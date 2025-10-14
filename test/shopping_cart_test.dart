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

    test('Edge case: empty cart', () {
      expect(cartLogic.totalDiscount, 0);
    });

    test('Edge case: 100% discount', () {
      cartLogic.addItem('3', 'iPad', 500, discount: 1.0);
      expect(cartLogic.totalDiscount, 500);
    });
  });
}
