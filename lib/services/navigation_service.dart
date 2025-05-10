import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigationService? _instance;

  factory NavigationService() => _instance ??= NavigationService._();

  NavigationService._();

  Future<dynamic> navigateTo(Widget page) {
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => page));
  }

  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
  void safePop({BuildContext? context}) {
  if (context != null) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  } else {
    if (navigatorKey.currentState?.canPop() == true) {
      navigatorKey.currentState?.pop();
    }
  }
}

  void goBack() {
    if (canPop()) {
      navigatorKey.currentState?.pop();
    }
  }
}