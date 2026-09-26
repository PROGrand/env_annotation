/*
 * Copyright (c) 2026 Vladimir E. Koltunov
 * Please see the AUTHORS file for details.
 * All rights reserved.
 */

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'env.dart';

abstract class _EnvGeneratorBase<T> extends GeneratorForAnnotation<T> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! TopLevelVariableElement) {
      throw InvalidGenerationSourceError(
        '@Env can only be applied to top-level variables',
        element: element,
      );
    }
    final envName = element.name;
    final node = await buildStep.resolver.astNodeFor(element.firstFragment);
    if (node is! VariableDeclaration) {
      throw InvalidGenerationSourceError(
        'Expected VariableDeclaration for ${element.name}',
        element: element,
      );
    }
    final initializer = node.initializer;
    if (initializer is! SimpleIdentifier) {
      throw InvalidGenerationSourceError(
        'Expected simple identifier initializer for ${element.name}',
        element: element,
      );
    }
    final rhsName = initializer.name;
    return gen(rhsName, envName);
  }

  String gen(String rhsName, String? envName);
}

class EnvStringGenerator extends _EnvGeneratorBase<Env> {
  @override
  String gen(String rhsName, String? envName) =>
      'const $rhsName = EnvVarString(\'$envName\', String.fromEnvironment(\'$envName\'));';
}

class EnvIntGenerator extends _EnvGeneratorBase<EnvInt> {
  @override
  String gen(String rhsName, String? envName) =>
      'const $rhsName = EnvVarInt(\'$envName\', String.fromEnvironment(\'$envName\'));';
}
