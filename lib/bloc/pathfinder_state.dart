abstract class PathfinderState {}

class PathfinderLoaded extends PathfinderState {
  final List<dynamic> data;

  PathfinderLoaded(this.data);
}
