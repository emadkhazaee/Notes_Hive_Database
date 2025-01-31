import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

import 'package:my_note/home/addnote/addnote.dart';
import 'package:my_note/home/color/Colors.dart';

// ignore: camel_case_types
class home extends StatefulWidget {
  const home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _homeState createState() => _homeState();
}

// ignore: camel_case_types
class _homeState extends State<home> {
  late Box notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box('notes');
  }

  Color getRandomColor() {
    final random = Random();
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      ),
      backgroundColor: const Color(0xFF222222),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/null_DB.png'),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Create your first note !',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index);
              return Dismissible(
                key: Key(note.toString()),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  notesBox.deleteAt(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your note was deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: getRandomColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    note.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        backgroundColor: const Color(0xFF333333),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
