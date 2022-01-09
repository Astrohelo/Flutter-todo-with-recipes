import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberScroll extends StatefulWidget {
  @override
  _NumberScrollState createState() => _NumberScrollState();
   NumberScroll({
    required this.controller,
  });

  final TextEditingController controller;

}

class _NumberScrollState extends State<NumberScroll> {
  int _currentValue = 0;


 @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 50,
            maxWidth: 60,
            minHeight: 20,
          ),
          child: NumberPicker(
            value: _currentValue,
            minValue: 0,
            maxValue: 100,
            onChanged: (value) => setState(() => {_currentValue = value, widget.controller.text= _currentValue.toString()}),
          ),
        ),
      ],
    );
  }
  @override
void dispose() {
  // Clean up the controller when the widget is removed from the widget tree.
  // This also removes the _printLatestValue listener.
  widget.controller.dispose();
  super.dispose();
}
}
