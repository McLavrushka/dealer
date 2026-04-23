import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../groups/data/models/member_dto.dart';

/// Wheel sectors start at the top (-π/2), clockwise.
class RouletteWheelPainter extends CustomPainter {
  RouletteWheelPainter({
    required this.members,
    required this.colorScheme,
  });

  final List<MemberDto> members;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final n = members.length;
    if (n == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.92;
    final sweep = 2 * math.pi / n;

    for (var i = 0; i < n; i++) {
      final startAngle = -math.pi / 2 + i * sweep;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = i.isEven
            ? colorScheme.primaryContainer
            : colorScheme.secondaryContainer;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          false,
        )
        ..close();
      canvas.drawPath(path, paint);

      final mid = startAngle + sweep / 2;
      final labelRadius = radius * 0.62;
      final tp = TextPainter(
        text: TextSpan(
          text: _shortLabel(members[i].name),
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontSize: n > 8 ? 10 : 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: radius * 0.45);

      final ox = center.dx + math.cos(mid) * labelRadius - tp.width / 2;
      final oy = center.dy + math.sin(mid) * labelRadius - tp.height / 2;
      tp.paint(canvas, Offset(ox, oy));
    }

    final hub = Paint()..color = colorScheme.surface;
    canvas.drawCircle(center, radius * 0.12, hub);
  }

  static String _shortLabel(String name) {
    final t = name.trim();
    if (t.length <= 10) return t;
    return '${t.substring(0, 8)}…';
  }

  @override
  bool shouldRepaint(covariant RouletteWheelPainter oldDelegate) =>
      !listEquals(oldDelegate.members, members) ||
      oldDelegate.colorScheme != colorScheme;
}

/// Returns rotation (radians) so sector [winnerIndex] center aligns with the top pointer.
double rotationAligningWinner(int winnerIndex, int sectorCount) {
  final n = sectorCount;
  if (n <= 0) return 0;
  final sweep = 2 * math.pi / n;
  final thetaW = -math.pi / 2 + (winnerIndex + 0.5) * sweep;
  var r = -math.pi / 2 - thetaW;
  r %= 2 * math.pi;
  if (r < 0) r += 2 * math.pi;
  return r;
}

/// Target cumulative rotation: at least [minSpins] full turns from [current].
double computeSpinEndRotation({
  required double current,
  required int winnerIndex,
  required int sectorCount,
  double minSpins = 5,
}) {
  final n = sectorCount;
  final sweep = 2 * math.pi / n;
  final thetaW = -math.pi / 2 + (winnerIndex + 0.5) * sweep;
  var target = -math.pi / 2 - thetaW;
  while (target < current + minSpins * 2 * math.pi) {
    target += 2 * math.pi;
  }
  return target;
}
