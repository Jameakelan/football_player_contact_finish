import 'package:flutter/material.dart';
import 'package:football_player_contact/helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textMobileController = TextEditingController();
  final TextEditingController _textEmailController = TextEditingController();

  bool _validateNameEmpty = false;
  bool _validateMobileEmpty = false;

  final DatabaseHelper _helper = DatabaseHelper();

  Future<int> addContact(Contact contact) async {
    return await _helper.insert(contact);
  }

  void backToPreviousScreen(bool isAdded) {
    Navigator.pop(context, isAdded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            backToPreviousScreen(false);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.indigoAccent,
          ),
        ),
        title: const Center(
            child: Text(
          "Add Contact",
          style: TextStyle(fontSize: 20),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Name",
                errorText: (_validateNameEmpty) ? "Name can't be null" : null,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _textMobileController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Mobile",
                  errorText:
                      (_validateMobileEmpty) ? "Mobile can't be null" : null,
                  prefixIcon: const Icon(Icons.phone)),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: _textEmailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _validateNameEmpty = _textNameController.text.isEmpty;
                  _validateMobileEmpty = _textMobileController.text.isEmpty;
                });

                if (!_validateNameEmpty && !_validateMobileEmpty) {
                  String name = _textNameController.text;
                  String mobile = _textMobileController.text;
                  String email = _textEmailController.text;

                  var contact = Contact(
                    name: name,
                    mobileNo: mobile,
                    email: email,
                  );

                  int result = await addContact(contact);

                  if (result > 0) {
                    backToPreviousScreen(true);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent),
              child: const Text("Add Contact"),
            )
          ],
        ),
      ),
    );
  }
}
