import 'package:go_router/go_router.dart';
import 'package:weight_plate_manager/pages/add_lift.dart';
import 'package:weight_plate_manager/pages/lift_details.dart';
import 'package:weight_plate_manager/pages/home_page.dart';
import 'package:weight_plate_manager/pages/login_options.dart';
import 'package:weight_plate_manager/pages/signup_page.dart';
import 'package:weight_plate_manager/pages/workout_log.dart';
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginOptions()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/signup', builder: (context, state) => SignupPage()),
    GoRoute(path: '/addlift', builder: (context, state) => AddLift()),
    GoRoute(path: '/workoutlog', builder: (context, state) => WorkoutLog()),
    GoRoute(
      path: '/dolift',
      builder: (context, state) {
        // Extract parameters from the route state
        final selectedBarbell =
            state.uri.queryParameters['barbell'] ?? "Men's Olympic Barbell";
        final barbellWeight =
            double.tryParse(state.uri.queryParameters['weight'] ?? '20.0') ??
            20.0;
        return LiftDetails(
          selectedBarbell: selectedBarbell,
          barbellWeight: barbellWeight,
        );
      },
    ),
  ],
);
