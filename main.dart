import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<int> _favorites = [];
  Map<int, int> _cartItems = {};

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Докхолдер',
      'image': 'https://sun9-80.userapi.com/s/v1/ig2/PBQOejzPEN9Nt7o_X586dI3E4FJ_VGbNIU2gxKjl35vbBOIfNN23AE4BIMj59_RJnzRNM8zM_vtulbj-TmZvYrG-.jpg?quality=95&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1280x1280,1440x1440,2560x2560&from=bu&u=jywAaNpzcO80RBo5J-EbnXxghOzEe7NjmuWRCEkieKw&cs=510x510',
      'price': 5990,
      'description': 'Первый докхолдер я изготовил в 2016 году. С тех пор его дизайн и функционал претерпел минимальные изменения. Я разработал его под собственные нужды: чтобы вмещал паспорт и загран, стс на авто, водительское удостоверение, страховой полис, пару кредиток и наличные на случай непредвиденных расходов. Пользуюсь им уже 5 лет. С тех пор уровень мастерства и качество кожи сильно выросло, однако я не хочу его менять на новый. Он не утратил полезных свойств, при этом приобрел неповторимый шарм. Такой теперь только у меня. С годами кожа будет покрываться патиной, а изделие из нее приобретет неповторимый благородный вид. При изготовлении использовался только ручной инструмент: шило, нож, пробойники, киянка и пара игл. Каждый стежок выполнен седельным швом - самым крепким, разорвать такой невозможно. Докхолдеры часто заказывают в подарок друзьям и родителям, любимым и коллегам Еще чаще для себя'
    },
    {
      'name': 'Ремень Toscana',
      'image': 'https://sun9-69.userapi.com/s/v1/ig2/s6372c8KtnIXC3m5Qu0fXli2cMF33YBNGtAQJw_JKOXGspa6cYf3xYfPdBxGAelgd_HFi2MQ4E9wBZlYlpXnKuUS.jpg?quality=95&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1280x1280,1440x1440,2560x2560&from=bu&u=5DmIMfLveZr2V0wHE7cJ6YdEKxxhrw0tDSKU-cW1soE&cs=510x510',
      'price': 7490,
      'description': 'Найти классный и удобный ремень на долгие годы - задачка не из легких, но вам это удалось. Перед вашими глазами как раз сейчас такой. Я делаю их целиком вручную из кожи быков, пасущихся на лугах солнечной Тосканы, что в сердце Италии. Они нарезаются исключительно вдоль хребта - это необходимо, чтобы они не тянулись под нагрузкой в процессе использования. Это самый верхний и ценный слой кожи, а потому на нем бывают видны жилы животного, а также шрамы, полученные при жизни. Это нормально и даже напротив, добавляет изделию уникальности. Такой ремень вы не найдете в торговом центре и даже на прилавке модного бутика. По умолчанию я делаю ремни шириной 35мм и предлагаю на выбор 2 цвета пряжки: 1. Полированная латунь 2. Никель Каждый мой ремень изготавливается исключительно при помощи ручных инструментов и натуральных средств для обработки кожи и полировки уреза. В таких ремнях отсутствуют слабые места, поэтому я смело даю на них пожизненную гарантию. С годами эта кожа выглядит лишь эффектней, покрываясь благородной патиной.'
    },
    {
      'name': 'Сумка-бананка',
      'image': 'https://sun9-6.userapi.com/s/v1/ig2/8sEwNMBXYIrEERhCyqiHBrfZ7aSN3y76RL6X643qttMyMBoLsUs5AxK65rONc9lSdSqTyZA5AtZrbzN8fqjAR28b.jpg?quality=95&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1280x1280,1440x1440,2560x2560&from=bu&u=14c3kR5qQ9w68A3vye5tcPH4MgbC_vau6WB8Gts8m0E&cs=510x510',
      'price': 19990 ,
      'description': 'Поясная сумка. Её удобно носить, перекинув через плечо на груди или на спине. Идеальная для путешествий и коротких городских прогулок. Вмещается кошелек, паспорт, пауэрбэнк, телефон и прочие мелочи.'
    },
    {
      'name': 'Обложка на паспорт в цвете Olive [Pueblo]',
      'image': 'https://sun9-77.userapi.com/s/v1/ig2/aUDbR9T6bqlt78UvgyyIEHjAKTosM6XSIExL-wbi2-Cc3odgL2ynfcnjrML5rrHB-05PGcetY6p5WGWTRMXIEQFM.jpg?quality=96&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1280x1280,1440x1440,2160x2160&from=bu&u=dV1gddjR2EoQ1o2JV4uDSHE4ZryHge5hL24Vp5qxw-A&cs=510x510',
      'price': 4990,
      'description': 'Обязательный аксессуар для каждого человека, у которого есть паспорт. Да, это просто обложка, но я добавил в нее кармашек для карточки либо водительского удостоверения, что делает её еще более удобной в использовании. С таким аксессуаром ваши документы всегда в сохранности, а лица, требующие их предъявления выражают своё почтение ценителю стильных вещей.'
    },
    {
      'name': 'Veneta',
      'image': 'https://sun9-18.userapi.com/s/v1/ig2/Gto7CcJyfNcTfr1_T-qDbyNKlr22CNSl2mnB2MlilYxFdT2uCtMJN_E1JKZHykHboxAhYBZo35WqP3Yi7vZ4Eepk.jpg?quality=95&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1184x1184&from=bu&u=13rzqkBNWLFPEU9UOCEtHdLT-wX7eplFATW2zUhdrbA&cs=510x510',
      'price': 14990,
      'description': 'Компактная плетеная сумка, идеальная для летних образов. Сумка унисекс, подходит как девушкам, так и мужчинам. Вмещает телефон, кошелек и другие мелочи. Закрывается на хлястик. Ремень регулируется по длине. Итальянская Full-Grain кожа Etrusco от фабрики Walpier. С годами кожа будет покрываться патиной, а изделие из нее приобретет неповторимый благородный вид.'
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
  }

  void _addToCart(int index) {
    setState(() {
      if (_cartItems.containsKey(index)) {
        _cartItems[index] = _cartItems[index]! + 1;
      } else {
        _cartItems[index] = 1;
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      if (_cartItems.containsKey(index)) {
        if (_cartItems[index]! > 1) {
          _cartItems[index] = _cartItems[index]! - 1;
        } else {
          _cartItems.remove(index);
        }
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Заказ успешно оформлен')),
    );
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      total += _products[key]['price'] * value;
    });
    return total;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Магазин'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => _onItemTapped(2),
              tooltip: 'Корзина',
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildCatalog(context),
            _buildFavorites(context),
            _buildCart(),
            _buildProfile(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Каталог'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Корзина'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildCatalog(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.6,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showProductDetails(context, index),
          child: Card(
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    _products[index]['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _products[index]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\₽${_products[index]['price']}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          _favorites.contains(index)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _favorites.contains(index) ? Colors.red : null,
                        ),
                        onPressed: () => _toggleFavorite(index),
                      ),
                      if (_cartItems[index] == null || _cartItems[index] == 0)
                        IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () => _addToCart(index),
                        )
                      else
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _removeFromCart(index),
                            ),
                            Text('${_cartItems[index]}', style: TextStyle(fontSize: 16)),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _addToCart(index),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProductDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_products[index]['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.maxFinite,
                height: 200,
                child: Image.network(
                  _products[index]['image'],
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16),
              Text(_products[index]['description']),
              SizedBox(height: 8),
              Text(
                '\₽${_products[index]['price']}',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_cartItems[index] == null || _cartItems[index] == 0)
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        _addToCart(index);
                        // Do not close the dialog here
                      },
                    )
                  else
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            _removeFromCart(index);
                            // Do not close the dialog here
                          },
                        ),
                        Text('${_cartItems[index]}', style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _addToCart(index);
                            // Do not close the dialog here
                          },
                        ),
                      ],
                    ),
                  IconButton(
                    icon: Icon(
                      _favorites.contains(index) ? Icons.favorite : Icons.favorite_border,
                      color: _favorites.contains(index) ? Colors.red : null,
                    ),
                    onPressed: () {
                      _toggleFavorite(index);
                      // Do not close the dialog here
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildFavorites(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        int productIndex = _favorites[index];
        return GestureDetector(
          onTap: () => _showProductDetails(context, productIndex),
          child: Card(
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    _products[productIndex]['image'],
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _products[productIndex]['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\₽${_products[productIndex]['price']}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => _toggleFavorite(productIndex),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCart() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              int productIndex = _cartItems.keys.elementAt(index);
              return Dismissible(
                key: Key(productIndex.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    _cartItems.remove(productIndex);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Товар удален из корзины')),
                    );
                  });
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: ListTile(
                    leading: Image.network(
                      _products[productIndex]['image'],
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(_products[productIndex]['name']),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Количество: ${_cartItems[productIndex]}'),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _removeFromCart(productIndex),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _addToCart(productIndex),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      '\₽${(_products[productIndex]['price'] * _cartItems[productIndex]).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Итого: \₽${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: _clearCart,
                child: Text('Заказать'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Профиль',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(labelText: 'Имя'),
            controller: TextEditingController(text: _name),
            onChanged: (value) {
              _name = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
            controller: TextEditingController(text: _email),
            onChanged: (value) {
              _email = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Телефон'),
            controller: TextEditingController(text: _phone),
            onChanged: (value) {
              _phone = value;
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Here you can save the data to a database or API if needed.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Данные профиля сохранены')),
              );
            },
            child: Text('Сохранить изменения'),
          ),
        ],
      ),
    );
  }
}
