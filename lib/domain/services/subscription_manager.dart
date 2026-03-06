
import '../entities/user_profile.dart';

class SubscriptionManager {
  bool isFeatureEnabled(UserProfile? user, String featureKey) {
    if (user == null) return false;
    
    // Simple gating logic
    if (user.subscriptionTier == 'premium') {
      return true;
    }
    
    // List of free features
    final freeFeatures = ['basic_training', 'activity_history', 'basic_charts'];
    return freeFeatures.contains(featureKey);
  }
}
