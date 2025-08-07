import 'package:flutter/material.dart';

enum SingingCharacter { squat, deadlift, benchpress }

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  SingingCharacter? _character = SingingCharacter.squat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Squat', style: TextStyle(color: Colors.white)),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.squat,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Deadlift', style: TextStyle(color: Colors.white)),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.deadlift,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Benchpress', style: TextStyle(color: Colors.white)),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.benchpress,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
