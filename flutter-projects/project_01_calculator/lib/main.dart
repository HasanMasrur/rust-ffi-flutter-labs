import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rust_calculator.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rust Glass Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  List<double> _operands = [];
  String? _activeOperator;
  bool _shouldClearDisplay = false;
  final List<String> _history = [];

  void _onNumberPressed(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_display == '0' || _shouldClearDisplay) {
        _display = value;
        _shouldClearDisplay = false;
      } else {
        _display += value;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    HapticFeedback.mediumImpact();
    final currentVal = double.tryParse(_display);
    if (currentVal == null) return;

    setState(() {
      if (_activeOperator != null && _activeOperator != operator) {
        // Operator changed, just update it
        _activeOperator = operator;
      } else {
        _operands.add(currentVal);
        _history.add(_display);
        _history.add(operator);
        _activeOperator = operator;
        _shouldClearDisplay = true;
      }
    });
  }

  void _onCalculate() {
    HapticFeedback.heavyImpact();
    final lastVal = double.tryParse(_display);
    if (lastVal == null || _operands.isEmpty || _activeOperator == null) return;

    _operands.add(lastVal);
    _history.add(_display);

    try {
      double result;
      switch (_activeOperator) {
        case '+':
          result = RustCalculator.add(_operands);
          break;
        case '-':
          result = RustCalculator.subtract(_operands);
          break;
        case '*':
          result = RustCalculator.multiply(_operands);
          break;
        case '/':
          result = RustCalculator.divide(_operands);
          break;
        default:
          return;
      }

      setState(() {
        _display = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
        _operands = [];
        _history.clear();
        _activeOperator = null;
        _shouldClearDisplay = true;
      });
    } catch (e) {
      setState(() {
        _display = e.toString().contains("Division by zero") ? 'Div Error' : 'Error';
        _operands = [];
        _history.clear();
        _activeOperator = null;
        _shouldClearDisplay = true;
      });
    }
  }

  void _onClear() {
    HapticFeedback.vibrate();
    setState(() {
      _display = '0';
      _operands = [];
      _history.clear();
      _activeOperator = null;
      _shouldClearDisplay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/calculator_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Glass Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Display Area (Glass)
                  Expanded(
                    flex: 3,
                    child: _buildGlassContainer(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_history.isNotEmpty)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _history.map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white.withOpacity(0.4),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                )).toList(),
                              ),
                            ),
                          const SizedBox(height: 20),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _display,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 90,
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                letterSpacing: -2,
                              ),
                            ),
                          ),
                          if (_activeOperator != null && _history.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                _activeOperator!,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: const Color(0xFF4B5EFC).withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Buttons Area (Glass)
                  Expanded(
                    flex: 4,
                    child: _buildGlassContainer(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildButtonRow(['AC', '±', '%', '/']),
                          _buildButtonRow(['7', '8', '9', '*']),
                          _buildButtonRow(['4', '5', '6', '-']),
                          _buildButtonRow(['1', '2', '3', '+']),
                          _buildButtonRow(['0', '.', '=']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) => _buildButton(label)).toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    bool isOperator = ['/', '*', '-', '+', '='].contains(label);
    bool isSpecial = ['AC', '±', '%'].contains(label);
    bool isActive = _activeOperator == label;
    
    Color color = Colors.white.withOpacity(0.05);
    if (isOperator) color = const Color(0xFF4B5EFC).withOpacity(0.8);
    if (isSpecial) color = Colors.white.withOpacity(0.1);
    if (isActive) color = Colors.white.withOpacity(0.3);

    return Expanded(
      flex: label == '0' ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
          onTap: () {
            if (label == 'AC') _onClear();
            else if (isOperator && label != '=') _onOperatorPressed(label);
            else if (label == '=') _onCalculate();
            else if (!isSpecial) _onNumberPressed(label);
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: isOperator ? FontWeight.bold : FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
