import 'package:equatable/equatable.dart';

class PlaybackState extends Equatable {
  final int currentIndex;
  final bool isPlaying;
  final double playbackSpeed; // 1.0, 2.0, etc.
  final int totalCount;

  const PlaybackState({
    this.currentIndex = 0,
    this.isPlaying = false,
    this.playbackSpeed = 1.0,
    this.totalCount = 0,
  });

  double get progress => totalCount > 0 ? currentIndex / (totalCount - 1) : 0.0;

  PlaybackState copyWith({
    int? currentIndex,
    bool? isPlaying,
    double? playbackSpeed,
    int? totalCount,
  }) {
    return PlaybackState(
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [currentIndex, isPlaying, playbackSpeed, totalCount];
}
