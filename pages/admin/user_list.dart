import 'package:flutter/material.dart';
import 'package:svk/models/userlist.dart'; // Ensure this is the correct import for UserList
import 'package:svk/models/userdata.dart';
import 'package:svk/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListPage extends StatefulWidget {  // Renamed the class here
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<UserData> users = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Call the fetch users method on initialization
  }

  Future<void> fetchUsers() async {
    ApiService apiService = ApiService();
    UserList? userList = await apiService.fetchUsers(); // Make sure this fetches the correct UserList

    setState(() {
      if (userList != null) {
        users = userList.users; // Extract users from UserList
        hasError = false;
      } else {
        hasError = true;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Пользователи')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: Text('Failed to load users'))
          : users.isEmpty
          ? Center(child: Text('No users available'))
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Role ID')),
            ],
            rows: users.map((user) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(user.name)),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.roleId.toString())),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
