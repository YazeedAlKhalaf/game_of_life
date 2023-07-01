import 'package:game_of_life/src/cell.dart';

class Universe {
  final int width;
  final int height;
  List<Cell> _cells;

  Universe({
    required this.width,
    required this.height,
    required List<Cell> initialCells,
  }) : _cells = initialCells;

  List<Cell> get cells => _cells;

  factory Universe.something() {
    const width = 64;
    const height = 64;

    return Universe(
      width: width,
      height: height,
      initialCells: List<Cell>.generate(
        width * height,
        (i) => i % 2 == 0 || i % 7 == 0 ? Cell.alive : Cell.dead,
      ),
    );
  }

  int getIndex(int row, int column) {
    return (row * width) + column;
  }

  int liveNeighborCount(int row, column) {
    int count = 0;

    for (int deltaRow in [height - 1, 0, 1]) {
      for (int deltaCol in [width - 1, 0, 1]) {
        if (deltaRow == 0 && deltaCol == 0) {
          continue;
        }

        final neighborRow = (row + deltaRow) % height;
        final neighborCol = (column + deltaCol) % width;
        final idx = getIndex(neighborRow, neighborCol);
        count += cells[idx].value;
      }
    }

    return count;
  }

  void tick() {
    final next = [...cells];

    for (int row in List.generate(height, (index) => index)) {
      for (int col in List.generate(width, (index) => index)) {
        final idx = getIndex(row, col);
        final cell = cells[idx];
        final liveNeigbors = liveNeighborCount(row, col);

        final nextCell = switch ((cell, liveNeigbors)) {
          // Rule 1: Any live cell with fewer than two live neighbors
          // dies, as if caused by underpopulation.
          (Cell.alive, int x) when x < 2 => Cell.dead,
          // Rule 2: Any live cell with two or three live neighbors
          // lives on to the next generation.
          (Cell.alive, 2) || (Cell.alive, 3) => Cell.alive,
          // Rule 3: Any live cell with more than three live neighbors
          // dies, as if by overpopulation.
          (Cell.alive, int x) when x > 3 => Cell.dead,
          // Rule 4: Any dead cell with exactly three live neighbors
          // becomes a live cell, as if by reproduction.
          (Cell.dead, 3) => Cell.alive,
          // All other cells remain in the same state.
          _ => cell,
        };

        next[idx] = nextCell;
      }
    }

    _cells = next;
  }

  @override
  String toString() {
    final stringBuffer = StringBuffer();

    for (int i = 0; i < cells.length; i += width) {
      final line = cells.sublist(i, i + width);

      for (final cell in line) {
        stringBuffer.write(cell == Cell.alive ? '◼' : '◻');
      }
      stringBuffer.write('\n');
    }

    return stringBuffer.toString();
  }
}
