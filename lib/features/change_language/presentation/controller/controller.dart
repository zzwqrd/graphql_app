// cubits/language/language_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLang = prefs.getString('languageCode') ?? 'ar';

      emit(LanguageLoaded(languageCode: savedLang));
    } catch (e) {
      emit(LanguageError(error: e.toString()));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', languageCode);

      emit(LanguageChanged(languageCode: languageCode));
    } catch (e) {
      emit(LanguageError(error: e.toString()));
    }
  }
}
