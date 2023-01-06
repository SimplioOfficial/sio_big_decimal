import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class BigDecimal extends Equatable {
  static const defaultPrecision = 0;

  /// Create a new [BigDecimal] from a [value] of type [BigInt] given a
  /// [precision].
  ///
  /// [defaultPrecision] is 0.
  ///
  /// Only positive [value]s are supported.
  ///
  /// [precision] must be positive.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.fromBigInt(BigInt.from(12345))); // 12345
  /// print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 1)); // 1234.5
  /// print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 4)); // 1.2345
  /// print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 8)); // 0.00012345
  /// print(BigDecimal.fromBigInt(BigInt.from(0), precision: 8)); // 0.00000000
  /// ```
  factory BigDecimal.fromBigInt(
    BigInt value, {
    int precision = defaultPrecision,
  }) {
    final sign = value.isNegative ? '-' : '';
    if (precision < 0) throw FormatException('Precision must be positive');
    final v = Decimal.fromBigInt(value.abs());
    final p = Decimal.fromBigInt(BigInt.from(10).pow(precision));
    final r = (v / p).toDecimal().toString().split('.');

    return BigDecimal._(
      sign,
      r.isNotEmpty ? r.first.split('').map(int.parse).toList() : const [],
      r.length > 1 ? r.last.split('').map(int.parse).toList() : null,
      precision,
    );
  }

  /// Parses [value] as a BigDecimal literal and returns it's value as
  /// [BigDecimal] given a [precision].
  ///
  /// [defaultPrecision] is 0.
  ///
  /// Only positive [value]s are supported.
  ///
  /// [precision] must be positive.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.parse('12345')); // 12345
  /// print(BigDecimal.parse('12345', precision: 2)); // 12345.00
  /// print(BigDecimal.parse('123.45')); // 123
  /// print(BigDecimal.parse('123.67')); // 124
  /// print(BigDecimal.parse('123.45', precision: 4)); // 123.4500
  /// print(BigDecimal.parse('0', precision: 8)); // 0.00000000
  /// print(BigDecimal.parse('0.00000001', precision: 9)); // 0.000000010
  /// ```
  static BigDecimal parse(
    String value, {
    int precision = defaultPrecision,
  }) {
    if (precision < 0) throw FormatException('Precision must be positive');
    return BigDecimal.fromBigInt(
      BigInt.parse(
        Decimal.parse(value).toStringAsFixed(precision).replaceAll('.', ''),
      ),
      precision: precision,
    );
  }

  /// Create a new [BigDecimal] from a [value] of type [double] given a
  /// [precision].
  ///
  /// [defaultPrecision] is the number of decimals of the [value].
  ///
  /// Only positive [value]s are supported.
  ///
  /// [precision] must be positive.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.fromDouble(12345)); // 12345
  /// print(BigDecimal.fromDouble(123.45)); // 123.45
  /// print(BigDecimal.fromDouble(123.4500)); // 123.45
  /// print(BigDecimal.fromDouble(0)); // 0
  /// print(BigDecimal.fromDouble(0, precision: 8)); // 0.00000000
  /// print(BigDecimal.fromDouble(123.45, precision: 5)); // 123.45000
  /// ```
  factory BigDecimal.fromDouble(
    double value, {
    int? precision,
  }) {
    final inheritedPrecision = (Decimal.parse(value.toString()) -
                Decimal.parse(value.truncate().toString()))
            .precision -
        1;
    return parse(
      value.toString(),
      precision: precision ?? inheritedPrecision,
    );
  }

  /// The [BigDecimal] corresponding to `0`.
  ///
  /// [defaultPrecision] is 0.
  ///
  /// Negative [precision] will default to `0`.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.zero()); // 0
  /// print(BigDecimal.zero(precision: 8)); // 0.00000000
  /// print(BigDecimal.zero(precision: -1)); // 0
  /// ```
  const BigDecimal.zero({
    int precision = defaultPrecision,
  }) : this._(null, const [], null, precision);

  const BigDecimal._(
    this._sign,
    this._abs,
    this._dec,
    this.precision,
  );

  final String? _sign;

  /// must be a valid `int` value. it is list of integers
  final List<int> _abs;

  /// must be a valid `int` value
  final List<int>? _dec;

  /// represents decimal place
  final int precision;

  bool get isZero =>
      (_abs.isEmpty || (_abs[0] == 0 && _abs.length == 1)) && _dec == null;
  bool get isNotZero => !isZero;
  bool get isDecimal => _dec != null;
  bool get isNotDecimal => !isDecimal;
  bool get isFinite =>
      _dec == null || (_dec != null && _dec!.length <= precision);

  /// Addition operator.
  ///
  /// Precision of the result will be minimum needed precision
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('1.888', precision: 4);
  /// final addition = x + z; // 3.11 (precision: 2)
  /// ```
  BigDecimal operator +(BigDecimal other) {
    final inheritedPrecision = (Decimal.parse(
                    (toDecimal() + other.toDecimal()).toString()) -
                Decimal.parse(
                    (toDecimal() + other.toDecimal()).truncate().toString()))
            .precision -
        1;
    return BigDecimal.parse(
      (toDecimal() + other.toDecimal()).toString(),
      precision: inheritedPrecision,
    );
  }

  /// Subtraction operator.
  ///
  /// Precision of the result will be minimum needed precision
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('0.2225', precision: 4);
  /// final subtract = x - y; // 0.9995 (precision 4)
  /// ```
  BigDecimal operator -(BigDecimal other) {
    final inheritedPrecision = (Decimal.parse(
                    (toDecimal() - other.toDecimal()).toString()) -
                Decimal.parse(
                    (toDecimal() - other.toDecimal()).truncate().toString()))
            .precision -
        1;
    return BigDecimal.parse(
      (toDecimal() - other.toDecimal()).toString(),
      precision: inheritedPrecision,
    );
  }

  /// Multiplication operator.
  ///
  /// Precision of the result will be minimum needed precision
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('1.888', precision: 4);
  /// final multiplication = x * z; // 2.307136 (precision: 6)
  /// ```
  BigDecimal operator *(BigDecimal other) {
    final inheritedPrecision = (Decimal.parse(
                    (toDecimal() * other.toDecimal()).toString()) -
                Decimal.parse(
                    (toDecimal() * other.toDecimal()).truncate().toString()))
            .precision -
        1;
    return BigDecimal.parse(
      (toDecimal() * other.toDecimal()).toString(),
      precision: inheritedPrecision,
    );
  }

  /// Division operator.
  ///
  /// Precision of the result will be the precision of the dividend.
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('0.2225', precision: 4);
  /// final division = x / y; // 5.492134831460674 (precision 15)
  /// ```
  BigDecimal operator /(BigDecimal other) {
    if (other.toDecimal() == Decimal.zero) {
      throw FormatException('Divisor can\'t be zero');
    }
    return divide(this, other, precision: precision);
  }

  /// Addition function that uses a specified precision.
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('1.888', precision: 4);
  /// final addition = BigDecimal.add(x, y, precision: 8); // 3.11000000 (precision 8)
  /// ```
  static BigDecimal add(
    BigDecimal value,
    BigDecimal other, {
    int precision = defaultPrecision,
  }) {
    return BigDecimal.parse(
      (value.toDecimal() + other.toDecimal()).toString(),
      precision: precision,
    );
  }

  /// Subtraction function that uses a specified precision.
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('0.2225', precision: 4);
  /// final addition = BigDecimal.subtract(x, y, precision: 8); // 0.99950000 (precision 8)
  /// ```
  static BigDecimal subtract(
    BigDecimal value,
    BigDecimal other, {
    int precision = defaultPrecision,
  }) {
    return BigDecimal.parse(
      (value.toDecimal() - other.toDecimal()).toString(),
      precision: precision,
    );
  }

  /// Multiplication function that uses a specified precision.
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('1.888', precision: 4);
  /// final addition = BigDecimal.multiply(x, y, precision: 8); // 2.30713600 (precision 8)
  /// ```
  static BigDecimal multiply(
    BigDecimal value,
    BigDecimal other, {
    int precision = defaultPrecision,
  }) {
    return BigDecimal.parse(
      (value.toDecimal() * other.toDecimal()).toString(),
      precision: precision,
    );
  }

  /// Division function that uses a specified precision.
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('0.2225', precision: 4);
  /// final addition = BigDecimal.subtract(x, y, precision: 8); // 5.49213483 (precision 8)
  /// ```
  static BigDecimal divide(
    BigDecimal value,
    BigDecimal other, {
    int precision = defaultPrecision,
  }) {
    if (other.toDecimal() == Decimal.zero) {
      throw FormatException('Divisor can\'t be zero');
    }

    if (precision + other.precision > value.precision) {
      final newPrecision = precision + other.precision;
      final raise = newPrecision - value.precision;
      final scaledValue = value.toBigInt() * BigInt.from(10).pow(raise);
      return _divide(scaledValue, other.toBigInt(), precision: precision);
    } else {
      final newPrecision = value.precision - precision;
      final raise = newPrecision - other.precision;
      final scaledOther = other.toBigInt() * BigInt.from(10).pow(raise);
      return _divide(value.toBigInt(), scaledOther, precision: precision);
    }
  }

  static BigDecimal _divide(
    BigInt value,
    BigInt other, {
    int precision = defaultPrecision,
  }) {
    final quotient = value ~/ other;
    final remainder = value.remainder(other).abs();
    if (remainder != BigInt.zero) {
      if (_needIncrement(remainder, other, quotient)) {
        return BigDecimal.fromBigInt(
            quotient + (value.sign == other.sign ? BigInt.one : -BigInt.one),
            precision: precision);
      }
      return BigDecimal.fromBigInt(quotient, precision: precision);
    } else {
      return BigDecimal.fromBigInt(quotient, precision: precision);
    }
  }

  static bool _needIncrement(
    BigInt remainder,
    BigInt divisor,
    BigInt quotient,
  ) {
    final remainderComparisonToHalfDivisor =
        (remainder * BigInt.from(2)).compareTo(divisor);
    if (remainderComparisonToHalfDivisor < 0) {
      return false;
    } else if (remainderComparisonToHalfDivisor > 0) {
      return true;
    } else {
      return quotient.isOdd;
    }
  }

  BigDecimal clear() => BigDecimal.zero(precision: precision);

  BigDecimal removeValue() {
    if (_abs.isEmpty) return _copyWith();
    if (!isDecimal) return _copyWith(abs: List.from(_abs)..removeLast());
    if (_dec!.isEmpty) return BigDecimal._(_sign, _abs, null, precision);

    return _copyWith(dec: List.from(_dec!)..removeLast());
  }

  BigDecimal addValue(int? n) {
    if (n == null) return _addPrecision();
    if (isDecimal) return _addDec(n);
    return _addAbs(n);
  }

  BigDecimal _addPrecision() {
    if (isDecimal) return _copyWith();
    return _copyWith(
      abs: _abs.isEmpty ? [0] : _abs,
      dec: const [],
    );
  }

  BigDecimal _addAbs(int n) {
    final updated = [..._abs, n];
    if (int.tryParse(updated.join('')) == null) return _copyWith();
    if (_abs.isEmpty && n < 1) return _copyWith();
    return _copyWith(abs: [..._abs, n]);
  }

  BigDecimal _addDec(int n) {
    if (isNotDecimal) return _copyWith(dec: [n]);
    if (_dec!.length < precision) return _copyWith(dec: [..._dec!, n]);
    return _copyWith();
  }

  BigInt toBigInt() {
    return BigInt.tryParse(toString().replaceAll('.', '')) ?? BigInt.zero;
  }

  Decimal toDecimal() {
    return Decimal.parse(toString());
  }

  /// Returns this [BigDecimal] as a [double].
  ///
  /// If the number is not representable as a [double],
  /// an approximation is returned.
  double toDouble() {
    return double.parse(toString());
  }

  @override
  String toString() {
    final sign = _sign;
    final abs = _abs.isNotEmpty ? _abs.join('') : '0';
    final dec = _dec?.join('') ?? '0';
    final noSignStr = [abs, dec].join('.').replaceAll(RegExp(r'[.]*$'), '');
    final str = [sign, noSignStr].join();

    return (Decimal.tryParse(str) ?? Decimal.zero)
        .toStringAsFixed(max(precision, defaultPrecision));
  }

  String format({String locale = 'en_US'}) {
    if (_abs.isEmpty) return '';

    final f = NumberFormat('###,###', locale);
    final a = f.format(
      DecimalIntl(Decimal.tryParse(_abs.join('')) ?? Decimal.zero),
    );

    if (isNotDecimal) return a;
    return [a, _dec?.join('')].join('.');
  }

  BigDecimal _copyWith({
    String? sign,
    List<int>? abs,
    List<int>? dec,
  }) {
    return BigDecimal._(
      sign ?? _sign,
      abs ?? _abs,
      dec ?? _dec,
      precision,
    );
  }

  @override
  List<Object?> get props => [_abs, _dec];
}
