import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerState(0, [])) {
    on<StartTimer>(_onStart);
    on<PauseTimer>(_onPause);
    on<StopTimer>(_onStop);
    on<RecordLap>(_onRecordLap);
    on<Tick>(_onTick);
  }

  Timer? _timer;

  void _onStart(StartTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(Tick(state.duration + 1));
    });
  }

  void _onPause(PauseTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
  }

  void _onStop(StopTimer event, Emitter<TimerState> emit) async {
    _timer?.cancel();
    final box = Hive.box('timerBox');
    await box.put('duration', state.duration);
    await box.put('laps', state.laps);
    emit(const TimerState(0, []));
  }

  void _onRecordLap(RecordLap event, Emitter<TimerState> emit) {
    final laps = List<int>.from(state.laps)..add(state.duration);
    emit(TimerState(state.duration, laps));
  }

  void _onTick(Tick event, Emitter<TimerState> emit) {
    emit(TimerState(event.duration, state.laps));
  }
}