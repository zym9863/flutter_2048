import 'dart:math';

enum Direction { up, down, left, right }

class GameBoard {
  // 游戏板大小，标准2048是4x4
  final int size;
  // 游戏板矩阵
  List<List<int>> board;
  // 当前分数
  int score = 0;
  // 游戏是否结束
  bool gameOver = false;
  // 随机数生成器
  final Random _random = Random();

  GameBoard({this.size = 4}) : board = List.generate(
    4, 
    (_) => List.filled(4, 0)
  ) {
    // 初始化游戏板，添加两个初始方块
    addRandomTile();
    addRandomTile();
  }

  // 添加一个随机方块（2或4）到空位置
  void addRandomTile() {
    List<List<int>> emptyTiles = [];
    
    // 找出所有空位置
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == 0) {
          emptyTiles.add([i, j]);
        }
      }
    }

    // 如果没有空位置，返回
    if (emptyTiles.isEmpty) return;

    // 随机选择一个空位置
    final position = emptyTiles[_random.nextInt(emptyTiles.length)];
    // 90%概率生成2，10%概率生成4
    board[position[0]][position[1]] = _random.nextDouble() < 0.9 ? 2 : 4;
  }

  // 检查游戏是否结束
  bool checkGameOver() {
    // 检查是否有空位置
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == 0) return false;
      }
    }

    // 检查是否有可以合并的相邻方块
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size - 1; j++) {
        if (board[i][j] == board[i][j + 1]) return false;
      }
    }

    for (int j = 0; j < size; j++) {
      for (int i = 0; i < size - 1; i++) {
        if (board[i][j] == board[i + 1][j]) return false;
      }
    }

    // 如果没有空位置且没有可合并的方块，游戏结束
    return true;
  }

  // 移动方块
  bool move(Direction direction) {
    bool moved = false;
    
    // 保存移动前的状态，用于检测是否有变化
    // List<List<int>> previousBoard = List.generate(
    //   size, 
    //   (i) => List.from(board[i])
    // );

    switch (direction) {
      case Direction.up:
        moved = _moveUp();
        break;
      case Direction.down:
        moved = _moveDown();
        break;
      case Direction.left:
        moved = _moveLeft();
        break;
      case Direction.right:
        moved = _moveRight();
        break;
    }

    // 如果有移动，添加一个新方块
    if (moved) {
      addRandomTile();
      // 检查游戏是否结束
      gameOver = checkGameOver();
    }

    return moved;
  }

  // 向上移动
  bool _moveUp() {
    bool moved = false;
    for (int j = 0; j < size; j++) {
      for (int i = 1; i < size; i++) {
        if (board[i][j] != 0) {
          int row = i;
          while (row > 0) {
            // 如果上方为空，移动
            if (board[row - 1][j] == 0) {
              board[row - 1][j] = board[row][j];
              board[row][j] = 0;
              row--;
              moved = true;
            }
            // 如果上方数字相同，合并
            else if (board[row - 1][j] == board[row][j]) {
              board[row - 1][j] *= 2;
              score += board[row - 1][j]; // 增加分数
              board[row][j] = 0;
              moved = true;
              break;
            }
            else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  // 向下移动
  bool _moveDown() {
    bool moved = false;
    for (int j = 0; j < size; j++) {
      for (int i = size - 2; i >= 0; i--) {
        if (board[i][j] != 0) {
          int row = i;
          while (row < size - 1) {
            // 如果下方为空，移动
            if (board[row + 1][j] == 0) {
              board[row + 1][j] = board[row][j];
              board[row][j] = 0;
              row++;
              moved = true;
            }
            // 如果下方数字相同，合并
            else if (board[row + 1][j] == board[row][j]) {
              board[row + 1][j] *= 2;
              score += board[row + 1][j]; // 增加分数
              board[row][j] = 0;
              moved = true;
              break;
            }
            else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  // 向左移动
  bool _moveLeft() {
    bool moved = false;
    for (int i = 0; i < size; i++) {
      for (int j = 1; j < size; j++) {
        if (board[i][j] != 0) {
          int col = j;
          while (col > 0) {
            // 如果左方为空，移动
            if (board[i][col - 1] == 0) {
              board[i][col - 1] = board[i][col];
              board[i][col] = 0;
              col--;
              moved = true;
            }
            // 如果左方数字相同，合并
            else if (board[i][col - 1] == board[i][col]) {
              board[i][col - 1] *= 2;
              score += board[i][col - 1]; // 增加分数
              board[i][col] = 0;
              moved = true;
              break;
            }
            else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  // 向右移动
  bool _moveRight() {
    bool moved = false;
    for (int i = 0; i < size; i++) {
      for (int j = size - 2; j >= 0; j--) {
        if (board[i][j] != 0) {
          int col = j;
          while (col < size - 1) {
            // 如果右方为空，移动
            if (board[i][col + 1] == 0) {
              board[i][col + 1] = board[i][col];
              board[i][col] = 0;
              col++;
              moved = true;
            }
            // 如果右方数字相同，合并
            else if (board[i][col + 1] == board[i][col]) {
              board[i][col + 1] *= 2;
              score += board[i][col + 1]; // 增加分数
              board[i][col] = 0;
              moved = true;
              break;
            }
            else {
              break;
            }
          }
        }
      }
    }
    return moved;
  }

  // 重置游戏
  void reset() {
    // 清空游戏板
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        board[i][j] = 0;
      }
    }
    // 重置分数和游戏状态
    score = 0;
    gameOver = false;
    // 添加初始方块
    addRandomTile();
    addRandomTile();
  }
  
  // 获取当前最高的方块值
  int getHighestTile() {
    int highest = 0;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] > highest) {
          highest = board[i][j];
        }
      }
    }
    return highest;
  }
}
