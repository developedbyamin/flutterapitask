import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import all page widgets for clarity (optional)
import 'package:apitask/pages/home_page.dart';
import 'package:apitask/pages/login_page.dart';
import 'package:apitask/pages/profile_page.dart';
import 'package:apitask/pages/welcome_page.dart';

enum AppRoute {
  welcome,
  login,
  home,
  profile,
}

class RouteProvider with ChangeNotifier {
  AppRoute _currentRoute = AppRoute.welcome;

  AppRoute get currentRoute => _currentRoute;

  void changeRoute(BuildContext context, String newRoute) {
    // Convert string route to AppRoute enum for type safety
    final appRoute = _stringToAppRoute(newRoute);
    if (appRoute != null) {
      _currentRoute = appRoute;
      notifyListeners();
    } else {
      // Handle invalid route (optional)
      print("Invalid route: $newRoute"); // Log or display an error message
    }
  }

  Map<AppRoute, WidgetBuilder> get _routes => {
    AppRoute.welcome: (context) => const WelcomePage(),
    AppRoute.login: (context) => const LoginPage(),
    AppRoute.home: (context) => const HomePage(),
    AppRoute.profile: (context) => const ProfilePage(),
  };

  Widget _buildPage(BuildContext context, AppRoute route) {
    final builder = _routes[route];
    if (builder != null) {
      return builder(context);
    }
    return const WelcomePage(); // Default route
  }

  // Helper function to convert string route to AppRoute enum
  AppRoute? _stringToAppRoute(String route) {
    switch (route) {
      case '/welcome':
        return AppRoute.welcome;
      case '/login':
        return AppRoute.login;
      case '/home':
        return AppRoute.home;
      case '/profile':
        return AppRoute.profile;
      default:
        return null;
    }
  }
}

class RouterWidget extends StatelessWidget {
  const RouterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RouteProvider>(
      create: (_) => RouteProvider(),
      child: Consumer<RouteProvider>(
        builder: (context, routeProvider, child) => _buildRouter(context, routeProvider),
      ),
    );
  }

  Widget _buildRouter(BuildContext context, RouteProvider routeProvider) {
    return WillPopScope(
      // istifade olunmur indi amma isleyir :D
      onWillPop: () async {
        if (routeProvider.currentRoute != AppRoute.welcome) {
          routeProvider.changeRoute(context, '/welcome'); // Go back to the welcome route
          return false; // Prevent default back button behavior
        } else {
          return true; // Allow default back button behavior for the welcome route
        }
      },
      child: routeProvider._buildPage(context, routeProvider.currentRoute),
    );
  }
}
