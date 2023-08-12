part of 'sign_up_page.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Registro exitoso!')),
            );
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Ups! Ocurrió un error inesperado, inténtalo otra vez.',
                ),
              ),
            );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NameInput(),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(flex: 2, child: _BirthDateInput()),
              const SizedBox(width: 8),
              Flexible(child: _GenreInput()),
            ],
          ),
          const SizedBox(height: 16),
          _UsernameInput(),
          const SizedBox(height: 16),
          _EmailInput(),
          const SizedBox(height: 16),
          _PasswordInput(),
          const SizedBox(height: 16),
          _ConfirmPasswordInput(),
          const SizedBox(height: 32),
          _SignUpButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            errorText: state.email.invalid ? 'Correo inválido' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            errorText: state.password.invalid
                ? '''
Tu contraseña debe contener:
- Al menos un número
- Al menos una letra
- 8 caracteres'''
                : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          onChanged: (confirmPassword) => context
              .read<SignUpCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirma tu contraseña',
            errorText: state.confirmedPassword.invalid
                ? 'Las contraseñas no coinciden'
                : null,
          ),
        );
      },
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_nameInput_textField'),
          onChanged: (name) => context.read<SignUpCubit>().nameChanged(name),
          decoration: InputDecoration(
            labelText: 'Nombre',
            errorText: state.name.invalid
                ? 'Debe contener al menos 3 caracteres'
                : null,
          ),
        );
      },
    );
  }
}

class _BirthDateInput extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.birthdate != current.birthdate,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_birthdateInput_textField'),
          controller: controller,
          onTap: () async {
            final birthdate = await showDatePicker(
              context: context,
              initialDate: state.birthdate.value ?? DateTime.now(),
              firstDate: DateTime(DateTime.now().year - 100),
              lastDate: DateTime.now(),
            );

            // ignore: use_build_context_synchronously
            context.read<SignUpCubit>().birthdateChanged(birthdate);
            if (birthdate != null) {
              controller.text =
                  '${birthdate.day}/${birthdate.month}/${birthdate.year}';
            }
          },
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Fecha de nacimiento',
            hintText: 'DD/MM/AAAA',
            errorText: state.birthdate.invalid
                ? state.birthdate.error?.errorMessage
                : null,
          ),
        );
      },
    );
  }
}

class _GenreInput extends StatefulWidget {
  final genreOptions = <String>['Prefiero no decirlo', 'Femenino', 'Masculino'];

  @override
  State<_GenreInput> createState() => _GenreInputState();
}

class _GenreInputState extends State<_GenreInput> {
  late String value;

  @override
  void initState() {
    super.initState();
    value = widget.genreOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.birthdate != current.birthdate,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Género',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: AppColors.flushOrange.shade700),
            ),
            DropdownButton<String>(
              key: const Key('signUpForm_genreInput_dropdown'),
              value: value,
              icon: Icon(MdiIcons.chevronDown),
              isExpanded: true,
              style: Theme.of(context).textTheme.caption,
              elevation: 4,
              onChanged: (genre) {
                genre ??= widget.genreOptions.first;
                context.read<SignUpCubit>().genreChanged(genre);
                setState(() {
                  value = genre!;
                });
              },
              items: widget.genreOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<SignUpCubit>().usernameChanged(username),
          decoration: InputDecoration(
            labelText: 'Nombre de usuario',
            errorText: state.username.invalid
                // ignore: lines_longer_than_80_chars
                ? 'No debe contener espacios ni caracteres\nespeciales además de ._'
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('signUpForm_continue_raisedButton'),
                  onPressed: state.status.isValidated
                      ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                      : null,
                  child: const Text('LISTO!'),
                ),
              );
      },
    );
  }
}
