import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const SRSPlusApp());
}

class SRSPlusApp extends StatelessWidget {
  const SRSPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRS+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
      ),
      home: const SRSHome(),
    );
  }
}

// ============================================================
// تعريف بنية الأمر
// ============================================================

class SRSCommand {
  final String name;
  final String description;
  final String domain;
  final String action;

  const SRSCommand({
    required this.name,
    required this.description,
    required this.domain,
    required this.action,
  });
}

// ============================================================
// مجالات SRS+
// 20 مجالًا × 20 عملية = 400 أمر
// ============================================================

const List<Map<String, String>> srsDomains = [
  {
    'id': 'memory',
    'name': 'الذاكرة',
    'description': 'إدارة ذاكرة البرنامج وقيمه المحفوظة',
  },
  {
    'id': 'world',
    'name': 'العالم',
    'description': 'إدارة حالات العالم الافتراضي',
  },
  {
    'id': 'time',
    'name': 'الزمن',
    'description': 'إدارة الساعة الزمنية للمحاكاة',
  },
  {
    'id': 'logic',
    'name': 'المنطق',
    'description': 'تقييم العلاقات والقواعد المركبة',
  },
  {
    'id': 'data',
    'name': 'البيانات',
    'description': 'إدارة البيانات وتحويل بنيتها',
  },
  {
    'id': 'event',
    'name': 'الأحداث',
    'description': 'تسجيل الأحداث وترتيبها',
  },
  {
    'id': 'signal',
    'name': 'الإشارات',
    'description': 'إدارة الإشارات بين أجزاء المحاكاة',
  },
  {
    'id': 'state',
    'name': 'الحالة',
    'description': 'إدارة حالات التشغيل',
  },
  {
    'id': 'path',
    'name': 'المسارات',
    'description': 'إدارة مسارات التنفيذ',
  },
  {
    'id': 'rule',
    'name': 'القواعد',
    'description': 'إنشاء القواعد وتقييمها',
  },
  {
    'id': 'object',
    'name': 'الكائنات',
    'description': 'إدارة الكائنات الافتراضية',
  },
  {
    'id': 'field',
    'name': 'الحقول',
    'description': 'إدارة خصائص الكائنات',
  },
  {
    'id': 'vault',
    'name': 'الخزنة',
    'description': 'تنظيم مجموعات القيم',
  },
  {
    'id': 'map',
    'name': 'الخريطة',
    'description': 'إدارة مواقع الخريطة الافتراضية',
  },
  {
    'id': 'life',
    'name': 'الحياة',
    'description': 'إدارة خصائص الكائنات الحية في المحاكاة',
  },
  {
    'id': 'craft',
    'name': 'الصناعة',
    'description': 'إدارة المواد ووصفات التصنيع',
  },
  {
    'id': 'trade',
    'name': 'التجارة',
    'description': 'إدارة العروض والأرصدة التجارية',
  },
  {
    'id': 'quest',
    'name': 'المهام',
    'description': 'إدارة أهداف المهام وتقدمها',
  },
  {
    'id': 'sense',
    'name': 'الاستشعار',
    'description': 'إدارة القياسات وقراءات المحاكاة',
  },
  {
    'id': 'echo',
    'name': 'الأثر',
    'description': 'تسجيل آثار التنفيذ ومراجعتها',
  },
];

// ============================================================
// العمليات الأساسية
// لكل عملية اسم ووظيفة موثقة
// ============================================================

