part of 'timer_bloc.dart';

class TimerState extends Equatable {
  final int duration;
  final List<int> laps;

  const TimerState(this.duration, this.laps);

  @override
  List<Object> get props => [duration, laps];
}