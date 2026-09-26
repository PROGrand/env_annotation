# env_annotation

@env annotation generator.

## Usage

```yaml
dependencies:
  env_annotation: ^1.0.0
dev_dependencies:
  build_runner: ^2.4.0
```

Generate EnvVar consts:

```sh
dart run build_runner build
```

EnvVar first tries to get value from `Platform.environment`, then from `const String.fromEnvironment`, then from default
value.

## Example

```dart
import 'package:env_annotation/env_annotation.dart';

part 'file.g.dart';

@env
const ENV1 = _$1;

@env
const ENV2 = _$2;

@env
const ENV3 = _$ENV3;

void main() {
  EnvVar.loadEnv();
  print('${ENV1('default1')} ${ENV2('default2')} ${ENV3('default3')}');
}
```

run as:

```sh
ENV1=value1 dart run --define=ENV1=compiled2 --define=ENV2=compiled2 lib/example.dart
```

expected output:

```
value1 compiled2 default3
```

## License

MIT © Vladimir E. Koltunov (PROGrand)
