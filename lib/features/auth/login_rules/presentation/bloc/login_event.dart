sealed class LoginRulesEvent {
  const LoginRulesEvent();
}

final class LoginRulesSubmitted extends LoginRulesEvent {
  final String email;
  final String password;

  const LoginRulesSubmitted({required this.email, required this.password});
}
