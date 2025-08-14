import 'package:calculator/models/history_model.dart';
import 'package:calculator/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';

  void onButtonPressed(String value) {
  setState(() {
    if (value == '=') {
      final result = evaluateExpression(input);
      final fullExpression = '$input = $result';

      // Add to history only if result is not 'Error'
      if (result != 'Error') {
        Provider.of<HistoryModel>(context, listen: false).addEntry(fullExpression);
      }

      input = result;
    } else if (value == 'C') {
      input = '';
    } else if (value == '⌫') {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else {
      // If currently showing Error and user presses digit or '.', clear input first
      if (input == 'Error' && ('0123456789.'.contains(value))) {
        input = value;
      } else {
        input += value;
      }
    }
  });
}



  String evaluateExpression(String expr) {
    try {
      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
      final result = _simpleEvaluate(expr);
      if (result == result.toInt()) {
        return result.toInt().toString();
      }
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  double _simpleEvaluate(String expr) {
    final tokens = <String>[];
    String numberBuffer = '';

    for (var char in expr.split('')) {
      if ('0123456789.'.contains(char)) {
        numberBuffer += char;
      } else if ('+-*/'.contains(char)) {
        if (numberBuffer.isEmpty) {
          if (char == '-' && (tokens.isEmpty || '+-*/'.contains(tokens.last))) {
            numberBuffer = '-';
            continue;
          } else {
            throw Exception('Invalid expression');
          }
        }
        tokens.add(numberBuffer);
        numberBuffer = '';
        tokens.add(char);
      } else {
        throw Exception('Invalid character');
      }
    }

    if (numberBuffer.isNotEmpty) {
      tokens.add(numberBuffer);
    }

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        final left = double.parse(tokens[i - 1]);
        final right = double.parse(tokens[i + 1]);
        double res;
        if (tokens[i] == '*') {
          res = left * right;
        } else {
          if (right == 0) throw Exception('Division by zero');
          res = left / right;
        }
        tokens[i - 1] = res.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
        i -= 1;
      }
    }

    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      final op = tokens[i];
      final val = double.parse(tokens[i + 1]);
      if (op == '+') {
        result += val;
      } else if (op == '-') {
        result -= val;
      }
    }

    return result;
  }

  Widget buildButton(String text, {Color? color, Color? textColor}) {
    final isOperator = ['+', '-', '×', '÷', '=', '⌫'].contains(text);
    final buttonColor = color ??
        (isOperator ? Colors.deepOrangeAccent : Colors.blueAccent);
    final buttonTextColor = textColor ?? Colors.white;

    return CustomButton(
      label: text,
      color: buttonColor,
      textColor: buttonTextColor,
      onTap: () => onButtonPressed(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.black12,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            alignment: Alignment.bottomRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                input.isEmpty ? '0' : input,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Row(children: [
                Expanded(child: buildButton('7')),
                Expanded(child: buildButton('8')),
                Expanded(child: buildButton('9')),
                Expanded(child: buildButton('÷', color: Colors.orange)),
              ]),
              Row(children: [
                Expanded(child: buildButton('4')),
                Expanded(child: buildButton('5')),
                Expanded(child: buildButton('6')),
                Expanded(child: buildButton('×', color: Colors.orange)),
              ]),
              Row(children: [
                Expanded(child: buildButton('1')),
                Expanded(child: buildButton('2')),
                Expanded(child: buildButton('3')),
                Expanded(child: buildButton('-', color: Colors.orange)),
              ]),
              Row(children: [
                Expanded(child: buildButton('0')),
                Expanded(child: buildButton('.')),
                Expanded(child: buildButton('C', color: Colors.red)),
                Expanded(child: buildButton('⌫', color: Colors.redAccent)),
                Expanded(child: buildButton('+', color: Colors.orange)),
              ]),
              Row(children: [
                Expanded(child: buildButton('=', color: Colors.green)),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
