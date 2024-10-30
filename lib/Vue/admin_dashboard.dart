import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/User.dart';

class AdminDashboardPage extends StatefulWidget {
  final String title;
  final mongo.Db db;
  final mongo.ObjectId userId;

  const AdminDashboardPage({
    Key? key,
    required this.title,
    required this.db,
    required this.userId,
  }) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<User> adminUser;

  @override
  void initState() {
    super.initState();
    adminUser = fetchAdminUser();
  }

  Future<User> fetchAdminUser() async {
    var collection = widget.db.collection('User');
    var adminData = await collection.findOne(mongo.where.id(widget.userId));

    if (adminData != null) {
      return User.fromMap(adminData);
    } else {
      throw Exception('Admin user not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: adminUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Nom : ${snapshot.data!.lastName}');
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}