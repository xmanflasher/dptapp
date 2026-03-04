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

  @override
  List<Object?> get props => [id, name, description, iconAsset, earnedAt];
}
