import 'dart:math' as math;
import 'dart:ui';

extension CollapsingToolbarColorEx on Color {
  Color darker(double percent) {
    var v = -percent * 255.0;
    return Color.fromRGBO(_clampColorValue(red + v),
        _clampColorValue(green + v), _clampColorValue(blue + v), opacity);
  }

  Color lighter(double percent) {
    return darker(-percent);
  }
}

int _clampColorValue(num value) => math.max(0, math.min(255, value.round()));
