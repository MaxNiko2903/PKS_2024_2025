import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Импорт SharedPreferences
import 'pages/auth/login_page.dart';
import 'pages/auth/profile.dart';
import 'pages/admin/admin.dart'; // Импорт страницы админ-панели
import 'pages/admin/moderator_list.dart';
import 'pages/admin/user_list.dart';
import 'pages/auth/registration_page.dart'; // Импорт страницы регистрации
import 'package:svk/models/token.dart'; // Импортируйте модель Token

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магазин кожаных изделий',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.brown,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.amber,
        ),
        fontFamily: 'Georgia',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(), // Добавьте это в routes
        '/profile': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as Token; // Получаем токен
          return ProfilePage(token: token); // Передаем токен в ProfilePage
                              },
        '/admin/dashboard': (context) => AdminDashboard(userRole: 4), // Передаем role_id
        '/users': (context) => UserList(),
        '/moderators': (context) => ModeratorList(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  // Замените на реальный токен или используйте SharedPreferences для получения токена
  final String _token = "your_secret_key"; // Dummy token for testing, replace this.

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        elevation: 0,
        centerTitle: true,
        title: isMobile ? _buildMobileHeader(context) : _buildDesktopHeader(context),
      ),
      endDrawer: isMobile ? _buildEndDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(isMobile),
            _buildCompanyInfo(),
            _buildAdvantages(),
            SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
      backgroundColor: Colors.brown[100],
      bottomNavigationBar: isMobile ? _buildBottomNavBar(context) : null,
    );
  }

  // Мобильный заголовок с кнопкой меню справа
  Widget _buildMobileHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Магазин кожаных изделий',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '+7 (999) 123-45-67',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // Заголовок для десктопной версии
  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.network(
          'https://picsum.photos/250?image=9',
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavItem('Главная'),
            SizedBox(width: 30),
            _buildNavItem('Каталог'),
            SizedBox(width: 30),
            _buildNavItem('Информация'),
          ],
        ),
        Row(
          children: [
            Text(
              '+7 (999) 123-45-67',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.brown),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.brown),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.brown),
              onPressed: () => _handleProfileAccess(context),
            ),
          ],
        ),
      ],
    );
  }

  // Функция для обработки нажатия на кнопку профиля
  Future<void> _handleProfileAccess(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String? token = prefs.getString('token'); // Получаем токен из SharedPreferences

    if (isLoggedIn && token != null) {
      // Переход на страницу профиля
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(token: Token.fromString(token))), // Создайте токен из строки, если у вас есть такой метод

      );
    } else {
      // Переход на страницу логина
      Navigator.pushNamed(context, '/login');
    }
  }

  // Функция для создания пунктов навигации
  Widget _buildNavItem(String title) {
    return GestureDetector(
      onTap: () {}, // Замените на нужное действие
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Функция для правого меню (Drawer)
  Widget _buildEndDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.brown),
            child: Text(
              'Меню',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Главная'),
            onTap: () {
              // Действие при нажатии
            },
          ),
          ListTile(
            title: Text('Каталог'),
            onTap: () {
              // Действие при нажатии
            },
          ),
          ListTile(
            title: Text('Информация'),
            onTap: () {
              // Действие при нажатии
            },
          ),
        ],
      ),
    );
  }

  // Функция для баннера
  Widget _buildBanner(bool isMobile) {
    return Container(
      width: double.infinity,
      height: 300,
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        children: [
          _buildBannerItem('https://picsum.photos/1200/400?image=9', 'Категория 1'),
          _buildBannerItem('https://picsum.photos/1200/400?image=10', 'Категория 2'),
          _buildBannerItem('https://picsum.photos/1200/400?image=11', 'Категория 3'),
        ],
      ),
    );
  }

  // Элемент баннера
  Widget _buildBannerItem(String imageUrl, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'Ошибка загрузки изображения',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
              onPressed: () {},
              child: Text(
                'Перейти в $category',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Информация о компании
  Widget _buildCompanyInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'О компании',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
            textAlign: TextAlign.center, // Центрируем заголовок
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.network(
                'https://picsum.photos/250?image=9',
                height: 150,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  'Наша компания производит уникальные кожаные изделия',
                  style: TextStyle(fontSize: 16, color: Colors.brown[700]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Преимущества компании
  Widget _buildAdvantages() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Наши Преимущества',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown[800],
            ),
            textAlign: TextAlign.center, // Центрируем заголовок
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.verified, size: 50, color: Colors.brown),
                  SizedBox(height: 10),
                  Text('Качество', textAlign: TextAlign.center),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.design_services, size: 50, color: Colors.brown),
                  SizedBox(height: 10),
                  Text('Дизайн', textAlign: TextAlign.center),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.timer, size: 50, color: Colors.brown),
                  SizedBox(height: 10),
                  Text('Долговечность', textAlign: TextAlign.center),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Футер
  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        '© 2024 Магазин кожаных изделий',
        style: TextStyle(fontSize: 16, color: Colors.brown[700]),
      ),
    );
  }

  // Нижняя навигация для мобильных
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.brown),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.brown),
          label: 'Поиск',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Colors.brown),
          label: 'Избранное',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, color: Colors.brown),
          label: 'Корзина',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color: Colors.brown),
          label: 'Аккаунт',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.brown[400],
      onTap: (index) {
        if (index == 4) {
          _handleProfileAccess(context);
        }
      },
    );
  }
}
