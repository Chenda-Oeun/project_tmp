import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:project_tmp/data/models/route_info.dart';

enum PageTransitions { cupertino, fade, slideUp, slideDown, none }

class NavigationService {
  static final routeObserver = RouteObserver<ModalRoute>();
  static final key = GlobalKey<NavigatorState>();

  static get context => key.currentContext;

  static NavigatorState? get state => key.currentState;

  static Route? get currentRoute {
    Route? route;
    state?.popUntil((r) {
      route = r;
      return true;
    });
    return route;
  }

  static RouteSettings? get lastSettings {
    RouteSettings? currentSetting;
    state?.popUntil((route) {
      currentSetting = route.settings;
      return true;
    });
    return currentSetting;
  }

  static int? get currentPageHash => lastRouteArgument?.pageWidget?.hashCode;

  static int? get pageVariantNumber {
    // final pageWidget = lastRouteArgument?.pageWidget;
    // if (pageWidget is MainDashboardPage) {
    //   return pageWidget.selectedIndex.value;
    // }
    return null;
  }

  static RouteInfo? get lastRouteArgument {
    final args = lastSettings?.arguments;
    if (args is RouteInfo) {
      return args;
    }
    // print(
    //     'Navigation to current page was not done by NavigationService class. Is it a popup showing?');
    return null;
  }

  static Future pushReplacementAll(
    Widget nextPage, {
    BuildContext? context,
    Object? arguments,
    String? name,
    PageTransitions transition = PageTransitions.cupertino,
  }) async {
    final route = _makePageRoute(
      nextPage,
      arguments: arguments,
      name: name,
      transition: transition,
    );

    return (context != null ? Navigator.of(context) : state)
        ?.pushAndRemoveUntil(route, (route) {
          return false;
        });
  }

  static Future pushReplacementUntilPageTypes(
    Widget nextPage, {
    required List<Type> types,
    BuildContext? context,
    Object? arguments,
    String? name,
    PageTransitions transition = PageTransitions.cupertino,
  }) async {
    final route = _makePageRoute(
      nextPage,
      arguments: arguments,
      name: name,
      transition: transition,
    );

    return (context != null ? Navigator.of(context) : state)
        ?.pushAndRemoveUntil(route, (route) {
          final thisArgs = route.settings.arguments;
          if (thisArgs is RouteInfo &&
              types.contains(thisArgs.pageWidget.runtimeType)) {
            return true;
          }
          return false;
        });
  }

  static Future<bool> hasDialog({BuildContext? context}) async {
    final completer = Completer<bool>();
    (context != null ? Navigator.of(context) : state)?.popUntil((route) {
      final thisArgs = route.settings.arguments;
      completer.complete(thisArgs is RouteInfo && thisArgs.isDialog);
      return true;
    });
    return await completer.future;
  }

  static clearDialogs({BuildContext? context}) {
    (context != null ? Navigator.of(context) : state)?.popUntil((route) {
      final thisArgs = route.settings.arguments;
      if (thisArgs is RouteInfo && thisArgs.isDialog) {
        return false;
      } else {
        return true;
      }
    });
  }

  static Future popUntilPageTypes({
    required List<Type> types,
    BuildContext? context,
    bool closeAllDialogs = false,
    bool alsoReplaceTargetPage = false,
  }) async {
    var found = false;

    return (context != null ? Navigator.of(context) : state)?.popUntil((route) {
      if (found) {
        return true;
      }

      final thisArgs = route.settings.arguments;
      if (thisArgs is RouteInfo &&
          types.contains(thisArgs.pageWidget.runtimeType)) {
        if ((closeAllDialogs || alsoReplaceTargetPage) && thisArgs.isDialog) {
          return false;
        }
        if (alsoReplaceTargetPage && !thisArgs.isDialog) {
          if (!found) {
            found = true;
          }
        } else {
          return true;
        }
      }

      return false;
    });
  }

  static Future pushReplacementUntilName(
    Widget nextPage, {
    BuildContext? context,
    required String untilName,
    Object? arguments,
    String? name,
    PageTransitions transition = PageTransitions.cupertino,
  }) async {
    final route = _makePageRoute(
      nextPage,
      arguments: arguments,
      name: name,
      transition: transition,
    );

    return (context != null ? Navigator.of(context) : state)
        ?.pushAndRemoveUntil(route, (route) {
          final routeName = route.settings.name;
          return routeName == untilName;
        });
  }

  static Future<T?> pushReplacement<T extends Object?, U>(
    Widget nextPage, {
    Object? arguments,
    U? result,
    String? name,
    BuildContext? context,
    PageTransitions transition = PageTransitions.cupertino,
  }) async {
    final route = _makePageRoute<T>(
      nextPage,
      arguments: arguments,
      name: name,
      transition: transition,
    );

    return await (context != null ? Navigator.of(context) : state)
        ?.pushReplacement<T, U>(route, result: result);
  }

  static Future<T?> push<T extends Object?>(
    Widget nextPage, {
    BuildContext? context,
    Object? arguments,
    String? name,
    PageTransitions transition = PageTransitions.cupertino,
  }) async {
    final route = _makePageRoute<T>(
      nextPage,
      arguments: arguments,
      name: name,
      transition: transition,
    );

    return (context != null ? Navigator.of(context) : state)?.push<T>(route);
  }

  static Route<T> _makePageRoute<T>(
    Widget nextPage, {
    Object? arguments,
    String? name,
    PageTransitions transition = PageTransitions.cupertino,
  }) {
    RouteSettings? routeSettings;
    routeSettings = RouteSettings(
      name: name,
      arguments: RouteInfo(
        pageWidget: nextPage,
        routeName: name,
        arguments: arguments,
      ),
    );

    switch (transition) {
      case PageTransitions.fade:
        return PageRouteBuilder<T>(
          pageBuilder: (context, anim1, anim2) {
            return FadeTransition(opacity: anim1, child: nextPage);
          },
          settings: routeSettings,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
      case PageTransitions.slideUp:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextPage,
          settings: routeSettings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
      case PageTransitions.slideDown:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextPage,
          settings: routeSettings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, -1.0);
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
      case PageTransitions.cupertino:
        return CupertinoPageRoute<T>(
          builder: (context) => nextPage,
          settings: routeSettings,
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => nextPage,
          settings: routeSettings,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
    }
  }

  static void pop<T extends Object?>([T? result, BuildContext? context]) {
    return (context != null ? Navigator.of(context) : state)?.pop(result);
  }

  static bool canPop({BuildContext? context}) {
    return (context != null ? Navigator.of(context) : state)?.canPop() ?? false;
  }
}
