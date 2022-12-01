import 'dart:ui';

import 'package:realm/realm.dart';

part 'category.g.dart';

@RealmModel()
class $Category {
  @PrimaryKey()
  late final String name;
  late final int colorValue;

  Color get color {
    return Color(colorValue);
  }

  set color(Color value) {
    colorValue = value.value;
  }
}