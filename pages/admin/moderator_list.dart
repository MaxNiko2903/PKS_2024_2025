import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModeratorList extends StatefulWidget {
  @override
  _ModeratorListState createState() => _ModeratorListState();
}

class _ModeratorListState extends State<ModeratorList> {
  List<dynamic> moderators = [];
  List<dynamic> permissions = [];

  @override
  void initState() {
    super.initState();
    fetchModerators();
    fetchPermissions();
  }

  Future<void> fetchModerators() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/moderators'));

    if (response.statusCode == 200) {
      setState(() {
        moderators = jsonDecode(response.body);
        print(moderators);  // Debugging line
      });
    } else {
      print('Failed to load moderators');  // Add error handling
      throw Exception('Failed to load moderators');
    }
  }

  Future<void> fetchPermissions() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/permissions'));

    if (response.statusCode == 200) {
      setState(() {
        permissions = jsonDecode(response.body);
        print(permissions);  // Debugging line
      });
    } else {
      print('Failed to load permissions');  // Add error handling
      throw Exception('Failed to load permissions');
    }
  }


  Future<void> updatePermission(int moderatorId, int permissionId, bool granted) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/moderators/$moderatorId/permissions'),
      body: jsonEncode({'permissionId': permissionId, 'granted': granted}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      print('Failed to update permission for moderator $moderatorId');  // Add error handling
      throw Exception('Failed to update permission');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Moderator Permissions')),
      body: moderators.isEmpty || permissions.isEmpty
          ? Center(
        child: permissions.isEmpty
            ? Text('No permissions available') // Handle empty permissions
            : CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Email')),
            ...permissions.map((perm) =>
                DataColumn(label: Text(perm['permission_name']))).toList(),
          ],
          rows: moderators.map((moderator) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(moderator['id'].toString())),
                DataCell(Text(moderator['email'])),
                ...permissions.map((perm) {
                  bool granted = moderator['permissions'].contains(
                      perm['permission_name']);
                  return DataCell(
                    Checkbox(
                      value: granted,
                      onChanged: (bool? value) {
                        setState(() {
                          updatePermission(moderator['id'], perm['id'], value!);
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),
        ),
      ),
    );
    }
  }
