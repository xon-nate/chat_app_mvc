import 'package:flutter/material.dart';

class MessageTextFormField extends StatelessWidget {
  const MessageTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Enter your message',
          hintText: 'Message',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // suffixIcon: IconButton(
          //   alignment: Alignment.bottomRight,
          //   // padding: const EdgeInsets.only(top: 50),
          //   onPressed: () {},
          //   icon: const Icon(Icons.send),
          // ),
        ),
        maxLines: 7,
        minLines: 4,
        expands: false,
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}
