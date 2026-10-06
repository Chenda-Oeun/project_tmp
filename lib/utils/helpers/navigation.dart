import 'package:flutter/material.dart';
import 'package:project_tmp/data/models/route_info.dart';
import 'package:project_tmp/utils/services/navigation.dart';

bool isOnPageName(String name) {
  final currentName = NavigationService.lastSettings?.name;
  return currentName == name;
}

bool isOnPageType<T>() {
  return NavigationService.lastRouteArgument?.pageWidget is T;
}

bool isDialogOpen() {
  return NavigationService.lastRouteArgument?.isDialog ?? false;
}

RouteInfo? get currentRoute {
  return NavigationService.lastRouteArgument;
}

Future<dynamic> push(
  Widget nextPage, {
  Object? arguments,
  String? name,
  BuildContext? context,
  PageTransitions transition = PageTransitions.cupertino,
  bool isReplace = false,
}) async {
  if (isReplace) {
    return await NavigationService.pushReplacement(
      nextPage,
      context: context,
      arguments: arguments,
      name: name,
      transition: transition,
    );
  } else {
    return await NavigationService.push(
      nextPage,
      context: context,
      arguments: arguments,
      name: name,
      transition: transition,
    );
  }
}

Future<dynamic> pushReplacement(
  Widget nextPage, {
  Object? arguments,
  String? name,
  PageTransitions transition = PageTransitions.cupertino,
}) async {
  return await NavigationService.pushReplacement(
    nextPage,
    arguments: arguments,
    name: name,
    transition: transition,
  );
}

pop([dynamic data, BuildContext? context]) {
  // if (NavigationService.canPop(context: context)) {
  NavigationService.pop(data, context);
  // }
  // else {
  //   if (appState.isLoggedIn) {
  //     pushReplacement(const MainDashboardPage());
  //   } else {
  //     pushReplacement(const EALoginView());
  //   }
  // }
}

bool get canPop => NavigationService.canPop();
