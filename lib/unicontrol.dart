import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final List<int> cabs;

  User({required this.cabs});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    List<int> cabs = List<int>.from(data['cabs'] ?? []);
    return User(cabs: cabs);
  }
}

class UserList extends StatelessWidget {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  UserList({
    this.leftPadding = 4.0,
    this.rightPadding = 4.0,
    this.topPadding = 210.0,
    this.bottomPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 29, 99, 20),
              Color.fromARGB(126, 2, 145, 6),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            leftPadding,
            topPadding,
            rightPadding,
            bottomPadding,
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc('rasul')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              User user = User.fromFirestore(snapshot.data!);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Hello, Alibek",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 80), // Add space between image and blocks
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        color: Color.fromARGB(45, 2, 145, 6),
                      ),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: 1.34,
                        ),
                        itemCount: user.cabs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Center(
                              child: Text(
                                '${user.cabs[index]}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Container(
                    height: displayWidth * .285,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
