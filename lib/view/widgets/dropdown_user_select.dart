import 'package:flutter/material.dart';

import '../../model/user_model.dart';

class DropdownUserSelect extends StatelessWidget {
  final List<MyAppUser> participants;
  const DropdownUserSelect({
    super.key,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 200,
      child: DropdownButtonFormField(
        hint: const Text('Select a user'),
        isDense: true,
        decoration: InputDecoration(
          hintText: 'User',
          labelText: 'Select a user',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // isExpanded: true,
        menuMaxHeight: 300,
        items: participants
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Container(
                  width: 100,
                  child: Text(
                    e.name,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}
