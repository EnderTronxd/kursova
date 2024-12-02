import 'package:flutter/material.dart';
import 'account_database.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 80),
                Text(
                  'Зареєструватися',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Імя'),
                  onChanged: (value) {
                    username = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка введіть ваше імя';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Пошта'),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка введіть вашу пошту';
                    }
                    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegExp.hasMatch(value)) {
                      return 'Будь ласка введіть правильну пошту';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка введіть свій пароль';
                    }
                    if (value.length < 7) {
                      return 'Пароль потрібен бути не менше 7 символів';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Save user to database
                      var row = {
                        DatabaseHelper.columnEmail: email,
                        DatabaseHelper.columnPassword: password,
                      };
                      await DatabaseHelper.instance.insert(row);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Зареєструватися'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Назад до Входу'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
