import 'package:flutter/material.dart';
import 'package:football_player_contact/helper/database_helper.dart';
import 'package:football_player_contact/models/contact.dart';
import 'package:football_player_contact/screen/add_contact_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/contact_item.dart';
import 'contact_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _helper = DatabaseHelper();

  late Future<List<Contact>> futureContact;

  Future<List<Contact>> getContacts() async {
    return _helper.getContacts();
  }

  void refreshContacts() async {
    setState(() {
      futureContact = getContacts();
    });
  }

  Future<int> deleteContact(int id) async {
    return _helper.delete(id);
  }

  @override
  void initState() {
    super.initState();
    futureContact = getContacts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Football Player",
                      style: TextStyle(fontSize: 25),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool? isBack = await Navigator.push(
                          context,
                          MaterialPageRoute<bool>(
                            builder: (context) => const AddContactScreen(),
                          ),
                        );

                        if (isBack != null) {
                          if (isBack) {
                            refreshContacts();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.add,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                      future: futureContact,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, top: 8, right: 8, bottom: 4),
                              child: ContactItem(
                                title:
                                    snapshot.data?[index].name ?? "ไม่พบข้อมูล",
                                onPressed: () async {
                                  var contact = snapshot.data?[index];

                                  if (contact != null) {
                                    bool? isUpdated = await Navigator.push(
                                      context,
                                      MaterialPageRoute<bool>(
                                        builder: (context) =>
                                            ContactDetailScreen(
                                          contact: contact,
                                        ),
                                      ),
                                    );

                                    if (isUpdated != null) {
                                      if (isUpdated) {
                                        refreshContacts();
                                      }
                                    }
                                  }
                                },
                                onDelete: () async {
                                  int? id = snapshot.data?[index].id;

                                  if (id != null) {
                                    int effectRow = await deleteContact(id);

                                    if (effectRow > 0) {
                                      refreshContacts();
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
