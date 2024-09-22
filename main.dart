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
      'content': 'Это утро было не просто тише обычного, а совсем застыло. Время словно отказалось продолжать своё движение.',
      'imageUrl': 'https://sun9-62.userapi.com/impg/-_7xmxmTBAoypPwVIzSuNlwp8HQ3iYBAIfwSvA/kwx0ssEytqY.jpg?size=466x700&quality=95&sign=46765803b6b912066f914b4fbbbab32b&c_uniq_tag=YW8Ew4Q6vgFPVO6yyE21RS61kx9cFwTMBVD6fOOVBPs&type=album',
    },
    {
      'title': 'Одиночество в толпе – прогулка по ночному городу',
      'content': 'Я иду по улицам поздним вечером. Огни фонарей разбиваются на капли дождя.',
      'imageUrl': 'https://sun9-13.userapi.com/yu9Qfx6S-H1WIDqwBwgYIqghHihsd7p2oUDgBQ/FR0oGHKd83I.jpg',
    },
    {
      'title': 'Старая книга, которая пахнет детством',
      'content': 'Сегодня я открыл ту самую книгу, которую давно не брал в руки.',
      'imageUrl': 'https://cdn.culture.ru/images/321db0fa-8703-5993-bce8-eeb5746c6fae',
    },
    {
      'title': 'Дом на берегу, который так и не стал нашим',
      'content': 'Он стоял на краю мира, словно ждал, когда мы придём и останемся в нём навсегда.',
      'imageUrl': 'https://live.staticflickr.com/7690/17839284706_06b0b07af6.jpg',
    },
    {
      'title': 'Разговор с ветром о прошлом',
      'content': 'В этот день ветер был особенно сильным. Он словно пытался что-то мне рассказать.',
      'imageUrl': 'https://sun9-73.userapi.com/impf/c624729/v624729713/395e2/zDZDhm66DLc.jpg?size=604x378&quality=96&sign=c667867772acb1e0861797d97998df40&type=album',
    },
    {
      'title': 'Запах осени на страницах письма',
      'content': 'Сегодня я нашел старое письмо. Его конверт был слегка потрёпанным.',
      'imageUrl': 'https://img.goodfon.ru/original/1366x768/2/85/retro-vintazh-bumagi-foto-lupa-pismo-koshelek.jpg',
    },
    {
      'title': 'Ночная дорога, где светят только звёзды',
      'content': 'Я ехал по пустой трассе. Ни одного фонаря, лишь свет фар.',
      'imageUrl': 'https://avt-7.foto.mail.ru/mail/99-melek/_avatar180?',
    },
    {
      'title': 'Старая фотокамера и неразгаданные тайны снимков',
      'content': 'Камера, которой давно никто не пользовался, наконец-то была открыта.',
      'imageUrl': 'https://sun9-20.userapi.com/impf/c627726/v627726056/282f6/IUxNNSb6TWg.jpg?size=604x339&quality=96&sign=7bd23239a8395b83997d03d785d354f2&type=album',
    },
    {
      'title': 'Окно в тот город, куда я так и не вернулся',
      'content': 'Каждый раз, проходя мимо этого окна, я вижу отражение того города.',
      'imageUrl': 'https://sun9-61.userapi.com/impg/rFyg181djOZVMxFnHEARijStgbwsQhjjL9Z6og/9FrUD08fUJY.jpg?size=696x444&quality=96&sign=f2ab6ddc2a1afcbb44190cdd99283f2e&c_uniq_tag=Jw2XBYa2fRYOHkkq1BiAePnOKlyQ4rUphKAzuro6XfQ&type=album',
    },
    {
      'title': 'Письмо себе из будущего',
      'content': 'Я решил написать себе письмо в будущее. Но как написать тому, кого ещё не существует?',
      'imageUrl': 'https://i1.sndcdn.com/artworks-000107619199-bl3hna-t500x500.jpg',
    },
  ];

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
            child: NoteTile(
              title: notes[index]['title']!,
              content: notes[index]['content']!,
              imageUrl: notes[index]['imageUrl']!,
            ),
          );
        },
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailPage(
              title: title,
              content: content,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Card(
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
            ],
          ),
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