const List<Map<String, String>> srsActions = [
  {
    'id': 'seed',
    'name': 'تهيئة',
    'description': 'إنشاء قيمة أولية',
  },
  {
    'id': 'add',
    'name': 'زيادة',
    'description': 'زيادة قيمة أو إضافة عنصر',
  },
  {
    'id': 'blend',
    'name': 'مزج',
    'description': 'دمج محتويين',
  },
  {
    'id': 'erase',
    'name': 'إزالة',
    'description': 'حذف عنصر محدد',
  },
  {
    'id': 'clone',
    'name': 'استنساخ',
    'description': 'نسخ قيمة إلى مفتاح آخر',
  },
  {
    'id': 'shift',
    'name': 'نقل',
    'description': 'نقل قيمة من مفتاح إلى آخر',
  },
  {
    'id': 'seal',
    'name': 'ختم',
    'description': 'منع تعديل مفتاح محدد',
  },
  {
    'id': 'unseal',
    'name': 'فك الختم',
    'description': 'السماح بتعديل مفتاح مختوم',
  },
  {
    'id': 'check',
    'name': 'فحص',
    'description': 'التحقق من وجود قيمة',
  },
  {
    'id': 'count',
    'name': 'إحصاء',
    'description': 'حساب عناصر المجال',
  },
  {
    'id': 'sort',
    'name': 'ترتيب',
    'description': 'ترتيب العناصر',
  },
  {
    'id': 'filter',
    'name': 'تصفية',
    'description': 'اختيار العناصر المطابقة',
  },
  {
    'id': 'merge',
    'name': 'ضم',
    'description': 'ضم نطاقين من البيانات',
  },
  {
    'id': 'split',
    'name': 'تجزئة',
    'description': 'تقسيم النص إلى أجزاء',
  },
  {
    'id': 'snapshot',
    'name': 'لقطة',
    'description': 'حفظ نسخة من الحالة',
  },
  {
    'id': 'restore',
    'name': 'استرجاع',
    'description': 'استرجاع حالة محفوظة',
  },
  {
    'id': 'trace',
    'name': 'تتبّع',
    'description': 'تسجيل أثر العملية',
  },
  {
    'id': 'compare',
    'name': 'مقارنة',
    'description': 'مقارنة قيمتين',
  },
  {
    'id': 'derive',
    'name': 'اشتقاق',
    'description': 'إنشاء قيمة مشتقة',
  },
  {
    'id': 'reset',
    'name': 'إعادة ضبط',
    'description': 'إعادة المجال إلى حالته الأولية',
  },
];

// ============================================================
// إنشاء قاموس الأوامر الـ400
// ============================================================

List<SRSCommand> buildSRSCommands() {
  final commands = <SRSCommand>[];

  for (final domain in srsDomains) {
    for (final action in srsActions) {
      commands.add(
        SRSCommand(
          name: '${domain['id']}.${action['id']}',
          domain: domain['id']!,
          action: action['id']!,
          description:
              '${action['description']} ضمن مجال ${domain['name']}. '
              '${domain['description']}.',
        ),
      );
    }
  }

  return commands;
}

final List<SRSCommand> srsCommands = buildSRSCommands();

final Map<String, SRSCommand> srsCommandIndex = {
  for (final command in srsCommands) command.name: command,
};

// ============================================================
// تخزين حالة البرنامج أثناء التنفيذ
// ============================================================

class SRSRuntime {
  final Map<String, dynamic> memory = {};
  final Map<String, Map<String, dynamic>> snapshots = {};
  final Set<String> sealedKeys = {};
  final List<String> history = [];
  final Map<String, dynamic> results = {};

  void clear() {
    memory.clear();
    snapshots.clear();
    sealedKeys.clear();
    history.clear();
    results.clear();
  }

  String makeKey(String domain, String key) {
    return '$domain:$key';
  }

  dynamic parseValue(String source) {
    final text = source.trim();

    if (text.isEmpty) return '';

    if (text == 'true') return true;
    if (text == 'false') return false;
    if (text == 'null') return null;

    final number = num.tryParse(text);
    if (number != null) return number;

    try {
      return jsonDecode(text);
    } catch (_) {
      return text;
    }
  }

  List<String> splitCommand(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    String? quote;

    for (int i = 0; i < line.length; i++) {
      final character = line[i];

      if (character == '"' || character == "'") {
        if (quote == null) {
          quote = character;
        } else if (quote == character) {
          quote = null;
        } else {
          buffer.write(character);
        }
      } else if (character == ' ' && quote == null) {
        if (buffer.isNotEmpty) {
          result.add(buffer.toString());
          buffer.clear();
        }
      } else {
        buffer.write(character);
      }
    }

    if (buffer.isNotEmpty) {
      result.add(buffer.toString());
    }

    return result;
  }
}

// ============================================================
// SRS+ Interpreter
// مفسر لغة SRS+
// ============================================================

class SRSInterpreter {
  final SRSRuntime runtime;

  SRSInterpreter(this.runtime);

  String execute(
    String source, {
    String inputValue = '',
  }) {
    final output = <String>[];
    final lines = source.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.isEmpty ||
          line.startsWith('#') ||
          line.startsWith('//')) {
        continue;
      }

