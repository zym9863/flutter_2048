import 'package:flutter/material.dart';
import '../models/game_board.dart';
import '../theme/app_theme.dart';
import 'tile.dart';

class GameGrid extends StatelessWidget {
  final GameBoard gameBoard;
  final double padding;
  final double spacing;

  const GameGrid({
    super.key,
    required this.gameBoard,
    this.padding = 16.0,
    this.spacing = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppTheme.neonBlue.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonBlue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 分数显示
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 游戏标题
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppTheme.neonBlue, AppTheme.neonGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    '2048',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // 分数显示
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppTheme.darkPurpleBackground.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppTheme.neonBlue.withOpacity(0.5), width: 1),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neonBlue,
                        ),
                      ),
                      Text(
                        '${gameBoard.score}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neonGreen,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: AppTheme.neonGreen.withOpacity(0.5),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 网格背景 - 添加极细网格线
          Container(
            decoration: BoxDecoration(
              color: AppTheme.darkBackground,
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: const NetworkImage('https://transparenttextures.com/patterns/carbon-fibre.png'),
                opacity: 0.05,
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gameBoard.size,
                childAspectRatio: 1.0,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: gameBoard.size * gameBoard.size,
              itemBuilder: (context, index) {
                final row = index ~/ gameBoard.size;
                final col = index % gameBoard.size;
                return Tile(value: gameBoard.board[row][col]);
              },
            ),
          ),
          // 游戏结束提示
          if (gameBoard.gameOver)
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppTheme.neonBlue, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.neonBlue.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Text(
                'Game Over!',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}