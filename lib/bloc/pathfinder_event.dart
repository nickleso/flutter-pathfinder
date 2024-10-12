abstract class PathfinderEvent {}

class SavePathfinderData extends PathfinderEvent {
  final List<dynamic> data;

  SavePathfinderData(this.data);
}

class SavePathfinderUrl extends PathfinderEvent {
  final String url;

  SavePathfinderUrl(this.url);
}
