/*
 * Copyright (c) 2026 Vladimir E. Koltunov
 * Please see the AUTHORS file for details.
 * All rights reserved.
 */

import 'package:dotenv/dotenv.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';
import 'package:universal_io/io.dart' show Platform, File;

/// String env variable annotation
@Target({TargetKind.topLevelVariable})
@sealed
final class Env {
  /// String env variable annotation
  const Env();
}

/// Int env variable annotation
@Target({TargetKind.topLevelVariable})
@sealed
final class EnvInt {
  /// Int env variable annotation
  const EnvInt();
}

// ignore: invalid_annotation_target
@Target({TargetKind.topLevelVariable})

/// String env variable annotation
const env = Env();

// ignore: invalid_annotation_target
@Target({TargetKind.topLevelVariable})

/// Int env variable annotation
const envInt = EnvInt();

/// Base class for env variables
abstract class EnvVar {
  final String _name;
  final String _fromEnvironment;

  /// Constructor
  /// _name - variable name
  /// _fromEnvironment - variable name from compiler environment
  const EnvVar(this._name, this._fromEnvironment);

  /// Stores env variables
  static DotEnv? env;

  /// Loads env variables from .env files
  /// 1. process environment.
  /// 2. From file named Platform.environment['ENV_FILE']
  /// 3. From file named '.env' in current directory
  /// 4. From file named '.env' in executable directory
  static void loadEnv(
      {bool includePlatformEnvironment = true, bool quiet = true}) {
    env = DotEnv(
        includePlatformEnvironment: includePlatformEnvironment, quiet: quiet)
      ..load([
        if (Platform.environment['ENV_FILE'] case String path) path,
        '.env',
        '${File(Platform.resolvedExecutable).parent.path}/.env'
      ]);
  }
}

abstract class _EnvVar<T> extends EnvVar {
  const _EnvVar(super.name, super.fromEnvironment);

  T call(T defaultValue) =>
      parse(EnvVar.env?[_name]) ??
      switch (_fromEnvironment) {
        final String s when s.isNotEmpty => parse(s) ?? defaultValue,
        _ => defaultValue,
      };

  T? parse(String? s);
}

/// String env variable
class $EnvVarString extends _EnvVar<String> {
  /// Constructor
  const $EnvVarString(super.name, super.fromEnvironment);

  @override
  String? parse(String? value) => value;
}

/// Int env variable
class $EnvVarInt extends _EnvVar<int> {
  /// Constructor
  const $EnvVarInt(super.name, super.fromEnvironment);

  @override
  int? parse(String? value) => value != null ? int.tryParse(value) : null;
}
