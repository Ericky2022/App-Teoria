import 'package:flutter/material.dart';

import '../models/music_note.dart';

class StaffWidget extends StatelessWidget {
  final MusicNote note;

  const StaffWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 250),
      painter: _StaffPainter(note),
    );
  }
}

class _StaffPainter extends CustomPainter {
  final MusicNote note;

  _StaffPainter(this.note);

  @override
  void paint(Canvas canvas, Size size) {
    const left = 24.0;
    final right = size.width - 24.0;
    const top = 80.0;
    const spacing = 22.0;

    final linePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      final y = top + i * spacing;
      canvas.drawLine(Offset(left, y), Offset(right, y), linePaint);
    }

    _drawTrebleClef(canvas, x: left + 6, top: top, spacing: spacing);

    final noteX = size.width * 0.56;
    final bottomLineY = top + 4 * spacing;
    final noteY = bottomLineY - note.staffStep * (spacing / 2);

    _drawLedgerLines(canvas, noteX, noteY, top, spacing, linePaint);
    _drawNoteHead(canvas, noteX, noteY, note.duration);
    _drawStem(canvas, noteX, noteY, note.duration, linePaint);
  }

  void _drawTrebleClef(
    Canvas canvas, {
    required double x,
    required double top,
    required double spacing,
  }) {
    final gLineY = top + 3 * spacing;

    // U+1D11E (MUSICAL SYMBOL G CLEF) gives a cleaner, score-like treble clef.
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '𝄞',
        style: TextStyle(
          fontSize: 98,
          color: Color(0xFF0D1B2A),
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final clefX = x - 2;
    final clefY = gLineY - 45;
    textPainter.paint(canvas, Offset(clefX, clefY));
  }

  void _drawLedgerLines(
    Canvas canvas,
    double noteX,
    double noteY,
    double top,
    double spacing,
    Paint paint,
  ) {
    final topLineY = top;
    final bottomLineY = top + 4 * spacing;

    if (noteY < topLineY - 1) {
      double y = topLineY - spacing;
      while (y >= noteY - 1) {
        canvas.drawLine(Offset(noteX - 22, y), Offset(noteX + 22, y), paint);
        y -= spacing;
      }
    }

    if (noteY > bottomLineY + 1) {
      double y = bottomLineY + spacing;
      while (y <= noteY + 1) {
        canvas.drawLine(Offset(noteX - 22, y), Offset(noteX + 22, y), paint);
        y += spacing;
      }
    }
  }

  void _drawNoteHead(Canvas canvas, double x, double y, int duration) {
    final rect = Rect.fromCenter(center: Offset(x, y), width: 30, height: 20);

    final strokePaint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.fill;

    if (duration == 4 || duration == 2) {
      canvas.drawOval(rect, strokePaint);
    } else {
      canvas.drawOval(rect, fillPaint);
    }
  }

  void _drawStem(Canvas canvas, double x, double y, int duration, Paint paint) {
    if (duration == 2 || duration == 1) {
      canvas.drawLine(Offset(x + 12, y), Offset(x + 12, y - 60), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StaffPainter oldDelegate) {
    return oldDelegate.note != note;
  }
}
