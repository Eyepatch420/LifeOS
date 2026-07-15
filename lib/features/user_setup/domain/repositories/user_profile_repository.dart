import 'package:lifeos/features/user_setup/domain/models/user_profile.dart';

abstract interface class UserProfileRepository {
  Future<UserProfile?> getProfile();

  Future<void> saveProfile(UserProfile profile);

  bool isOnboardingComplete();

  Future<void> setOnboardingComplete();
}
