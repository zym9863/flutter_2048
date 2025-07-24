import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'models/game_board.dart' as game_board;
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

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late game_board.GameBoard gameBoard;
  final FocusNode _focusNode = FocusNode();
  late ConfettiController _confettiController;
  int _previousHighestTile = 0;

  @override
  void initState() {
    super.initState();
    gameBoard = game_board.GameBoard();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // 处理方向键输入
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _move(game_board.Direction.up);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _move(game_board.Direction.down);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _move(game_board.Direction.left);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _move(game_board.Direction.right);
      }
    }
  }

  // 处理滑动手势
  void _handleSwipe(DragUpdateDetails details) {
    // 判断滑动方向
    if (details.delta.dx.abs() > details.delta.dy.abs()) {
      // 水平滑动
      if (details.delta.dx > 0) {
        _move(game_board.Direction.right);
      } else {
        _move(game_board.Direction.left);
      }
    } else {
      // 垂直滑动
      if (details.delta.dy > 0) {
        _move(game_board.Direction.down);
      } else {
        _move(game_board.Direction.up);
      }
    }
  }

  // 移动并更新状态
  void _move(game_board.Direction direction) {
    setState(() {
      gameBoard.move(direction);
      
      // 检查是否达到新的里程碑
      int highestTile = gameBoard.getHighestTile();
      if (highestTile > _previousHighestTile && highestTile >= 512) {
        _confettiController.play();
        _previousHighestTile = highestTile;
      }
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
      body: Stack(
        children: [
          // 背景渐变
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.darkBackground,
                  AppTheme.darkPurpleBackground.withOpacity(0.3),
                  AppTheme.darkBackground,
                ],
              ),
            ),
          ),
          // 主要内容
          SafeArea(
            child: Column(
              children: [
                // 自定义AppBar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [AppTheme.neonBlue, AppTheme.neonGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Text(
                          '2048 FUTURE',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ).animate()
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                      IconButton(
                        icon: Icon(Icons.refresh_rounded, color: AppTheme.neonBlue, size: 28),
                        onPressed: _resetGame,
                        tooltip: '重置游戏',
                      ).animate()
                        .fadeIn(delay: 300.ms)
                        .scale(begin: const Offset(0, 0), end: const Offset(1, 1)),
                    ],
                  ),
                ),
                // 游戏主体
                Expanded(
                  child: RawKeyboardListener(
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
                              GameGrid(gameBoard: gameBoard)
                                .animate()
                                .fadeIn(duration: 800.ms, delay: 200.ms)
                                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.darkPurpleBackground.withOpacity(0.6),
                                      AppTheme.darkPurpleBackground.withOpacity(0.4),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3), width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.neonBlue.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.swipe_rounded, color: AppTheme.neonBlue, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      '使用方向键或滑动手势移动方块',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppTheme.lightGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate()
                                .fadeIn(duration: 600.ms, delay: 600.ms)
                                .slideY(begin: 0.2, end: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                AppTheme.neonBlue,
                AppTheme.neonGreen,
                Colors.yellow,
                Colors.orange,
                Colors.purple,
              ],
              createParticlePath: drawStar,
              numberOfParticles: 30,
              gravity: 0.1,
              emissionFrequency: 0.05,
              blastDirection: pi / 2,
            ),
          ),
        ],
      ),
    );
  }
  
  // 绘制星形粒子
  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
