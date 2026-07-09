import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiClient {
  GeminiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;
  String? _cachedResolvedModel;

  String? get _apiKey {
    final key = dotenv.env['GEMINI_API_KEY']?.trim();
    return (key == null || key.isEmpty) ? null : key;
  }

  int get _maxOutputTokens {
    final raw = dotenv.env['GEMINI_MAX_TOKENS']?.trim();
    final v = int.tryParse(raw ?? '');
    // 너무 크게 올리면 느려질 수 있어 상한/하한을 둡니다.
    if (v != null) return v.clamp(256, 2048);
    return 1024;
  }

  String _normalizeModel(String model) {
    final m = model.trim();
    if (m.startsWith('models/')) return m.substring('models/'.length);
    return m;
  }

  List<String> get _modelCandidates {
    final envModel = dotenv.env['GEMINI_MODEL']?.trim();
    return [
      if (envModel != null && envModel.isNotEmpty) envModel,
      // API/계정 설정에 따라 지원 모델명이 달라질 수 있어, 404면 순차 재시도
      'gemini-2.0-flash',
      'gemini-2.0-flash-lite',
      'gemini-1.5-flash-latest',
      'gemini-1.5-pro-latest',
    ];
  }

  Future<String?> _resolveModelFromApi(String apiKey) async {
    // v1beta에서 모델명이 안 맞는 케이스가 많아서, 실제 지원 모델을 조회해 선택
    for (final version in const ['v1', 'v1beta']) {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/$version/models?key=$apiKey',
      );
      try {
        final res = await _http.get(uri);
        if (res.statusCode < 200 || res.statusCode >= 300) {
          debugPrint('[Gemini] listModels http ${res.statusCode}: ${res.body}');
          continue;
        }
        final map = jsonDecode(res.body);
        final list = map['models'];
        if (list is! List) continue;
        for (final item in list) {
          if (item is! Map) continue;
          final name = item['name']?.toString();
          if (name == null || name.isEmpty) continue;
          final methods = item['supportedGenerationMethods'];
          if (methods is List &&
              methods.map((e) => e.toString()).contains('generateContent')) {
            return _normalizeModel(name);
          }
        }
      } catch (e) {
        debugPrint('[Gemini] listModels 실패: $e');
      }
    }
    return null;
  }

  Future<String?> generateText({
    required String prompt,
    String? model,
  }) async {
    final key = _apiKey;
    if (key == null) return null;

    final models = [
      if (model?.trim().isNotEmpty == true) model!.trim(),
      if (_cachedResolvedModel?.trim().isNotEmpty == true)
        _cachedResolvedModel!.trim(),
      ..._modelCandidates,
    ];

    // 먼저 env/캐시/후보 모델로 빠르게 시도, 404면 listModels로 실제 지원 모델을 찾아 재시도
    final tried = <String>{};

    Future<String?> tryModel(String m, String version) async {
      final normalized = _normalizeModel(m);
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/$version/models/$normalized:generateContent?key=$key',
      );
      final res = await _http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt}
              ],
            }
          ],
          'generationConfig': {
            'temperature': 0.6,
            'maxOutputTokens': _maxOutputTokens,
          },
        }),
      );

      if (res.statusCode == 404) {
        debugPrint('[Gemini] model not found ($version): $normalized');
        return null;
      }
      if (res.statusCode < 200 || res.statusCode >= 300) {
        debugPrint('[Gemini] http ${res.statusCode} ($version/$normalized): ${res.body}');
        return null;
      }
      final map = jsonDecode(res.body);
      final text = map['candidates']?[0]?['content']?['parts']?[0]?['text'];
      final s = text?.toString().trim();
      if (s == null || s.isEmpty) return null;
      _cachedResolvedModel = normalized;
      return s;
    }

    try {
      for (final m in models.toSet()) {
        if (m.trim().isEmpty) continue;
        final nm = _normalizeModel(m);
        if (tried.contains(nm)) continue;
        tried.add(nm);
        // v1 먼저 시도 → v1beta
        final v1 = await tryModel(nm, 'v1');
        if (v1 != null) return v1;
        final v1b = await tryModel(nm, 'v1beta');
        if (v1b != null) return v1b;
      }

      final resolved = await _resolveModelFromApi(key);
      if (resolved != null && !tried.contains(resolved)) {
        final v1 = await tryModel(resolved, 'v1');
        if (v1 != null) return v1;
        final v1b = await tryModel(resolved, 'v1beta');
        if (v1b != null) return v1b;
      }
    } catch (e) {
      debugPrint('[Gemini] 호출 실패: $e');
      return null;
    }
    return null;
  }
}

