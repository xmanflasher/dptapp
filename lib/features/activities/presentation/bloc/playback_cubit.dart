import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'playback_state.dart';

class PlaybackCubit extends Cubit<PlaybackState> {
  Timer? _timer;

  PlaybackCubit() : super(const PlaybackState());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void initialize(int count) {
    emit(state.copyWith(totalCount: count, currentIndex: 0, isPlaying: false));
  }

  void play() {
    if (state.currentIndex >= state.totalCount - 1) {
      emit(state.copyWith(currentIndex: 0));
    }
    emit(state.copyWith(isPlaying: true));
    _startTimer();
  }

  void pause() {
    _timer?.cancel();
    emit(state.copyWith(isPlaying: false));
  }

  void seek(int index) {
    emit(state.copyWith(currentIndex: index.clamp(0, state.totalCount - 1)));
  }

  void setSpeed(double speed) {
    emit(state.copyWith(playbackSpeed: speed));
    if (state.isPlaying) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    final duration = Duration(milliseconds: (1000 / state.playbackSpeed).toInt());
    _timer = Timer.periodic(duration, (timer) {
      if (state.currentIndex < state.totalCount - 1) {
        emit(state.copyWith(currentIndex: state.currentIndex + 1));
      } else {
        pause();
      }
    });
  }
}
