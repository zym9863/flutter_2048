import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/game_board.dart';
import 'theme/app_theme.dart';
import 'widgets/game_grid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Game',
      theme: AppTheme.getThemeData(),
      debugShowCheckedModeBanner: false,
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameBoard gameBoard;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    gameBoard = GameBoard();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // 处理方向键输入
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _move(Direction.up);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _move(Direction.down);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _move(Direction.left);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _move(Direction.right);
      }
    }
  }

  // 处理滑动手势
  void _handleSwipe(DragUpdateDetails details) {
    // 判断滑动方向
    if (details.delta.dx.abs() > details.delta.dy.abs()) {
      // 水平滑动
      if (details.delta.dx > 0) {
        _move(Direction.right);
      } else {
        _move(Direction.left);
      }
    } else {
      // 垂直滑动
      if (details.delta.dy > 0) {
        _move(Direction.down);
      } else {
        _move(Direction.up);
      }
    }
  }

  // 移动并更新状态
  void _move(Direction direction) {
    setState(() {
      gameBoard.move(direction);
    });
  }

  // 重置游戏
  void _resetGame() {
    setState(() {
      gameBoard.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('2048 FUTURE'),
        backgroundColor: AppTheme.darkPurpleBackground.withOpacity(0.8),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppTheme.neonBlue),
            onPressed: _resetGame,
            tooltip: '重置游戏',
          ),
        ],
      ),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        autofocus: true,
        child: GestureDetector(
          onPanUpdate: _handleSwipe,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 700,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameGrid(gameBoard: gameBoard),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: AppTheme.darkPurpleBackground.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swipe, color: AppTheme.neonBlue, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '使用方向键或滑动手势移动方块',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
