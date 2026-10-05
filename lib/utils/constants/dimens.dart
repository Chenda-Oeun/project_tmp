import 'package:flutter/cupertino.dart';
import 'package:project_tmp/utils/extensions/num.dart';

class AppDimens {
  const AppDimens._();

  static const screenPaddingX = EdgeInsets.symmetric(horizontal: marginX);
  static const screenPaddingY = EdgeInsets.symmetric(vertical: marginX);
  static const screenPadding = EdgeInsets.all(marginX);

  static const marginX = 16.0;

  static final cardBorderRadius = cardRadius.borderRadius;
  static const cardRadius = 8.0;
  static final boxBorderRadius = boxRadius.borderRadius;
  static const boxRadius = 16.0;

  static const padding = 16.0;
  static const borderRadius = 16.0;
  static const bodyRadius = 16.0;

  static const containerWidth = 600.0;
}
