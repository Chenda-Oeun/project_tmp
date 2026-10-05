import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:project_tmp/utils/helper/general.dart';
extension ExtendNum on num {
  Gap get gap => Gap(toDouble());

  EdgeInsets get p => EdgeInsets.all(toDouble());

  EdgeInsets get px => EdgeInsets.symmetric(
        horizontal: toDouble(),
      );

  EdgeInsets get py => EdgeInsets.symmetric(
        vertical: toDouble(),
      );

  EdgeInsets get pt => EdgeInsets.only(
        top: toDouble(),
      );

  EdgeInsets get pr => EdgeInsets.only(
        right: toDouble(),
      );

  EdgeInsets get pl => EdgeInsets.only(
        left: toDouble(),
      );

  EdgeInsets get pb => EdgeInsets.only(
        bottom: toDouble(),
      );

  EdgeInsets get pxb => EdgeInsets.only(
        right: toDouble(),
        left: toDouble(),
        bottom: toDouble(),
      );

  EdgeInsets get pxt => EdgeInsets.only(
        top: toDouble(),
        right: toDouble(),
        left: toDouble(),
      );

  EdgeInsets get pyl => EdgeInsets.only(
        top: toDouble(),
        left: toDouble(),
        bottom: toDouble(),
      );

  EdgeInsets get pyr => EdgeInsets.only(
        top: toDouble(),
        right: toDouble(),
        bottom: toDouble(),
      );




  BorderRadius get borderRadius => BorderRadius.circular(toDouble());

  Radius get radius => Radius.circular(toDouble());

  BorderRadius get borderRadiusTop =>
      BorderRadius.vertical(top: Radius.circular(toDouble()));

  BorderRadius get borderRadiusBottom =>
      BorderRadius.vertical(bottom: Radius.circular(toDouble()));

  BorderRadius get borderRadiusLeft =>
      BorderRadius.horizontal(left: Radius.circular(toDouble()));

  BorderRadius get borderRadiusRight =>
      BorderRadius.horizontal(right: Radius.circular(toDouble()));

  String toFixed([int? digit = 2]) {
    if (digit == null) {
      return toString().replaceFirst(RegExp(r'\.0+$'), '');
    }
    return toStringAsFixed(digit).replaceFirst(RegExp(r'\.0+$'), '');
  }

  // String formatCurrency({String? currencyKey}) {
  //   final value = Decimal.parse(toString()).round(scale: 2).toDouble();
  //
  //   if (!shouldCurrencyHaveDecimal(currencyKey: currencyKey)) {
  //     if (value > 0 && value < 1) {
  //       return '0';
  //     }
  //     // Round to nearest 100 Riel
  //     final roundedValue = (value / 100).round() * 100;
  //     return NumberFormat("#,##0").format(roundedValue);
  //   }
  //
  //   if ((value * 100).round() == 0 && (value * 1000).round() > 0) {
  //     return NumberFormat("#,##0.000").format(value);
  //   }
  //
  //   return NumberFormat("#,##0.00").format(value);
  // }

  String formatCurrency({String? currencyKey}) {
    // Step 1: exact decimal rounding (half up)
    final Decimal value = Decimal.parse(toString()).round(scale: 2);

    // Step 2: handle non-decimal currencies (KHR for example)
    if (!shouldCurrencyHaveDecimal(currencyKey: currencyKey)) {
      if (value > Decimal.zero && value < Decimal.one) {
        return '0';
      }
      // Round to nearest 100 Riel
      final roundedValue = (value.toDouble() / 100).round() * 100;
      return NumberFormat("#,##0").format(roundedValue);
    }

    // Step 3: handle small fractional case
    if ((value * Decimal.fromInt(100)).toBigInt() == BigInt.zero &&
        (value * Decimal.fromInt(1000)).toBigInt() > BigInt.zero) {
      return NumberFormat("#,##0.000").format(value.toDouble());
    }

    // Step 4: default case with 2 decimals
    return NumberFormat("#,##0.00").format(value.toDouble());
  }

  // Absolutely negative
  num nabs() => -1 * abs();

  double adapt() {
    if (Platform.isIOS) {
      return toDouble();
    } else {
      return this * 0.87;
    }
  }
}