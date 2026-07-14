import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientAvatar extends StatelessWidget {
  final String initials;
  final int seed;
  final double size;
  final bool showOnline;

  const GradientAvatar({
    super.key,
    required this.initials,
    required this.seed,
    this.size = 52,
    this.showOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final grad = AppColors
        .avatarGradients[seed % AppColors.avatarGradients.length];
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: grad,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: grad.last.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.38,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: AppColors.online,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
