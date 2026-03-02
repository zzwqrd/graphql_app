import 'package:equatable/equatable.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final String languageCode;

  const LanguageLoaded({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}

class LanguageChanged extends LanguageState {
  final String languageCode;

  const LanguageChanged({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}

class LanguageError extends LanguageState {
  final String error;

  const LanguageError({required this.error});

  @override
  List<Object> get props => [error];
}
