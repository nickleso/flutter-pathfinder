abstract class PathfinderEvent {}

class SavePathfinderData extends PathfinderEvent {
  final List<dynamic> data;

  SavePathfinderData(this.data);
}
