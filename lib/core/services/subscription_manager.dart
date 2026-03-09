import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dptapp/features/auth/presentation/bloc/auth_cubit.dart';

/// A foundational service to manage premium subscriptions and feature locks.
/// Currently relies on the AuthCubit's UserProfile.subscriptionTier.
class SubscriptionManager {
  final AuthCubit authCubit;

  SubscriptionManager({required this.authCubit});

  /// Checks if the current user has access to premium features.
  bool get isPremium {
    final profile = authCubit.state.user;
    if (profile == null) return false;

    // For Phase 5 testing:
    // This allows us to easily test the locked state.
    // In the future this will be driven strictly by the backend/In-App Purchases.
    return profile.subscriptionTier == 'premium';
  }

  /// Helper to get the semantic name of the current tier
  String get currentTierName {
    final profile = authCubit.state.user;
    if (profile == null) return 'Guest';
    return profile.subscriptionTier == 'premium'
        ? 'Elite Dragon'
        : 'Basic Paddler';
  }
}
