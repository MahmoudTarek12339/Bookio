import 'package:bookio/presentation/bookDetails/details_page.dart';
import 'package:bookio/presentation/home/home_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String mainRoute = "/";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) =>   const HomePage());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('No Route Found'),
          ),
          body: const Center(child: Text('No Route Found')),
        ));
  }
}
