import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'account_database.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future<void> _deleteAccount() async {
    int deletedCount = await DatabaseHelper.instance.delete(email);
    if (deletedCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Аккаунт видалено успішно')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Помилка у видалені аккаунта')),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Підтвердження видаленя'),
          content: const Text('Ви точно хочете видалити свій аккаунт?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Назад'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Видалити'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

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
                  'Вхід',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Пошта',
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка введіть свою пошту';
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
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                  ),
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
                      var user = await DatabaseHelper.instance.getUser(email, password);
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const CalculatorScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Неправильна пошта або пароль')),
                        );
                      }
                    }
                  },
                  child: const Text('Вхід'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text('Зареєструватися'),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _showDeleteConfirmationDialog,
                  child: const Text('Видалити аккаунт'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
