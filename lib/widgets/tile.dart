import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Tile extends StatefulWidget {
  final int value;
  
  const Tile({super.key, required this.value});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    // 启动动画
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(Tile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != 0) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int value = widget.value;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: value != 0 ? _scaleAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: value == 0 
                ? null 
                : AppTheme.getTileGradient(value),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: value >= 128 ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Center(
              child: value == 0
                  ? null
                  : Text(
                      '$value',
                      style: AppTheme.getTileTextStyle(value),
                    ),
            ),
          ),
        );
      },
    );
  }
}