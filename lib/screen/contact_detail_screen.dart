import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_player_contact/helper/database_helper.dart';
import 'package:football_player_contact/screen/edit_contact_screen.dart';

import '../models/contact.dart';

class ContactDetailScreen extends StatefulWidget {
  Contact contact;

  ContactDetailScreen({Key? key, required this.contact}) : super(key: key);

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final DatabaseHelper _helper = DatabaseHelper();

  late int _isFavorite;

  bool _isUpdated = false;

  void _updateFavorite() {
    setState(() {
      _isUpdated = true;
      _isFavorite = (_isFavorite == 0) ? 1 : 0;
    });
  }

  Future<int> updateFavoriteData(int id, int favorite) async {
    return _helper.updateFavorite(id, favorite);
  }

  void backToPreviousScreen(bool isUpdated) {
    Navigator.pop(context, isUpdated);
  }

  Future<void> refreshContact(int id) async {
    var result = await _helper.getContactById(id);
    if (result != null) {
      setState(() {
        widget.contact = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.contact.favorite;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            backToPreviousScreen(_isUpdated);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.indigoAccent,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              bool? isEdit = await Navigator.push(
                context,
                MaterialPageRoute<bool>(
                  builder: (context) => EditContactScreen(
                    contact: widget.contact,
                  ),
                ),
              );

              if (isEdit != null) {
                if (isEdit) {
                  int? id = widget.contact.id;
                  if (id != null) {
                    _isUpdated = true;
                    refreshContact(id);
                  }
                }
              }
            },
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.indigoAccent),
            ),
          )
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.contact.name,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              // Divider(thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () async {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () async {},
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color:
                                (_isFavorite == 1) ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            _updateFavorite();

                            int? id = widget.contact.id;
                            if (id != null) {
                              updateFavoriteData(id, _isFavorite);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Divider(thickness: 2,),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("mobile"),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.contact.mobileNo,
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("e-mail"),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.contact.email,
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
