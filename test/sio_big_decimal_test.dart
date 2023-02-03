import 'package:sio_big_decimal/sio_big_decimal.dart';
import 'package:test/test.dart';

void main() {
  group('BigDecimal parser tests -', () {
    test('fromBigInt', () {
      expect(BigDecimal.fromBigInt(BigInt.from(12345)).toString(), '12345');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 1).toString(),
          '1234.5');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 4).toString(),
          '1.2345');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 5).toString(),
          '0.12345');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 8).toString(),
          '0.00012345');
      expect(BigDecimal.fromBigInt(BigInt.from(0), precision: 8).toString(),
          '0.00000000');
      expect(
          BigDecimal.fromBigInt(
                  BigInt.parse(
                      '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'),
                  precision: 90)
              .toString(),
          '1234567890.123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
    });

    test('parse', () {
      expect(BigDecimal.parse('12345').toString(), '12345');
      expect(BigDecimal.parse('12345', precision: 2).toString(), '12345.00');
      expect(BigDecimal.parse('123.49').toString(), '123');
      expect(BigDecimal.parse('123.50').toString(), '124');
      expect(BigDecimal.parse('123.45', precision: 4).toString(), '123.4500');
      expect(BigDecimal.parse('0', precision: 8).toString(), '0.00000000');
      expect(BigDecimal.parse('0.001', precision: 4).toString(), '0.0010');
      expect(
          BigDecimal.parse(
                  '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890',
                  precision: 90)
              .toString(),
          '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000');
    });

    test('fromDouble', () {
      expect(BigDecimal.fromDouble(12345).toString(), '12345');
      expect(BigDecimal.fromDouble(123.45).toString(), '123.45');
      expect(BigDecimal.fromDouble(123.4500).toString(), '123.45');
      expect(BigDecimal.fromDouble(0).toString(), '0');
      expect(BigDecimal.fromDouble(0, precision: 8).toString(), '0.00000000');
      expect(
          BigDecimal.fromDouble(123.450, precision: 5).toString(), '123.45000');
      expect(
          BigDecimal.fromDouble(123.45678, precision: 2).toString(), '123.46');
    });
  });

  test('zero', () {
    expect(BigDecimal.zero().toString(), '0');
    expect(BigDecimal.zero(precision: 8).toString(), '0.00000000');
    expect(BigDecimal.zero(precision: -1).toString(), '0');
  });

  group('BigDecimal operators tests -', () {
    test('smaller than (<)', () {
      expect(BigDecimal.one < BigDecimal.two, true);
      expect(BigDecimal.zero() < BigDecimal.zero(precision: 10), false);
      expect(BigDecimal.parse('30.00') < BigDecimal.parse('30'), false);
      expect(BigDecimal.parse('10') < BigDecimal.parse('-10'), false);
      expect(BigDecimal.zero() < BigDecimal.parse('-0'), false);
    });
    test('smaller than or equal (<=)', () {
      expect(BigDecimal.one <= BigDecimal.two, true);
      expect(BigDecimal.zero() <= BigDecimal.zero(precision: 10), true);
      expect(BigDecimal.parse('30.00') <= BigDecimal.parse('30'), true);
      expect(BigDecimal.parse('10') <= BigDecimal.parse('-10'), false);
      expect(BigDecimal.zero() <= BigDecimal.parse('-0'), true);
    });
    test('greater than (>)', () {
      expect(BigDecimal.one > BigDecimal.two, false);
      expect(BigDecimal.zero() > BigDecimal.zero(precision: 10), false);
      expect(BigDecimal.parse('30.00') > BigDecimal.parse('30'), false);
      expect(BigDecimal.parse('10') > BigDecimal.parse('-10'), true);
      expect(BigDecimal.zero() > BigDecimal.parse('-0'), false);
    });
    test('smaller than or equal (>=)', () {
      expect(BigDecimal.one >= BigDecimal.two, false);
      expect(BigDecimal.zero() >= BigDecimal.zero(precision: 10), true);
      expect(BigDecimal.parse('30.00') >= BigDecimal.parse('30'), true);
      expect(BigDecimal.parse('10') >= BigDecimal.parse('-10'), true);
      expect(BigDecimal.zero() >= BigDecimal.parse('-0'), true);
    });

    test('negation -()', () {
      expect((-BigDecimal.one), BigDecimal.parse('-1'));
      expect(-BigDecimal.parse('-1'), BigDecimal.one);
      expect(-BigDecimal.zero(), BigDecimal.zero());
    });

    test('addition (+)', () {
      expect(
        (BigDecimal.parse('1.222', precision: 3) +
                BigDecimal.parse('1.888', precision: 4))
            .toString(),
        '3.11',
      );
      expect(
        (BigDecimal.parse('1.6', precision: 1) +
                BigDecimal.parse('1.005', precision: 3))
            .toString(),
        '2.605',
      );
      expect(
        (BigDecimal.parse('0.0001', precision: 4) +
                BigDecimal.parse('9.9999', precision: 4))
            .toString(),
        '10',
      );
    });

    test('subtraction (-)', () {
      expect(
        (BigDecimal.parse('1.222', precision: 3) -
                BigDecimal.parse('1.888', precision: 4))
            .toString(),
        '-0.666',
      );
      expect(
        (BigDecimal.parse('1.6', precision: 1) -
                BigDecimal.parse('1.005', precision: 3))
            .toString(),
        '0.595',
      );
      expect(
        (BigDecimal.parse('9.9999', precision: 4) -
                BigDecimal.parse('0.9899', precision: 4))
            .toString(),
        '9.01',
      );
    });

    test('multiplication (*)', () {
      expect(
        (BigDecimal.parse('1.222', precision: 3) *
                BigDecimal.parse('1.888', precision: 4))
            .toString(),
        '2.307136',
      );
      expect(
        (BigDecimal.parse('1.6', precision: 1) *
                BigDecimal.parse('1.005', precision: 3))
            .toString(),
        '1.608',
      );
      expect(
        (BigDecimal.parse('9.9999', precision: 4) *
                BigDecimal.parse('0.9899', precision: 4))
            .toString(),
        '9.89890101',
      );
    });

    test('division (/)', () {
      expect(
        (BigDecimal.parse('-1.222', precision: 3) /
                BigDecimal.parse('0.2225', precision: 4))
            .toString(),
        '-5.492',
      );
      expect(
        (BigDecimal.parse('1.6', precision: 1) /
                BigDecimal.parse('1.005', precision: 3))
            .toString(),
        '1.6',
      );
      expect(
        (BigDecimal.parse('9.9999', precision: 4) /
                BigDecimal.parse('0.9899', precision: 4))
            .toString(),
        '10.1019',
      );
    });
  });

  group('BigDecimal operator functions tests -', () {
    test('add', () {
      expect(
        BigDecimal.add(BigDecimal.parse('1.222', precision: 3),
                BigDecimal.parse('1.888', precision: 4),
                precision: 8)
            .toString(),
        '3.11000000',
      );
      expect(
        BigDecimal.add(BigDecimal.parse('1.6', precision: 1),
                BigDecimal.parse('1.005', precision: 3),
                precision: 2)
            .toString(),
        '2.61',
      );
      expect(
        BigDecimal.add(BigDecimal.parse('0.0001', precision: 4),
                BigDecimal.parse('9.9999', precision: 4),
                precision: 2)
            .toString(),
        '10.00',
      );
    });

    test('subtract', () {
      expect(
        BigDecimal.subtract(BigDecimal.parse('1.222', precision: 3),
                BigDecimal.parse('1.888', precision: 4),
                precision: 8)
            .toString(),
        '-0.66600000',
      );
      expect(
        BigDecimal.subtract(BigDecimal.parse('1.6', precision: 1),
                BigDecimal.parse('1.005', precision: 3),
                precision: 2)
            .toString(),
        '0.60',
      );
      expect(
        BigDecimal.subtract(BigDecimal.parse('9.9999', precision: 4),
                BigDecimal.parse('0.9899', precision: 4),
                precision: 2)
            .toString(),
        '9.01',
      );
    });

    test('multiply', () {
      expect(
        BigDecimal.multiply(BigDecimal.parse('1.222', precision: 3),
                BigDecimal.parse('1.888', precision: 4),
                precision: 8)
            .toString(),
        '2.30713600',
      );
      expect(
        BigDecimal.multiply(BigDecimal.parse('1.6', precision: 1),
                BigDecimal.parse('1.005', precision: 3),
                precision: 2)
            .toString(),
        '1.61',
      );
      expect(
        BigDecimal.multiply(BigDecimal.parse('9.9999', precision: 4),
                BigDecimal.parse('0.9899', precision: 4),
                precision: 2)
            .toString(),
        '9.90',
      );
    });

    test('divide', () {
      expect(
        BigDecimal.divide(BigDecimal.parse('-1.222', precision: 3),
                BigDecimal.parse('0.2225', precision: 4),
                precision: 8)
            .toString(),
        '-5.49213483',
      );
      expect(
        BigDecimal.divide(BigDecimal.parse('1.6', precision: 1),
                BigDecimal.parse('1.005', precision: 3),
                precision: 2)
            .toString(),
        '1.59',
      );
      expect(
        BigDecimal.divide(BigDecimal.parse('9.9999', precision: 4),
                BigDecimal.parse('0.9899', precision: 4),
                precision: 19)
            .toString(),
        '10.1019294878270532377',
      );
    });
    test('abs', () {
      expect(BigDecimal.one.abs(), BigDecimal.one);
      expect((-BigDecimal.one).abs(), BigDecimal.one);
      expect(BigDecimal.parse('-1').abs(), BigDecimal.one);
    });
  });

  group('BigDecimal getters tests -', () {
    test('one', () {
      expect(BigDecimal.one.toBigInt(), BigInt.one);
      expect(BigDecimal.one.toString(), '1');
    });
    test('two', () {
      expect(BigDecimal.two.toBigInt(), BigInt.two);
      expect(BigDecimal.two.toString(), '2');
    });
  });

  test('compareTo', () {
    expect(BigDecimal.one.compareTo(BigDecimal.two), -1);
    expect(BigDecimal.two.compareTo(BigDecimal.one), 1);
    expect(BigDecimal.one.compareTo(BigDecimal.one), 0);
    expect(BigDecimal.parse('1', precision: 2).compareTo(BigDecimal.one), 0);
  });
}
