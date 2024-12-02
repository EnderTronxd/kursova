import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'database_helper.dart';
import 'history_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
      ),
      home: const LoginScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String intermediateResult = '';
  String result = '';
  bool _decimalAdded = false;

  // Функція для обчислення проміжного результату в реальному часі
  String calculateIntermediateResult(String input) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return '';
    }
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        input = '';
        intermediateResult = '';
        result = '';
        _decimalAdded = false;
      } else if (buttonText == '⌫') {
        if (input.isNotEmpty) {
          String lastChar = input[input.length - 1];
          if (lastChar == '.') {
            _decimalAdded = false;
          }
          input = input.substring(0, input.length - 1);
        }
      } else if (buttonText == '%') {
        if (input.isNotEmpty) {
          try {
            final double value = double.parse(input);
            input = (value / 100).toString();
            result = input;
          } catch (e) {
            result = 'Error';
          }
        }
      } else if (buttonText == '=') {
        if (input.isNotEmpty) {
          try {
            intermediateResult = calculateIntermediateResult(input);
            final double doubleValue = double.parse(intermediateResult);
            if (doubleValue == doubleValue.toInt()) {
              result = doubleValue.toInt().toString();
            } else {
              result = doubleValue
                  .toStringAsFixed(5)
                  .replaceAll(RegExp(r'0+$'), '')
                  .replaceAll(RegExp(r'\.$'), '');
            }

            String expressionWithResult = '$input';
            DatabaseHelper().insertHistory(expressionWithResult, result);

            input = result;
            intermediateResult = '';
          } catch (e) {
            result = 'Error';
          }
        }
      } else if (buttonText == '^2') {
        if (input.isNotEmpty) {
          try {
            final double value = double.parse(input);
            input = (value * value).toString();
            result = input;
          } catch (e) {
            result = 'Error';
          }
        }
      } else {
        final isOperator = RegExp(r'[+\-*/]').hasMatch(buttonText);

        final lastNumber = input.split(RegExp(r'[+\-*/]')).last;

        if (buttonText == '.' && lastNumber.contains('.')) {
          return;
        }

        if (input.isNotEmpty &&
            isOperator &&
            RegExp(r'[+\-*/]').hasMatch(input[input.length - 1])) {
          return;
        }

        if (input.length < 24) {
          input += buttonText;
          intermediateResult = calculateIntermediateResult(input);
          result = intermediateResult;
        }
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onButtonPressed(buttonText),
        child: Container(
          height: 80,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              input,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              result.isEmpty ? '' : '= $result',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    _buildButton('AC'),
                    _buildButton('⌫'),
                    _buildButton('%'),
                    _buildButton('/'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('*'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+'),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('^2'),  
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('='),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
