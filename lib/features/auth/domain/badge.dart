import 'package:equatable/equatable.dart';

class Badge extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final DateTime earnedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.earnedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconAsset': iconAsset,
      'earnedAt': earnedAt.toIso8601String(),
    };
  }

  factory Badge.fromMap(Map<dynamic, dynamic> map) {
    return Badge(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      iconAsset: map['iconAsset'] as String,
      earnedAt: DateTime.parse(map['earnedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, name, description, iconAsset, earnedAt];
}
