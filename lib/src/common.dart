import 'dart:math' as math;
import 'dart:ui';

/// An extension for [Color]
extension CollapsingToolbarColorEx on Color {
  /// Make a darker color by subtracting [percent] of 255 from its red|green|blue value.
  Color darker(double percent) {
    var v = -percent * 255.0;
    return Color.fromRGBO(_clampColorValue(red + v),
        _clampColorValue(green + v), _clampColorValue(blue + v), opacity);
  }

  /// Make a lighter color by adding [percent] of 255 to its red|green|blue value.
  Color lighter(double percent) {
    return darker(-percent);
  }
}

int _clampColorValue(num value) => math.max(0, math.min(255, value.round()));
