import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env가 없더라도 앱은 실행되도록 (키 미설정 시 폴백 동작)
    debugPrint('[ENV] .env 로드 실패: $e');
  }
  await initializeDateFormatting('ko');
  await initFirebase();
  runApp(const ProviderScope(child: MomsTimeApp()));
}
