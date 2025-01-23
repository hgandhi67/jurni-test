import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jurni_test/data/constants.dart';
import 'package:jurni_test/data/models/user_data_model.dart';
import 'package:jurni_test/presentation/onboarding/on_boarding_page.dart';
import 'package:jurni_test/presentation/profile/profile_page.dart';

import 'presentation/signup/sign_up_page.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigator,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: Constants.rootPage,
        parentNavigatorKey: _rootNavigator,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: Constants.onBoardingPage,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const OnBoardingPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: Constants.profile,
            pageBuilder: (context, state) {
              final userData = state.extra as UserData?;
              return CustomTransitionPage(
                key: state.pageKey,
                child: ProfilePage(userData: userData),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
}
