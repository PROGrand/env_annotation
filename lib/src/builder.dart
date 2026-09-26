/*
 * Copyright (c) 2026 Vladimir E. Koltunov
 * Please see the AUTHORS file for details.
 * All rights reserved.
 */

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator.dart';

Builder envBuilder(BuilderOptions options) =>
    SharedPartBuilder([EnvStringGenerator(), EnvIntGenerator()], 'env');
