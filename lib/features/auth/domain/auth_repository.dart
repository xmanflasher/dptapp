import 'package:dptapp/features/auth/domain/user_profile.dart';

abstract class AuthRepository {
  Stream<UserProfile?> get user;
  Future<void> loginWithMock(String name);
  Future<void> loginWithGoogle();
  Future<void> loginWithLine();
  Future<void> loginWithFacebook();
  Future<void> logout();
  UserProfile? get currentUser;
}
