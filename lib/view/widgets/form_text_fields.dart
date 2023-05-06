import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class PasswordTextFormField extends StatefulWidget {
  final Function(String) onChanged;
  const PasswordTextFormField({
    super.key,
    required this.onChanged,
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () => _togglePasswordVisibility(),
        ),
      ),
      onChanged: (value) {
        // password = value;
        widget.onChanged(value);
      },
      validator: (value) {
        if (!RegExp(AppConstants.passwordRegex).hasMatch(value!)) {
          return 'Password must contain at least 8 characters, including at least one letter and one digit';
        }
        return null;
      },
    );
  }
}

class UserNameTextFormField extends StatelessWidget {
  final String Function(String value) onChanged;
  const UserNameTextFormField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your name',
        prefixIcon: Icon(Icons.person),
      ),
      onChanged: (value) => onChanged(value),
      validator: (value) {
        final RegExp nameRegExp = RegExp(AppConstants.nameRegex);
        if (value == null || value.isEmpty || !nameRegExp.hasMatch(value)) {
          return 'Please a valid name';
        } else if (value.length < 3) {
          return 'Name must be at least 3 characters';
        }

        return null;
      },
    );
  }
}

class EmailTextFormField extends StatelessWidget {
  final String Function(String value) onChanged;
  const EmailTextFormField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email),
      ),
      onChanged: (value) => onChanged(value),
      validator: (value) {
        if (!RegExp(AppConstants.emailRegex).hasMatch(value!)) {
          return 'Please a valid email';
        }
        // if (value == null || value.isEmpty || value.trim() == '') {
        //   return 'email cannot be empty';
        // } else if (value.contains('@') == false ||
        //     value.contains('.') == false) {
        //   return 'Please enter a valid email';
        // } else if (value.length < 3) {
        //   return 'email must be at least 3 characters';
        // } else if (value.contains('-')) {
        //   return 'email cannot contain -';
        // }
        return null;
      },
    );
  }
}
