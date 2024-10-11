import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pathfinder/bloc/pathfinder_event.dart';
import 'package:pathfinder/bloc/pathfinder_state.dart';

class PathfinderBloc extends Bloc<PathfinderEvent, PathfinderState> {
  PathfinderBloc() : super(PathfinderLoaded([])) {
    on<SavePathfinderData>((event, emit) {
      emit(PathfinderLoaded(event.data));
    });
  }
}
