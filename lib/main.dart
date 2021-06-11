import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String box_1 = "", box_2 = "", screen = "";
  String num1 = "", num2 = "", op = "", temp_calc = "";
  String exxp = "";
  // use CalculateValue to perform without function
  void calculateValue() {
    if (op == "+") {
      temp_calc = (int.parse(num1) + int.parse(num2)).toString();
      box_2 = temp_calc;
    } else if (op == "-") {
      temp_calc = (int.parse(num1) - int.parse(num2)).toString();
      box_2 = temp_calc;
    } else if (op == "*") {
      temp_calc = (int.parse(num1) * int.parse(num2)).toString();
      box_2 = temp_calc;
    } else if (op == "/") {
      temp_calc = (int.parse(num1) / int.parse(num2)).ceil().toString();
      box_2 = temp_calc;
    }
  }
  // use ezcalculator is using the math_expression library
  void ezcalculation() {
    Parser p = Parser();
    Expression exp = p.parse(screen);
    ContextModel cm = ContextModel();
    temp_calc = (exp.evaluate(EvaluationType.REAL, cm)).ceil().toString();
    setState(() {
      if(temp_calc != "")
      box_2 = temp_calc;
    });
    print(exp.evaluate(EvaluationType.REAL, cm).runtimeType);
  }

  ElevatedButton numberpads(String numm) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          box_1 += numm;
          screen += numm;
        });
        if (op != "" && num1 != "") {
          num2 = box_1;
          print("num1 - $num1");
          print("num2 - $num2");
          //calculateValue();
          ezcalculation();
        }
      },
      child: Text(numm),
    );
  }

  ElevatedButton oppads(String opp) {
    return ElevatedButton(
      onPressed: () {
        if (num1 == "") num1 = box_1;
        setState(() {
          box_1 = "";
          screen += " $opp ";
        });
        op = opp;
        if (num2.isNotEmpty) num1 = temp_calc;
      },
      child: Text(opp),
    );
  }

  Container dispbox(String val) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
        child: Text(
          val,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.centerRight,
      height: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          dispbox(screen),
          dispbox(box_2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              numberpads("1"),
              numberpads("2"),
              numberpads("3"),
              oppads("+"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              numberpads("4"),
              numberpads("5"),
              numberpads("6"),
              oppads("-"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              numberpads("7"),
              numberpads("8"),
              numberpads("9"),
              oppads("*"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              numberpads("0"),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (screen.isNotEmpty) {
                      screen = screen.substring(0, screen.length - 1);
                      if (screen == "") {
                        num1 = "";
                        op = "";
                      }
                      print(screen);
                    }
                  });
                  try {
                    if (op != "" && num1 != "") ezcalculation();
                  } on RangeError catch (e) {
                    box_2 = "ERROR";
                  }
                },
                child: Icon(Icons.keyboard_backspace),
              ),
              ElevatedButton(
                onPressed: () {
                  num1 = "";
                  num2 = "";
                  op = "";
                  setState(() {
                    box_1 = "";
                    box_2 = "";
                    temp_calc = "";
                    screen = "";
                  });
                },
                child: Text("RESET"),
              ),
              oppads("/"),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            numberpads("("),
            numberpads(")"),
            ElevatedButton(
                onPressed: () {
                  try {
                    if (op != "" && num1 != "") ezcalculation();
                  } on RangeError catch (e) {
                    setState(() {
                      box_2 = "ERROR";
                    });
                  }
                },
                child: Text("=")),
          ]),
        ],
      ),
    );
  }
}
