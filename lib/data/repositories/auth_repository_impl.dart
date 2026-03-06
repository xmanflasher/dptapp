import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/badge.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _controller = StreamController<UserProfile?>();
  UserProfile? _currentUser;
  late Box _authBox;
  
  static const String _boxName = 'auth_persistence';
  static const String _userKey = 'current_user';

  AuthRepositoryImpl() {
    _initPersistence();
  }

  Future<void> _initPersistence() async {
    _authBox = await Hive.openBox(_boxName);
    final storedData = _authBox.get(_userKey);
    if (storedData != null && storedData is Map) {
      // In a real app, we'd also check token validity here
      _currentUser = UserProfile.fromMap(storedData);
      _controller.add(_currentUser);
    }
  }

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
      subscriptionTier: 'premium', // For testing
      earnedBadges: [
        Badge(
          id: 'b1',
          name: 'Pace Master',
          description: 'Maintained < 2:30/500m for 1km',
          iconAsset: 'bolt',
          earnedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    );
    await _saveUser();
  }

  @override
  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserProfile(
      id: 'google_user_123',
      displayName: 'Google Athlete',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Google',
      isMock: false,
      subscriptionTier: 'free',
      earnedBadges: [],
    );
    await _saveUser();
  }

  @override
  Future<void> loginWithLine() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserProfile(
      id: 'line_user_456',
      displayName: 'LINE Paddler',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=LINE',
      isMock: false,
      subscriptionTier: 'premium',
      earnedBadges: [],
    );
    await _saveUser();
  }

  @override
  Future<void> loginWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserProfile(
      id: 'fb_user_789',
      displayName: 'Facebook Racer',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Facebook',
      isMock: false,
      subscriptionTier: 'free',
      earnedBadges: [],
    );
    await _saveUser();
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await _authBox.delete(_userKey);
    _controller.add(null);
  }

  Future<void> _saveUser() async {
    if (_currentUser != null) {
      await _authBox.put(_userKey, _currentUser!.toMap());
    }
    _controller.add(_currentUser);
  }
}
