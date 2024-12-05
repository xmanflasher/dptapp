part of 'timer_bloc.dart';
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class StartTimer extends TimerEvent {}

class PauseTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}

class RecordLap extends TimerEvent {}

class Tick extends TimerEvent {
  final int duration;

  const Tick(this.duration);

  @override
  List<Object> get props => [duration];
}