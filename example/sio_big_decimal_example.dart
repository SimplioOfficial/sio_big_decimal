import 'package:sio_big_decimal/sio_big_decimal.dart';

void main() {
  print(BigDecimal.fromBigInt(BigInt.from(12345))); // 12345
  print(BigDecimal.fromBigInt(BigInt.from(-12345))); // -12345
  print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 1)); // 1234.5
  print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 4)); // 1.2345
  print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 8)); // 0.00012345
  print(BigDecimal.fromBigInt(BigInt.from(0), precision: 8)); // 0.00000000
  print(BigDecimal.fromBigInt(
      BigInt.parse(
          '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'),
      precision: 90)); // very high precision check

  try {
    print(BigDecimal.fromBigInt(BigInt.from(12345), precision: -1));
  } catch (e) {
    print(e);
  }
  print('==================================================');
  print(BigDecimal.parse('12345')); // 12345
  print(BigDecimal.parse('-12345'));
  print(BigDecimal.parse('12345', precision: 2)); // 12345.00
  print(BigDecimal.parse('123.45')); // 123
  print(BigDecimal.parse('123.67')); // 124
  print(BigDecimal.parse('123.45', precision: 4)); // 123.4500
  print(BigDecimal.parse('0', precision: 8)); // 0.00000000
  print(BigDecimal.parse('0.001', precision: 4)); // 0.0010

  try {
    print(BigDecimal.parse('12345', precision: -1));
  } catch (e) {
    print(e);
  }
  print('==================================================');
  print(BigDecimal.fromDouble(12345)); // 12345
  print(BigDecimal.fromDouble(123.45)); // 123.45
  print(BigDecimal.fromDouble(-123.45));
  print(BigDecimal.fromDouble(123.4500)); // 123.45
  print(BigDecimal.fromDouble(0)); // 0
  print(BigDecimal.fromDouble(0, precision: 8)); // 0.00000000
  print(BigDecimal.fromDouble(123.450, precision: 5)); // 123.45000
  print(BigDecimal.fromDouble(123.45678, precision: 2)); // 123.46

  try {
    print(BigDecimal.fromDouble(123.45, precision: -1));
  } catch (e) {
    print(e);
  }
  print('==================================================');
  print(BigDecimal.zero()); // 0
  print(BigDecimal.zero(precision: 8)); // 0.00000000
  print(BigDecimal.zero(precision: -1)); // 0
  print('==================================================');
  final x = BigDecimal.parse('1.222', precision: 3);
  final y = BigDecimal.parse('0.2225', precision: 4);
  final z = BigDecimal.parse('1.888', precision: 4);
  final zero = BigDecimal.zero();
  final addition = x + z; // 3.11 (precision 2)
  final subtract = x - y; // 0.9995 (precision 4)
  final multiplication = x * z; // 2.307136 (precision: 6)
  final division = x / y; // 5.492(precision: 3)

  // 1.222 + 1.8880 = 3.11 (precision: 2)
  print('$x + $z = $addition (precision: ${addition.precision})');

  // 1.222 - 0.2225 = 0.9995 (precision: 4)
  print('$x - $y = $subtract (precision: ${subtract.precision})');

  // 1.222 * 1.8880 = 2.307136 (precision: 6)
  print('$x * $z = $multiplication (precision: ${multiplication.precision})');

  // 1.222 / 0.2225 = 5.492134831460674 (precision: 15)
  print('$x / $y = $division (precision: ${division.precision})');

  try {
    print(x / zero);
  } catch (e) {
    print(e);
  }
  print('==================================================');
  final add = BigDecimal.add(x, z, precision: 8); // 3.11000000 (precision 8)
  final sub =
      BigDecimal.subtract(x, y, precision: 8); // 0.99950000 (precision 8)
  final multiply =
      BigDecimal.multiply(x, z, precision: 8); // 2.30713600 (precision: 8)
  final div = BigDecimal.divide(x, y,
      precision: 19); // 5.4921348314606741573 (precision: 19)

  print(
      'BigDecimal.add($x, $z, precision: 8) = $add (precision: ${add.precision})');

  print(
      'BigDecimal.subtract($x, $y, precision: 8) = $sub (precision: ${sub.precision})');

  print(
      'BigDecimal.multiply($x, $z, precision: 8) = $multiply (precision: ${multiply.precision})');

  print(
      'BigDecimal.divide($x, $y, precision: ${div.precision}) = $div (precision: ${div.precision})');

  try {
    print(BigDecimal.divide(x, zero));
  } catch (e) {
    print(e);
  }
  print('==================================================');
}
