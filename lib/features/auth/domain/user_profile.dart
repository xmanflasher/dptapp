import 'package:equatable/equatable.dart';
import 'badge.dart';

class UserProfile extends Equatable {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final List<Badge> earnedBadges;
  final bool isMock;

  final String subscriptionTier; // 'free' or 'premium'
  final Map<String, dynamic> preferences;

  const UserProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.earnedBadges = const [],
    this.isMock = false,
    this.subscriptionTier = 'free',
    this.preferences = const {},
  });

  @override
  List<Object?> get props => [
        id,
        displayName,
        avatarUrl,
        bio,
        earnedBadges,
        isMock,
        subscriptionTier,
        preferences
      ];

  int get badgeCount => earnedBadges.length;

  UserProfile copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    List<Badge>? earnedBadges,
    String? subscriptionTier,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      isMock: isMock,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'earnedBadges': earnedBadges.map((x) => x.toMap()).toList(),
      'isMock': isMock,
      'subscriptionTier': subscriptionTier,
      'preferences': preferences,
    };
  }

  factory UserProfile.fromMap(Map<dynamic, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      bio: map['bio'] as String?,
      earnedBadges: (map['earnedBadges'] as List<dynamic>?)
              ?.map((x) => Badge.fromMap(x as Map<dynamic, dynamic>))
              .toList() ??
          const [],
      isMock: map['isMock'] as bool? ?? false,
      subscriptionTier: map['subscriptionTier'] as String? ?? 'free',
      preferences: Map<String, dynamic>.from(map['preferences'] as Map? ?? {}),
    );
  }
}
