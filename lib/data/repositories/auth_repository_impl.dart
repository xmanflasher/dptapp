import 'dart:async';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/badge.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _controller = StreamController<UserProfile?>();
  UserProfile? _currentUser;

  @override
  Stream<UserProfile?> get user => _controller.stream;

  @override
  UserProfile? get currentUser => _currentUser;

  @override
  Future<void> loginWithMock(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = UserProfile(
      id: 'mock_id_${name.toLowerCase()}',
      displayName: name,
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=$name',
      isMock: true,
      earnedBadges: [
        Badge(
          id: 'b1',
          name: 'Pace Master',
          description: 'Maintained < 2:30/500m for 1km',
          iconAsset: 'bolt',
          earnedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Badge(
          id: 'b2',
          name: 'Early Bird',
          description: 'Trained before 7 AM',
          iconAsset: 'wb_sunny',
          earnedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
    );
    _controller.add(_currentUser);
  }

  @override
  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserProfile(
      id: 'google_user_123',
      displayName: 'Google Athlete',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Google',
      isMock: false,
      earnedBadges: [],
    );
    _controller.add(_currentUser);
  }

  @override
  Future<void> loginWithLine() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserProfile(
      id: 'line_user_456',
      displayName: 'LINE Paddler',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=LINE',
      isMock: false,
      earnedBadges: [],
    );
    _controller.add(_currentUser);
  }

  @override
  Future<void> loginWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserProfile(
      id: 'fb_user_789',
      displayName: 'Facebook Racer',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Facebook',
      isMock: false,
      earnedBadges: [],
    );
    _controller.add(_currentUser);
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    _controller.add(null);
  }
}
