/*
 * Copyright (c) 2026 Vladimir E. Koltunov
 * Please see the AUTHORS file for details.
 * All rights reserved.
 */

// ignore_for_file: constant_identifier_names

import 'package:env_annotation/env_annotation.dart';

part 'example.g.dart';

@env
const ENV1 = _$1;

@env
const ENV2 = _$2;

@env
const ENV3 = _$ENV3;

@envInt
const ENV4 = _$ENV4;

@envInt
const ENV5 = _$5;

// Run as:
// ENV1=value1 dart run --define=ENV1=compiled1 --define=ENV2=compiled2 lib/example.dart
// will print: value1 compiled2 default3 4 5555
void main() {
  EnvVar.loadEnv();
  print(
      '${ENV1('default1')} ${ENV2('default2')} ${ENV3('default3')} ${ENV4(4)} ${ENV5(5)}');
}
