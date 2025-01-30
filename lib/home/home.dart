import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

import 'package:my_note/home/addnote/addnote.dart';
import 'package:my_note/home/color/Colors.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

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
        backgroundColor: Color(0xFF333333),
        title: Text(
          'Notes',
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      ),
      backgroundColor: Color(0xFF222222),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/null_DB.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
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
                    SnackBar(content: Text('Your note was deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: getRandomColor(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    note.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
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
        backgroundColor: Color(0xFF333333),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