      try {
        final parts = runtime.splitCommand(line);

        if (parts.isEmpty) continue;

        final command = parts[0];

        // أوامر التحكم الأساسية في المحرر.
        if (command == 'say') {
          output.add(parts.skip(1).join(' '));
          continue;
        }

        if (command == 'show') {
          if (parts.length < 2) {
            throw const FormatException(
              'الصيغة: show المفتاح',
            );
          }

          final key = parts[1];
          final matches = runtime.memory.entries.where(
            (entry) =>
                entry.key == key ||
                entry.key.endsWith(':$key'),
          );

          if (matches.isEmpty) {
            output.add('$key = (غير موجود)');
          } else {
            for (final entry in matches) {
              output.add('${entry.key} = ${entry.value}');
            }
          }

          continue;
        }

        if (command == 'ask') {
          if (parts.length < 2) {
            throw const FormatException(
              'الصيغة: ask المفتاح',
            );
          }

          final key = parts[1];
          runtime.memory['input:$key'] = inputValue;
          output.add('$key = $inputValue');
          continue;
        }

        if (command == 'help') {
          output.add(
            'تضم SRS+ عدد ${srsCommands.length} أمرًا مسجلًا.',
          );
          output.add(
            'الصيغة العامة: المجال.العملية المفتاح القيمة',
          );
          output.add(
            'مثال: memory.seed score 25',
          );
          continue;
        }

        if (command == 'commands') {
          output.add('عدد الأوامر: ${srsCommands.length}');
          for (final item in srsCommands) {
            output.add('${item.name} — ${item.description}');
          }
          continue;
        }

        // التحقق من وجود الأمر في القاموس.
        final spec = srsCommandIndex[command];

        if (spec == null) {
          throw FormatException(
            'الأمر "$command" غير معروف.',
          );
        }

        if (parts.length < 2 &&
            spec.action != 'count' &&
            spec.action != 'reset') {
          throw FormatException(
            'الأمر $command يحتاج إلى مفتاح.',
          );
        }

        final keyName = parts.length > 1
            ? parts[1]
            : 'main';

        final key = runtime.makeKey(
          spec.domain,
          keyName,
        );

        final argument = parts.length > 2
            ? parts.skip(2).join(' ')
            : '';

        final current = runtime.memory[key];

        String targetKey(String name) {
          return runtime.makeKey(spec.domain, name);
        }

        num numberOf(dynamic value) {
          if (value is num) return value;
          return num.tryParse('$value') ?? 0;
        }

        // تنفيذ العملية المطلوبة.
        switch (spec.action) {
          case 'seed':
            if (runtime.sealedKeys.contains(key)) {
              throw StateError(
                'المفتاح $key مختوم ولا يمكن تعديله.',
              );
            }

            runtime.memory[key] =
                runtime.parseValue(argument);

            output.add(
              '$command: تم إنشاء $key = '
              '${runtime.memory[key]}',
            );
            break;

          case 'add':
            if (runtime.sealedKeys.contains(key)) {
              throw StateError('المفتاح مختوم.');
            }

            if (current is List) {
              current.add(runtime.parseValue(argument));
            } else if (current is num ||
                current == null ||
                num.tryParse('$current') != null) {
              runtime.memory[key] =
                  numberOf(current) +
                  numberOf(runtime.parseValue(argument));
            } else {
              runtime.memory[key] =
                  '$current$argument';
            }

            output.add(
              '$command: الناتج ${runtime.memory[key]}',
            );
            break;

          case 'blend':
            if (runtime.sealedKeys.contains(key)) {
              throw StateError('المفتاح مختوم.');
            }

            final incoming = runtime.parseValue(argument);

            if (current is Map && incoming is Map) {
              runtime.memory[key] = {
                ...current,
                ...incoming,
              };
            } else if (current is List) {
              current.add(incoming);
            } else if (current == null) {
              runtime.memory[key] = incoming;
            } else {
              runtime.memory[key] = '$current$incoming';
            }

            output.add('$command: اكتمل المزج.');
            break;

          case 'erase':
            if (runtime.sealedKeys.contains(key)) {
              throw StateError(
                'فك الختم قبل إزالة هذا المفتاح.',
              );
            }

            runtime.memory.remove(key);
            output.add('$command: تمت الإزالة.');
            break;

          case 'clone':
            if (parts.length < 3) {
              throw const FormatException(
                'الصيغة: المجال.clone المصدر الوجهة',
              );
            }

            final sourceKey = targetKey(parts[1]);
            final destinationKey = targetKey(parts[2]);

            if (runtime.sealedKeys.contains(destinationKey)) {
              throw StateError('المفتاح الهدف مختوم.');
            }

            if (!runtime.memory.containsKey(sourceKey)) {
              throw StateError('المصدر غير موجود: $sourceKey');
            }

            runtime.memory[destinationKey] =
                runtime.memory[sourceKey];

            output.add(
              '$command: تم نسخ $sourceKey إلى $destinationKey',
            );
            break;

          case 'shift':
            if (parts.length < 3) {
              throw const FormatException(
                'الصيغة: المجال.shift المصدر الوجهة',
              );
            }

            final sourceKey = targetKey(parts[1]);
            final destinationKey = targetKey(parts[2]);

            if (runtime.sealedKeys.contains(sourceKey) ||
                runtime.sealedKeys.contains(destinationKey)) {
              throw StateError(
                'لا يمكن نقل قيمة من مفتاح مختوم أو إليه.',
              );
            }

            if (!runtime.memory.containsKey(sourceKey)) {
              throw StateError('المصدر غير موجود.');
            }

            runtime.memory[destinationKey] =
                runtime.memory.remove(sourceKey);

            output.add('$command: تم نقل القيمة.');
            break;

          case 'seal':
            runtime.sealedKeys.add(key);
            output.add('$command: تم ختم $key');
            break;

          case 'unseal':
            runtime.sealedKeys.remove(key);
            output.add('$command: فُك ختم $key');
            break;

          case 'check':
            final exists = runtime.memory.containsKey(key);
            runtime.results[command] = exists;

            output.add('$command: $exists');
            break;

          case 'count':
            final count = runtime.memory.keys
                .where((k) => k.startsWith('${spec.domain}:'))
                .length;

            runtime.results[command] = count;
            output.add('$command: العدد $count');
            break;

          case 'sort':
            if (current is List) {
              current.sort(
                (a, b) => '$a'.compareTo('$b'),
              );

              output.add('$command: تم ترتيب القائمة.');
            } else {
              final keys = runtime.memory.keys
                  .where(
                    (k) => k.startsWith('${spec.domain}:'),
                  )
                  .toList()
                ..sort();

              output.add(
                '$command: ${keys.join(', ')}',
              );
            }
            break;

          case 'filter':
            if (current is List) {
              current.removeWhere(
                (value) => !'$value'.contains(argument),
              );

              output.add(
                '$command: بقي ${current.length} عنصرًا.',
              );
            } else {
              final matching = runtime.memory.entries
                  .where(
                    (entry) =>
                        entry.key.startsWith(
                          '${spec.domain}:',
                        ) &&
                        '${entry.value}'.contains(argument),
                  )
                  .toList();

              output.add(
                '$command: ${matching.map((e) => '${e.key}=${e.value}').join(', ')}',
              );
            }
            break;

          case 'merge':
            if (parts.length < 3) {
              throw const FormatException(
                'الصيغة: المجال.merge المفتاح مفتاح_آخر',
              );
            }

            final otherKey = targetKey(parts[2]);
            final other = runtime.memory[otherKey];

            if (current is Map && other is Map) {
              runtime.memory[key] = {
                ...current,
                ...other,
              };
            } else if (current is List && other is List) {
              runtime.memory[key] = [
                ...current,
                ...other,
              ];
            } else {
              runtime.memory[key] =
                  '${current ?? ''}${other ?? ''}';
            }

            output.add('$command: اكتمل الضم.');
            break;

          case 'split':
            final text = current?.toString() ?? argument;
            final separator = argument.isEmpty
                ? ' '
                : argument;

            runtime.memory[key] = text.split(separator);

            output.add(
              '$command: ${jsonEncode(runtime.memory[key])}',
            );
            break;

          case 'snapshot':
            runtime.snapshots[spec.domain] = {
              for (final entry in runtime.memory.entries)
                if (entry.key.startsWith('${spec.domain}:'))
                  entry.key: entry.value,
            };

            output.add(
              '$command: تم حفظ لقطة المجال.',
            );
            break;

          case 'restore':
            final snapshot =
                runtime.snapshots[spec.domain];

            if (snapshot == null) {
              output.add(
                '$command: لا توجد لقطة محفوظة.',
              );
              break;
            }

            runtime.memory.removeWhere(
              (k, v) => k.startsWith('${spec.domain}:'),
            );

            runtime.memory.addAll(snapshot);

            output.add(
              '$command: تمت استعادة اللقطة.',
            );
            break;

          case 'trace':
            final message = argument.isEmpty
                ? '$key = $current'
                : argument;

            runtime.history.add(
              '${DateTime.now().toIso8601String()} '
              '| $command | $message',
            );

            output.add('$command: تم تسجيل الأثر.');
            break;

          case 'compare':
            final other = parts.length > 2
                ? runtime.memory[targetKey(parts[2])]
                : runtime.parseValue(argument);

            final equal = current == other;

            runtime.results[command] = equal;

            output.add(
              '$command: ${equal ? 'متساويان' : 'مختلفان'}',
            );
            break;

          case 'derive':
            final parsed = num.tryParse('$current');
            final factor =
                num.tryParse(argument) ?? 2;

            if (parsed != null) {
              runtime.memory[key] = parsed * factor;
            } else {
              runtime.memory[key] =
                  '${current ?? ''}$argument';
            }

            output.add(
              '$command: ${runtime.memory[key]}',
            );
            break;

          case 'reset':
            runtime.memory.removeWhere(
              (k, v) => k.startsWith('${spec.domain}:'),
            );

            runtime.sealedKeys.removeWhere(
              (k) => k.startsWith('${spec.domain}:'),
            );

            output.add(
              '$command: تمت إعادة ضبط المجال.',
            );
            break;

          default:
            output.add(
              '$command: الاسم موجود، '
              'لكن العملية لم تُنفّذ بعد.',
            );
        }
      } catch (error) {
        output.add(
          'السطر ${i + 1}: $error',
        );
      }
    }

    return output.isEmpty
        ? 'انتهى التنفيذ دون مخرجات.'
        : output.join('\n');
  }
}

