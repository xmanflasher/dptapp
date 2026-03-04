import 'package:equatable/equatable.dart';
import 'badge.dart';

class UserProfile extends Equatable {
  final String id;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final List<Badge> earnedBadges;
  final bool isMock;

  const UserProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.earnedBadges = const [],
    this.isMock = false,
  });

  @override
  List<Object?> get props => [id, displayName, avatarUrl, bio, earnedBadges, isMock];

  int get badgeCount => earnedBadges.length;

  UserProfile copyWith({
    String? displayName,
    String? avatarUrl,
    String? bio,
    List<Badge>? earnedBadges,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      isMock: isMock,
    );
  }
}
