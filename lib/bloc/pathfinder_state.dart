abstract class PathfinderState {}

class PathfinderLoaded extends PathfinderState {
  final List<dynamic> data;
  final String url;

  PathfinderLoaded({required this.data, required this.url});
}
