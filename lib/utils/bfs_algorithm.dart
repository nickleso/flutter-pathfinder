import 'dart:collection';

List<Map<String, int>>? bfs(
    List<String> field, Map<String, int> start, Map<String, int> end) {
  List<List<int>> directions = [
    [0, 1],
    [0, -1],
    [1, 0],
    [-1, 0],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ];

  Queue<List<Map<String, int>>> queue = Queue();
  queue.add([start]);

  Set<String> visited = {key(start['x'] ?? 0, start['y'] ?? 0)};

  while (queue.isNotEmpty) {
    List<Map<String, int>> path = queue.removeFirst();
    Map<String, int> current = path.last;

    if (current['x'] == end['x'] && current['y'] == end['y']) {
      return path;
    }

    for (var direction in directions) {
      int newX = (current['x'] ?? 0) + direction[0];
      int newY = (current['y'] ?? 0) + direction[1];

      if (isValidCell(newX, newY, field, visited)) {
        visited.add(key(newX, newY));

        List<Map<String, int>> newPath = List.from(path)
          ..add({"x": newX, "y": newY});
        queue.add(newPath);
      }
    }
  }

  return null;
}

bool isValidCell(int x, int y, List<String> field, Set<String> visited) {
  int rows = field.length;
  int cols = field[0].length;

  return x >= 0 &&
      y >= 0 &&
      x < cols &&
      y < rows &&
      field[y][x] == '.' &&
      !visited.contains(key(x, y));
}

String key(int x, int y) => '$x,$y';
