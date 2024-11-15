import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svk/models/token.dart';
import 'package:svk/models/userdata.dart'; // Импортируйте вашу модель UserData
import 'package:svk/services/api_service.dart'; // Импортируйте сервис для API
import 'package:svk/pages/auth/login_page.dart';
import 'package:svk/pages/admin/admin.dart';

class ProfilePage extends StatefulWidget {
  final Token token;

  ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? _userData; // Храните данные о пользователе
  bool _isLoading = true; // Для отслеживания загрузки данных

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final apiService = ApiService();
    UserData? userData = await apiService.fetchCurrentUser(widget.token);

    setState(() {
      _userData = userData;
      _isLoading = false; // Данные загружены
    });
  }


  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');        // Удаляем токен
    await prefs.setBool('isLoggedIn', false); // Сбрасываем состояние входа
    _navigateToLogin(context);
  }


  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Показать индикатор загрузки
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя: ${_userData?.name ?? 'Не указано'}', style: TextStyle(fontSize: 20)),
            Text('Email: ${_userData?.email ?? 'Не указано'}', style: TextStyle(fontSize: 20)),
            Text('Роль ID: ${_userData?.roleId ?? 0}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => _logout(context),
              child: Text('Выход'),
            ),
            // Проверка роли пользователя
            if (_userData?.roleId == 3 || _userData?.roleId == 4)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDashboard(userRole: _userData!.roleId),
                    ),
                  );
                },
                child: Text('Админ-панель'),
              ),
          ],
        ),
      ),
    );
  }
}
