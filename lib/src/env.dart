/*
 * Copyright (c) 2026 Vladimir E. Koltunov
 * Please see the AUTHORS file for details.
 * All rights reserved.
 */

import 'package:dotenv/dotenv.dart';
import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';
import 'package:universal_io/io.dart' show Platform, File;

@Target({TargetKind.topLevelVariable})
@sealed
final class Env {
  const Env();
}

@Target({TargetKind.topLevelVariable})
@sealed
final class EnvInt {
  const EnvInt();
}

// ignore: invalid_annotation_target
@Target({TargetKind.topLevelVariable})
const env = Env();

// ignore: invalid_annotation_target
@Target({TargetKind.topLevelVariable})
const envInt = EnvInt();

abstract class EnvVar {
  final String name;
  final String fromEnvironment;

  const EnvVar(this.name, this.fromEnvironment);

  static DotEnv? env;

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
      parse(EnvVar.env?[name]) ??
      switch (fromEnvironment) {
        final String s when s.isNotEmpty => parse(s) ?? defaultValue,
        _ => defaultValue,
      };

  T? parse(String? s);
}

class EnvVarString extends _EnvVar<String> {
  const EnvVarString(super.name, super.fromEnvironment);

  @override
  String? parse(String? value) => value;
}

class EnvVarInt extends _EnvVar<int> {
  const EnvVarInt(super.name, super.fromEnvironment);

  @override
  int? parse(String? value) => value != null ? int.tryParse(value) : null;
}
