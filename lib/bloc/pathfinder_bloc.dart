import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_event.dart';
import 'package:pathfinder/bloc/pathfinder_state.dart';

class PathfinderBloc extends Bloc<PathfinderEvent, PathfinderState> {
  PathfinderBloc()
      : super(PathfinderLoaded(
          data: [],
          url: '',
        )) {
    on<SavePathfinderData>((event, emit) {
      emit(PathfinderLoaded(
          data: event.data, url: (state as PathfinderLoaded).url));
    });

    on<SavePathfinderUrl>((event, emit) {
      final currentState = state as PathfinderLoaded;
      emit(PathfinderLoaded(data: currentState.data, url: event.url));
    });
  }
}
