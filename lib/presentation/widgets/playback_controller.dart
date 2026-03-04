import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/playback/playback_cubit.dart';
import '../bloc/playback/playback_state.dart';

class PlaybackController extends StatelessWidget {
  const PlaybackController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaybackCubit, PlaybackState>(
      builder: (context, state) {
        if (state.totalCount == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.black12,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      if (state.isPlaying) {
                        context.read<PlaybackCubit>().pause();
                      } else {
                        context.read<PlaybackCubit>().play();
                      }
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: state.currentIndex.toDouble(),
                      min: 0,
                      max: (state.totalCount - 1).toDouble(),
                      onChanged: (value) {
                        context.read<PlaybackCubit>().seek(value.toInt());
                      },
                    ),
                  ),
                  Text(
                    "${state.currentIndex + 1} / ${state.totalCount}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Speed: ", style: TextStyle(fontSize: 12)),
                  DropdownButton<double>(
                    value: state.playbackSpeed,
                    items: [1.0, 2.0, 5.0, 10.0].map((s) {
                      return DropdownMenuItem(value: s, child: Text("${s}x", style: const TextStyle(fontSize: 12)));
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        context.read<PlaybackCubit>().setSpeed(value);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
