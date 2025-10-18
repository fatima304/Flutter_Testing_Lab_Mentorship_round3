import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/core/validators.dart';

void main() {
  group('Email Validation', () {
    test('returns true for valid email', () {
      expect(Validators.isValidEmail('fatma@example.com'), true);
      expect(Validators.isValidEmail('fatma.name@domain.co'), true);
      expect(Validators.isValidEmail('fatma+atef@gmail.com'), true);
    });

    test('returns false for invalid email', () {
      expect(Validators.isValidEmail('a@'), false);
      expect(Validators.isValidEmail('@b'), false);
      expect(Validators.isValidEmail('fatmaatef'), false);
      expect(Validators.isValidEmail('user@.com'), false);
    });
  });

  group('Email Validation Edge Cases', () {
    test('multiple @ symbols', () {
      expect(Validators.isValidEmail('test@@example.com'), false);
    });

    test('contains spaces', () {
      expect(Validators.isValidEmail('fatma @example.com'), false);
    });

    test('missing dot in domain', () {
      expect(Validators.isValidEmail('fatma@example'), false);
    });

    test('ends with dot', () {
      expect(Validators.isValidEmail('fatma@example.'), false);
    });

    test('contains invalid characters', () {
      expect(Validators.isValidEmail('fat!ma@example.com'), false);
    });

    test('valid subdomain email', () {
      expect(Validators.isValidEmail('name@sub.domain.com'), true);
    });
  });
}
