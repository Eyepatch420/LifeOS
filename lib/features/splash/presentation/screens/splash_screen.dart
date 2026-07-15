import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/constants/app_constants.dart';
import 'package:lifeos/features/splash/presentation/widgets/splash_logo_animation.dart';
import 'package:lifeos/features/user_setup/presentation/providers/user_profile_providers.dart';

/// Runs its own animation on a timer and navigates explicitly — it does
/// NOT rely on the router's redirect logic, so the animation always gets
/// to play out even on a fast cold start (see docs/routes.md).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppConstants.splashMinimumDuration, _navigateNext);
  }

  void _navigateNext() {
    if (!mounted) return;
    final onboardingComplete = ref.read(onboardingCompleteProvider);
    if (onboardingComplete) {
      context.goNamed(RouteNames.home);
    } else {
      context.goNamed(RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashLogoAnimation());
  }
}
