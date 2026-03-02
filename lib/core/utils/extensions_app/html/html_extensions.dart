import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

/// Extension methods for HTML parsing
extension DocumentExtensions on Document {
  /// Extract text from selector
  String getText(String selector, {String defaultValue = ''}) =>
      querySelector(selector)?.text.trim() ?? defaultValue;

  /// Extract attribute from selector
  String getAttr(String selector, String attr, {String defaultValue = ''}) =>
      querySelector(selector)?.attributes[attr] ?? defaultValue;

  /// Extract all texts from selector
  List<String> getAllTexts(String selector) => querySelectorAll(
    selector,
  ).map((e) => e.text.trim()).where((t) => t.isNotEmpty).toList();

  /// Query items and map them
  List<T> mapQuery<T>(String selector, T Function(Element e) mapper) =>
      querySelectorAll(selector).map(mapper).toList();
}

extension ElementExtensions on Element {
  /// Get attribute safely
  String attr(String key, {String defaultValue = ''}) =>
      attributes[key] ?? defaultValue;

  /// Alias for attr for consistency with Document
  String getAttr(String selector, String attr, {String defaultValue = ''}) =>
      querySelector(selector)?.attributes[attr] ?? defaultValue;

  /// Get text safely
  String getText(String selector, {String defaultValue = ''}) =>
      querySelector(selector)?.text.trim() ?? defaultValue;

  /// Get first available attribute from list
  String firstAttr(List<String> keys, {String defaultValue = ''}) {
    for (var key in keys) {
      final value = attributes[key] ?? '';
      if (value.isNotEmpty) return value;
    }
    return defaultValue;
  }

  /// Query items and map them
  List<T> mapQuery<T>(String selector, T Function(Element e) mapper) =>
      querySelectorAll(selector).map(mapper).toList();

  /// Extract all texts from selector
  List<String> getAllTexts(String selector) => querySelectorAll(
    selector,
  ).map((e) => e.text.trim()).where((t) => t.isNotEmpty).toList();
}

extension HtmlStringExtension on String {
  /// 🔹 يشيل كل HTML Tags ويطلع نص نضيف
  String toPlainText() {
    if (isEmpty) return '';

    final document = html_parser.parse(this);

    return document.body?.text
            ?.replaceAll('\t', '')
            .replaceAll(RegExp(r'\n\s*\n'), '\n\n')
            .trim() ??
        '';
  }

  /// 🔹 نفس الفكرة بس مع حماية من null
  String get plainText => toPlainText();
}

extension AdvancedHtmlStringExtension on String {
  /// 🔹 معالجة احترافية تشمل إزالة التاجات، تحويل الرموز الخاصة، والحفاظ على المسافات
  String toCleanPlainText() {
    if (this.isEmpty) return '';

    // 1. تحويل بعض التاجات لمسافات وسطور قبل الحذف لضمان عدم التصاق الكلمات
    String processed = this
        .replaceAll(
          RegExp(r'<(br|p|div|li)[^>]*>', caseSensitive: false),
          '\n',
        ) // إضافة سطر عند نهايات الفقرات
        .replaceAll(
          RegExp(r'<(td|th)[^>]*>', caseSensitive: false),
          '  ',
        ); // مسافة بين أعمدة الجداول

    // 2. التحليل (Parsing)
    final document = html_parser.parse(processed);

    // 3. استخراج النص
    String text = document.body?.text ?? '';

    // 4. معالجة الرموز الخاصة (HTML Entities)
    // مثل تحويل &nbsp; إلى مسافة حقيقية و &quot; إلى "
    text = _decodeHtmlEntities(text);

    // 5. تنظيف المسافات الزائدة والسطور الفارغة المتكررة
    return text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n')
        .trim();
  }

  /// وظيفة داخلية لمعالجة الرموز النصية الخاصة بـ HTML
  String _decodeHtmlEntities(String input) {
    return input
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&apos;', "'")
        .replaceAll('&#39;', "'");
  }

  String get fullPlainText => toCleanPlainText();
}
