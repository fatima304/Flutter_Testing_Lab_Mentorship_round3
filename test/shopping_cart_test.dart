import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/core/cart_logic.dart';

void main() {
  group('ShoppingCartLogic - Duplicate Items', () {
    late ShoppingCartLogic cartLogic;

    setUp(() {
      cartLogic = ShoppingCartLogic();
    });

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
}
