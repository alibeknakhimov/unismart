import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserW {
  final List<int> cabs;

  UserW({required this.cabs});

  factory UserW.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    List<int> cabs = List<int>.from(data['cabs'] ?? []);
    return UserW(cabs: cabs);
  }
}

class UserList extends StatelessWidget {
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
          return Center(child: CircularProgressIndicator());
        }

        UserW user = UserW.fromFirestore(snapshot.data!);

        return MyWidget(user: user);
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  final UserW user;

  MyWidget({required this.user});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int? selectedCab;
  int selectedButton = 1;
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(top: 125),
      child: Column(
        children: [
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
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: displayWidth * 0.845,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 15,
                                  color: Colors.black.withOpacity(0.3))
                            ]),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          hint: Text(
                            'Выберите кабинет ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 23,
                            ),
                          ),
                          value: selectedCab,
                          underline: Container(),
                          icon: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.black,
                          ),
                          items: widget.user.cabs.map<DropdownMenuItem<int>>(
                            (int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  'Кабинет $value',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                    fontSize: 27,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedCab = newValue;
                            });
                          },
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButton = 1; // Свет
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.sunny,
                              size: 50,
                            ),
                            Text("Свет"),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                        ),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButton = 2; // Дверь
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.door_sliding_sharp,
                              size: 50,
                            ),
                            Text("Дверь"),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                        ),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedButton = 3; // Телевизор
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.tv,
                              size: 50,
                            ),
                            Text("Проектор"),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(height: 26),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              color: Colors.black.withOpacity(0.3))
                        ]),
                    width: displayWidth * 0.845,
                    height: displayHeight * 0.455,
                    child: Center(
                        child: selectedButton == 1
                            ? ElevatedButton(
                                onPressed: () {
                                  if (selectedCab != null) {
                                    final docUser = FirebaseFirestore.instance
                                        .collection('cabinets')
                                        .doc('${selectedCab!}');
                                    docUser.update({'light': true});
                                  }
                                },
                                child: Icon(
                                  Icons.lightbulb_circle,
                                  color: Colors.white,
                                  size: 70,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    backgroundColor:
                                        Color.fromARGB(255, 159, 206, 95),
                                    fixedSize: Size(120, 120)),
                              )
                            : selectedButton == 2
                                ? ElevatedButton(
                                    onPressed: () {
                                      if (selectedCab != null) {
                                        final docUser = FirebaseFirestore
                                            .instance
                                            .collection('cabinets')
                                            .doc('${selectedCab!}');
                                        docUser.update({'door': true});
                                      }
                                    },
                                    child: Icon(
                                      Icons.lock_open,
                                      color: Colors.white,
                                      size: 70,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        backgroundColor:
                                            Color.fromARGB(255, 159, 206, 95),
                                        fixedSize: Size(120, 120)),
                                  )
                                : selectedButton == 3
                                    ? ElevatedButton(
                                        onPressed: () {
                                          if (selectedCab != null) {
                                            final docUser = FirebaseFirestore
                                                .instance
                                                .collection('cabinets')
                                                .doc('${selectedCab!}');
                                            docUser.update({'light': true});
                                          }
                                        },
                                        child: Icon(
                                          Icons.tv_rounded,
                                          color: Colors.white,
                                          size: 70,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            backgroundColor: Color.fromARGB(
                                                255, 159, 206, 95),
                                            fixedSize: Size(120, 120)),
                                      )
                                    : null),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
