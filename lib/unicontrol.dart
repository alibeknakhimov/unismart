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

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  int? selectedCab;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc('rasul')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        User user = User.fromFirestore(snapshot.data!);
        return Container(
          padding: EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    DropdownButton<int>(
                      hint: Text(
                        'Выберите кабинет ',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            fontSize: 26),
                      ), // Displayed when no value is selected
                      value: selectedCab,
                      underline: Container(),
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.black,
                      ),
                      items: user.cabs.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            'Кабинет $value',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                fontSize: 27),
                          ),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedCab = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 159, 206, 95),
                          Color.fromARGB(255, 14, 128, 40),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: 45,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container()),
                            ElevatedButton(
                              onPressed: () => {},
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(
                                    Icons.sunny,
                                    size: 50,
                                  ),
                                  Text("Свет")
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0),
                            ),
                            Expanded(child: Container()),
                            ElevatedButton(
                              onPressed: () => {},
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(
                                    Icons.door_sliding_sharp,
                                    size: 50,
                                  ),
                                  Text("Дверь")
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0),
                            ),
                            Expanded(child: Container()),
                            ElevatedButton(
                              onPressed: () => {},
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(
                                    Icons.tv,
                                    size: 50,
                                  ),
                                  Text("Проектор")
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          width: 300,
                          height: 500,
                        )
                      ],
                    )

                    /*Center(
                    child: Text(selectedCab != null
                        ? 'Selected Cab: ${selectedCab!}'
                        : 'No cab selected'),
                  ),
                  */
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
