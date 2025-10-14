import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/core/validators.dart';

void main() {
  group('Password Validation', () {
    test('returns true for valid password', () {
      expect(Validators.isValidPassword('Passw0rd!'), true);
      expect(Validators.isValidPassword('Strong@123'), true);
    });

    test('returns false for invalid password', () {
      expect(Validators.isValidPassword('short1!'), false); // too short
      expect(Validators.isValidPassword('NoNumber!'), false); // missing number
      expect(
        Validators.isValidPassword('nonumber123'),
        false,
      ); // missing symbol
      expect(Validators.isValidPassword('12345678!'), false); // missing letter
    });
  });

  group('Password Edge Cases', () {
    test(
      'password with symbols and numbers but less than 8 chars is invalid',
      () {
        expect(Validators.isValidPassword('A1!b'), false);
      },
    );

    test('password with only letters is invalid', () {
      expect(Validators.isValidPassword('Password'), false);
    });

    test('password with letters and numbers but no symbol is invalid', () {
      expect(Validators.isValidPassword('Password1'), false);
    });

    test('password with letters and symbols but no number is invalid', () {
      expect(Validators.isValidPassword('Password!'), false);
    });

    test(
      'password with letters, numbers, and symbols and length >= 8 is valid',
      () {
        expect(Validators.isValidPassword('Strong1!'), true);
        expect(Validators.isValidPassword('Passw0rd@'), true);
      },
    );
  });
}
