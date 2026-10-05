import 'package:flutter/material.dart';

class RouteInfo {
  final Widget? pageWidget;
  final bool isDialog;
  final String? routeName;
  final Object? arguments;
  final Map<String, dynamic> extra = {};

  bool get isPage => !isDialog;

  RouteInfo({
    required this.pageWidget,
    this.isDialog = false,
    this.routeName,
    this.arguments,
  });
}