class SRSHome extends StatefulWidget {
  const SRSHome({super.key});

  @override
  State<SRSHome> createState() => _SRSHomeState();
}

class _SRSHomeState extends State<SRSHome> {
  final TextEditingController _editorController =
      TextEditingController();

  final TextEditingController _searchController =
      TextEditingController();

  final TextEditingController _inputController =
      TextEditingController();

  final ScrollController _outputScrollController =
      ScrollController();

  final SRSRuntime _runtime = SRSRuntime();

  late final SRSInterpreter _interpreter;

  String _output = '';
  String _searchText = '';
  String _fileName = 'program.srs';
  String _status = 'جاهز';
  bool _isRunning = false;
  bool _showDictionary = false;
  bool _showHelp = false;

  List<SRSCommand> get _filteredCommands {
    final query = _searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return srsCommands;
    }

    return srsCommands.where((command) {
      return command.name.toLowerCase().contains(query) ||
          command.description.toLowerCase().contains(query) ||
          command.domain.toLowerCase().contains(query) ||
          command.action.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    _interpreter = SRSInterpreter(_runtime);

    _editorController.text = '''# برنامج SRS+ التجريبي

say "مرحباً بك في لغة SRS+"

memory_seed 10
memory_add 5
memory_show

say "انتهى البرنامج"
''';
  }

  @override
  void dispose() {
    _editorController.dispose();
    _searchController.dispose();
    _inputController.dispose();
    _outputScrollController.dispose();
    super.dispose();
  }

  void _appendOutput(String text) {
    if (!mounted) return;

    setState(() {
      _output += '$text\n';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_outputScrollController.hasClients) {
        _outputScrollController.animateTo(
          _outputScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _runProgram() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _output = '';
      _status = 'جارٍ التنفيذ...';
    });

    try {
      _runtime.clear();

      final source = _editorController.text;
      final lines = const LineSplitter().convert(source);

      _appendOutput('SRS+ Runtime');
      _appendOutput('─' * 28);

      for (var index = 0; index < lines.length; index++) {
        if (!mounted) return;

        final originalLine = lines[index];
        final line = originalLine.trim();

        if (line.isEmpty || line.startsWith('#')) {
          continue;
        }

        try {
          _interpreter.execute(line);
        } catch (error) {
          _appendOutput(
            'خطأ في السطر ${index + 1}: $error',
          );
        }
      }

      _runtime.results.forEach((key, value) {
        _appendOutput('$key: $value');
        });

      if (_runtime.results.isEmpty && _output.trim().isEmpty) {
        _appendOutput('تم التنفيذ دون نتائج ظاهرة.');
      }

      if (mounted) {
        setState(() {
          _status = 'اكتمل التنفيذ';
        });
      }
    } catch (error) {
      _appendOutput('خطأ: $error');

      if (mounted) {
        setState(() {
          _status = 'حدث خطأ';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  void _clearEditor() {
    setState(() {
      _editorController.clear();
      _output = '';
      _status = 'تم مسح المحرر';
    });
  }

  void _clearOutput() {
    setState(() {
      _output = '';
      _status = 'تم مسح النتائج';
    });
  }

  Future<void> _openFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['srs', 'txt'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      final bytes = file.bytes;

      if (bytes == null) {
        _showMessage(
          'تعذرت قراءة الملف. حاول اختيار الملف مرة أخرى.',
        );
        return;
      }

      final content = utf8.decode(
        bytes,
        allowMalformed: true,
      );

      setState(() {
        _editorController.text = content;
        _fileName = file.name;
        _status = 'تم فتح ${file.name}';
      });

      _showMessage('تم فتح الملف بنجاح.');
    } catch (error) {
      _showMessage('تعذر فتح الملف: $error');
    }
  }

  Future<void> _saveFile() async {
    try {
      var suggestedName = _fileName.trim();

      if (suggestedName.isEmpty) {
        suggestedName = 'program.srs';
      }

      if (!suggestedName.toLowerCase().endsWith('.srs')) {
        suggestedName = '$suggestedName.srs';
      }

      final bytes = utf8.encode(_editorController.text);

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'حفظ مشروع SRS+',
        fileName: suggestedName,
        type: FileType.custom,
        allowedExtensions: ['srs'],
        bytes: bytes,
      );

      if (savedPath == null) {
        _showMessage('تم إلغاء الحفظ.');
        return;
      }

      setState(() {
        _fileName = savedPath.split('/').last;
        _status = 'تم حفظ الملف';
      });

      _showMessage('تم إرسال الملف للحفظ بنجاح.');
    } catch (error) {
      _showMessage('تعذر حفظ الملف: $error');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  void _insertCommand(SRSCommand command) {
    final current = _editorController.text;
    final selection = _editorController.selection;

    final insertion = '${command.name} ';

    if (selection.isValid &&
        selection.start >= 0 &&
        selection.end >= selection.start &&
        selection.end <= current.length) {
      final updated = current.replaceRange(
        selection.start,
        selection.end,
        insertion,
      );

      _editorController.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(
          offset: selection.start + insertion.length,
        ),
      );
    } else {
      _editorController.text = '$current\n$insertion';
      _editorController.selection = TextSelection.collapsed(
        offset: _editorController.text.length,
      );
    }

    setState(() {
      _showDictionary = false;
      _status = 'أُضيف الأمر ${command.name}';
    });
  }

  void _insertExample() {
    const example = '''# مثال على لغة SRS+

say "بدء البرنامج"

memory_seed 100
memory_add 25
memory_show

say "انتهى المثال"
''';

    setState(() {
      _editorController.text = example;
      _editorController.selection = TextSelection.collapsed(
        offset: example.length,
      );
      _status = 'تم إدراج المثال';
    });
  }

  void _showInputDialog() {
    _inputController.clear();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('إدخال قيمة'),
          content: TextField(
            controller: _inputController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'القيمة',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) {
              Navigator.pop(dialogContext);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                final value = _inputController.text;
                _appendOutput('إدخال المستخدم: $value');
                Navigator.pop(dialogContext);
              },
              child: const Text('إرسال'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'SRS+',
      applicationVersion: '1.0.0',
      applicationLegalese: 'لغة برمجة تجريبية تعمل محلياً.',
      children: const [
        SizedBox(height: 12),
        Text(
          'يوفر التطبيق محرراً لكتابة برامج SRS، '
          'وتشغيل الأوامر المدعومة، واستعراض قاموس الأوامر، '
          'وفتح ملفات البرامج وحفظها.',
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.terminal,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SRS+',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'معلومات التطبيق',
            onPressed: _showAboutDialog,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      child: Row(
        children: [
          FilledButton.icon(
            onPressed: _isRunning ? null : _runProgram,
            icon: Icon(
              _isRunning ? Icons.hourglass_top : Icons.play_arrow,
            ),
            label: Text(_isRunning ? 'جارٍ التشغيل' : 'تشغيل'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _openFile,
            icon: const Icon(Icons.folder_open),
            label: const Text('فتح'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _saveFile,
            icon: const Icon(Icons.save_outlined),
            label: const Text('حفظ'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _insertExample,
            icon: const Icon(Icons.code),
            label: const Text('مثال'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _showDictionary = !_showDictionary;
                _showHelp = false;
              });
            },
            icon: const Icon(Icons.menu_book),
            label: const Text('الأوامر'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _showHelp = !_showHelp;
                _showDictionary = false;
              });
            },
            icon: const Icon(Icons.help_outline),
            label: const Text('المساعدة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Row(
            children: [
              const Icon(Icons.edit_note, size: 22),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'محرر البرامج',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'مسح المحرر',
                onPressed: _clearEditor,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF11151C)
                  : const Color(0xFFF4F6F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: TextField(
              controller: _editorController,
              expands: true,
              minLines: null,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                hintText: 'اكتب أوامر SRS هنا...',
                contentPadding: EdgeInsets.all(14),
                border: InputBorder.none,
                alignLabelWithHint: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutput() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF101820),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal,
                  color: Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'النتائج',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _clearOutput,
                  child: const Text('مسح'),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.white24,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _outputScrollController,
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                _output.isEmpty
                    ? 'ستظهر نتائج التنفيذ هنا.'
                    : _output,
                style: const TextStyle(
                  color: Color(0xFFB7F7C1),
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDictionary() {
    final commands = _filteredCommands;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن أمر أو مجال...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchText.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchText = '';
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'قاموس الأوامر',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text('${commands.length} أمر'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: commands.isEmpty
              ? const Center(
                  child: Text('لا توجد أوامر مطابقة للبحث.'),
                )
              : ListView.separated(
                  itemCount: commands.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final command = commands[index];

                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.code, size: 21),
                      title: Text(
                        command.name,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${command.description}\n'
                        'المجال: ${command.domain} | '
                        'العملية: ${command.action}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        tooltip: 'إضافة إلى المحرر',
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _insertCommand(command),
                      ),
                      onTap: () => _insertCommand(command),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHelp() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'دليل SRS+',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'SRS+ لغة برمجة تجريبية تعتمد على كتابة الأوامر '
          'في أسطر، ثم تنفيذها من داخل التطبيق.',
        ),
        const SizedBox(height: 18),
        const Text(
          '1. كتابة أمر',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const SelectableText(
          'say "مرحباً"\n'
          'memory_seed 10\n'
          'memory_add 5\n'
          'memory_show',
          style: TextStyle(fontFamily: 'monospace'),
        ),
        const SizedBox(height: 18),
        const Text(
          '2. التعليقات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const SelectableText(
          '# هذا سطر تعليق ولا يُنفذ',
          style: TextStyle(fontFamily: 'monospace'),
        ),
        const SizedBox(height: 18),
        const Text(
          '3. تشغيل البرنامج',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'ارجع إلى المحرر واضغط تشغيل. ستظهر النتائج '
          'في نافذة النتائج أسفل المحرر.',
        ),
        const SizedBox(height: 18),
        const Text(
          '4. فتح الملفات وحفظها',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'استخدم فتح لاستيراد ملف بامتداد .srs أو .txt، '
          'واستخدم حفظ لتصدير البرنامج إلى ملف .srs.',
        ),
        const SizedBox(height: 18),
        const Text(
          '5. قاموس الأوامر',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'افتح قسم الأوامر للبحث في القاموس. يمكنك الضغط '
          'على أي أمر لإضافته إلى المحرر.',
        ),
        const SizedBox(height: 18),
        const Text(
          'ملاحظة: وجود الأمر في القاموس لا يعني بالضرورة '
          'أن له تنفيذًا مستقلًا متقدمًا؛ التنفيذ الفعلي '
          'يعتمد على العمليات التي يدعمها المفسّر.',
        ),
      ],
    );
  }

  Widget _buildWorkspace() {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: _buildEditor(),
        ),
        SizedBox(
          height: 30,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainer,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            child: Text(
              _status,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: _buildOutput(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildActionBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _showDictionary
                    ? KeyedSubtree(
                        key: const ValueKey('dictionary'),
                        child: _buildDictionary(),
                      )
                    : _showHelp
                        ? KeyedSubtree(
                            key: const ValueKey('help'),
                            child: _buildHelp(),
                          )
                        : KeyedSubtree(
                            key: const ValueKey('workspace'),
                            child: _buildWorkspace(),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}