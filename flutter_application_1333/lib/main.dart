import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Контроллер для текстового поля
  TextEditingController _textController = TextEditingController();
  
  // Список заметок
  List<String> _notes = [];

  // Метод для добавления заметки
  void _addNote() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        _notes.add(_textController.text.trim());
        _textController.clear(); // Очищаем поле после сохранения
      });
    }
  }

  // Метод для удаления заметки
  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  // Метод для редактирования заметки
  void _editNote(int index) {
    TextEditingController editController = TextEditingController(
      text: _notes[index],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Редактировать заметку'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: 'Введите текст заметки',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закрываем диалог без сохранения
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (editController.text.trim().isNotEmpty) {
                  setState(() {
                    _notes[index] = editController.text.trim();
                  });
                }
                Navigator.pop(context); // Закрываем диалог
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заметки'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле ввода и кнопка сохранения
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Введите текст заметки',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addNote,
                  child: Text('Сохранить'),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Список заметок
            Expanded(
              child: _notes.isEmpty
                  ? Center(
                      child: Text(
                        'Заметок пока нет',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_notes[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Кнопка редактирования
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editNote(index),
                                ),
                                // Кнопка удаления
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNote(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}