import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesList(),
    );
  }
}

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final List<Map<String, String>> notes = [
    {
      'title': 'Утро, когда часы в доме остановились',
      'content': 'Это утро было не просто тише обычного...',
      'imageUrl': 'https://sun9-62.userapi.com/impg/-_7xmxmTBAoypPwVIzSuNlwp8HQ3iYBAIfwSvA/kwx0ssEytqY.jpg',
    },
    {
      'title': 'Одиночество в толпе – прогулка по ночному городу',
      'content': 'Я иду по улицам поздним вечером...',
      'imageUrl': 'https://sun9-13.userapi.com/yu9Qfx6S-H1WIDqwBwgYIqghHihsd7p2oUDgBQ/FR0oGHKd83I.jpg',
    },
  ];

  // Открываем диалог для добавления новой заметки
  void _showAddNoteDialog() {
    String title = '';
    String content = '';
    String imageUrl = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить новую заметку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Заголовок'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Текст заметки'),
                onChanged: (value) {
                  content = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Ссылка на изображение'),
                onChanged: (value) {
                  imageUrl = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Добавить'),
              onPressed: () {
                if (title.isNotEmpty && content.isNotEmpty && imageUrl.isNotEmpty) {
                  setState(() {
                    notes.add({
                      'title': title,
                      'content': content,
                      'imageUrl': imageUrl,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Удаление заметки с подтверждением
  void _removeNoteAt(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удалить заметку?'),
          content: Text('Вы уверены, что хотите удалить эту заметку?'),
          actions: [
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Удалить'),
              onPressed: () {
                setState(() {
                  notes.removeAt(index);
                });
                Navigator.of(context).pop();
              },
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
        title: Text('Мои заметки'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailPage(
                      title: notes[index]['title']!,
                      content: notes[index]['content']!,
                      imageUrl: notes[index]['imageUrl']!,
                    ),
                  ),
                );
              },
              onLongPress: () {
                _removeNoteAt(index); // Удаление заметки по долгому нажатию
              },
              child: NoteTile(
                title: notes[index]['title']!,
                content: notes[index]['content']!,
                imageUrl: notes[index]['imageUrl']!,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog, // Добавляем заметку по нажатию на кнопку
        child: Icon(Icons.add),
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;

  const NoteTile({
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(
              content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8.0),
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;

  const NoteDetailPage({
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.0),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}
