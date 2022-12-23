import 'package:flutter/material.dart';
import 'package:football_player_contact/helper/database_helper.dart';
import 'package:football_player_contact/models/contact.dart';

import '../widgets/dialog.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  const EditContactScreen({Key? key, required this.contact}) : super(key: key);

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late Contact contact;

  final DatabaseHelper _helper = DatabaseHelper();

  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textMobileController = TextEditingController();
  final TextEditingController _textEmailController = TextEditingController();

  bool _validateNameEmpty = false;
  bool _validateMobileEmpty = false;
  bool _isEdit = false;

  void initEditContact() {
    contact = widget.contact.copyWith();
    _textNameController.text = contact.name;
    _textMobileController.text = contact.mobileNo;
    _textEmailController.text = contact.email;
  }

  void backToPreviousScreen (bool isEdit) {
    Navigator.pop(context, isEdit);
  }

  @override
  void initState() {
    super.initState();

    initEditContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_isEdit) {
              dialogBuilder(
                  context: context,
                  onPressYes: () {
                    backToPreviousScreen(_isEdit);
                  });
            } else {
              backToPreviousScreen(_isEdit);
            }
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.indigoAccent,
          ),
        ),
        title: const Center(
            child: Text(
          "Edit Contact",
          style: TextStyle(fontSize: 20),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textNameController,
              onChanged: (text) {
                _isEdit = true;
                contact.name = text;
              },
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
              onChanged: (text) {
                _isEdit = true;
                contact.mobileNo = text;
              },
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
              onChanged: (text) {
                _isEdit = true;
                contact.email = text;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _validateNameEmpty = _textNameController.text.isEmpty;
                  _validateMobileEmpty = _textMobileController.text.isEmpty;
                });

                if (!_validateNameEmpty && !_validateMobileEmpty) {
                   _helper.update(contact).then((value) {
                     backToPreviousScreen(_isEdit);
                   });
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent),
              child: const Text("Edit Contact"),
            )
          ],
        ),
      ),
    );
  }
}
