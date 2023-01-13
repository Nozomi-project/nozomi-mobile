import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid,

  /// Password is empty error.
  empty
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordRegExp =
      RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d.ñ!#$%&'*+-\/=?^_`{|}~@]{8,}$");

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null) return PasswordValidationError.empty;

    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}
