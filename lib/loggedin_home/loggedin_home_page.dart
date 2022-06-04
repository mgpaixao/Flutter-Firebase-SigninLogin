import 'package:aula4/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoggedIn_Home_Page extends StatelessWidget {
  LoggedIn_Home_Page({Key? key}) : super(key: key);
  final collection = FirebaseFirestore.instance.collection('users');
  final email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: FutureBuilder<User?>(
                future: readUser(email),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data;
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.purple,
                          child: Text(
                            'Hello ${users!.name}\nYour email is ${users.email}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    try {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
                                    } catch (e) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text('Error'),
                                                content:
                                                    Text('Error signing out'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text('Ok'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  )
                                                ],
                                              ));
                                    }
                                  },
                                  child: Text('Logout'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })));
  }
}

Future<User?> readUser(String? email) async {
  final user = await FirebaseFirestore.instance.collection('users').doc(email);
  final snapshot = await user.get();
  if (snapshot.exists) {
    return User.fromJson(snapshot.data()!);
  }
}

Stream<List<User>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => User.fromJson(doc.data())).toList(),
        );

class User {
  final String email;
  final String name;
  final String password;

  User(this.email, this.name, this.password);

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'password': password,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        json['email'] as String,
        json['name'] as String,
        json['password'] as String,
      );
}
