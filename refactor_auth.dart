import 'dart:io';

void main() async {
  final fileMap = {
    'login.dart': 'login_view.dart',
    'register.dart': 'register_view.dart',
    'register_step2.dart': 'register_step2_view.dart',
    'lupa_sandi.dart': 'lupa_sandi_view.dart',
    'verifikasi_email.dart': 'verifikasi_email_view.dart',
  };

  // 1. Create directories
  final dirs = ['views', 'controllers', 'services', 'models', 'widgets'];
  for (final d in dirs) {
    final dir = Directory('lib/auth/$d');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  // 2. Move & Rename files
  for (final entry in fileMap.entries) {
    final file = File('lib/auth/${entry.key}');
    if (file.existsSync()) {
      file.renameSync('lib/auth/views/${entry.value}');
    }
  }

  // 3. Rewrite imports across the entire project
  final allFiles = Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
  
  for (final file in allFiles) {
    String content = file.readAsStringSync();
    bool changed = false;
    
    for (final entry in fileMap.entries) {
      final oldName = entry.key;
      final newName = entry.value;
      
      // Update package imports
      final regex1 = RegExp('import\\s+[\'"]package:flutter_application_1/auth/$oldName[\'"]\\s*;');
      if (regex1.hasMatch(content)) {
        content = content.replaceAll(regex1, "import 'package:flutter_application_1/auth/views/$newName';");
        changed = true;
      }
      
      // Also check for relative imports within the same old directory (e.g., import 'register.dart';)
      final regex2 = RegExp('import\\s+[\'"]$oldName[\'"]\\s*;');
      if (regex2.hasMatch(content)) {
        // Since they are all moved to views/ together, relative imports between them just need the new name
        // Wait, if a file outside `auth` had `import 'auth/login.dart'`, this regex wouldn't catch it, 
        // but `flutter_application_1/auth/login.dart` covers absolute. 
        // If they had `import '../auth/login.dart'`, that might be missed.
        // Let's replace any `import '.../auth/login.dart'`
        content = content.replaceAllMapped(RegExp('import\\s+[\'"](.*)$oldName[\'"]\\s*;'), (match) {
           final prefix = match.group(1)!;
           if (prefix.endsWith('auth/')) {
             return "import '${prefix}views/$newName';";
           } else if (prefix == '') {
             // same directory, now both in views/
             return "import '$newName';";
           } else {
             return match.group(0)!; // leave untouched if it doesn't match expected pattern
           }
        });
        changed = true;
      }
    }
    
    if (changed) {
      file.writeAsStringSync(content);
    }
  }
  
  print('Auth refactoring complete.');
}
