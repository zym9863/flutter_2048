import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class Tile extends StatefulWidget {
  final int value;
  
  const Tile({super.key, required this.value});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    // 微光动画控制器
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    // 启动动画
    if (widget.value != 0) {
      _controller.forward();
      if (widget.value >= 128) {
        _shimmerController.repeat();
      }
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(Tile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != 0) {
      _controller.reset();
      _controller.forward();
      
      // 更新微光动画
      if (widget.value >= 128 && !_shimmerController.isAnimating) {
        _shimmerController.repeat();
      } else if (widget.value < 128 && _shimmerController.isAnimating) {
        _shimmerController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int value = widget.value;
    
    if (value == 0) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.emptyTileColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppTheme.emptyTileColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      );
    }
    
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _shimmerController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.getTileGradient(value),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: _getGlowColor(value).withOpacity(0.3 * _scaleAnimation.value),
                  blurRadius: value >= 512 ? 20.0 : 10.0,
                  spreadRadius: value >= 512 ? 2.0 : 1.0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Stack(
                children: [
                  // 主要内容
                  Center(
                    child: Text(
                      '$value',
                      style: AppTheme.getTileTextStyle(value),
                    ).animate()
                      .fadeIn(duration: 200.ms)
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  ),
                  // 微光效果层
                  if (value >= 128)
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _shimmerAnimation,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-1.0 + 2.0 * _shimmerAnimation.value, -0.3),
                                end: Alignment(-0.5 + 2.0 * _shimmerAnimation.value, 0.3),
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  // 2048特殊效果
                  if (value == 2048)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.yellow.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                        .shimmer(duration: 2.seconds, color: Colors.yellow.withOpacity(0.5)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Color _getGlowColor(int value) {
    if (value >= 2048) return Colors.yellow;
    if (value >= 512) return const Color(0xFF00E5FF);
    if (value >= 128) return const Color(0xFF7E57C2);
    if (value >= 32) return const Color(0xFFE91E63);
    return const Color(0xFFFF8A65);
  }
}