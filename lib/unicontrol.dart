import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserW {
  final List<int> cabs;

  UserW({required this.cabs});

  factory UserW.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserW(
      cabs: List<int>.from(data['cabs'] ?? []),
    );
  }
}

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc('rasul')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No data available'));
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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 125),
        child: Column(
          children: [
            Expanded(
              child: _buildMainContainer(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromARGB(255, 159, 206, 95),
            Color.fromARGB(255, 14, 128, 40),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              _buildDropdown(context),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 20),
          _buildControlButtons(),
          const SizedBox(height: 26),
          _buildActionContainer(context),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return Container(
      width: displayWidth * 0.845,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: DropdownButton<int>(
        isExpanded: true,
        hint: Text(
          'Выберите кабинет',
          style: TextStyle(
            fontWeight: FontWeight.w600,
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
        items: widget.user.cabs.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(
              'Кабинет $value',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 27,
              ),
            ),
          );
        }).toList(),
        onChanged: (int? newValue) {
          setState(() {
            selectedCab = newValue;
          });
        },
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(Icons.sunny, "Свет", 1),
        _buildControlButton(Icons.door_sliding_sharp, "Дверь", 2),
        _buildControlButton(Icons.ac_unit_sharp, "AC", 3),
        _buildControlButton(Icons.videocam, "Проектор", 4),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, String label, int buttonId) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedButton = buttonId;
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            size: 50,
          ),
          Text(label),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }

  Widget _buildActionContainer(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      width: displayWidth * 0.845,
      height: displayHeight * 0.455,
      child: Center(
        child: _getSelectedButtonWidget(),
      ),
    );
  }

  Widget _getSelectedButtonWidget() {
    switch (selectedButton) {
      case 1:
        return _buildLightControlButtons();
      case 2:
        return _buildDoorControlButton();
      case 3:
        return _buildAirconControlButtons();
      case 4:
        return _buildProjectorControlButtons();
      default:
        return Container();
    }
  }

  Widget _buildLightControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          Icons.lightbulb,
          "ON",
          () => _updateCabinetState('light', true),
        ),
        SizedBox(width: 20),
        _buildActionButton(
          Icons.lightbulb_outline,
          "OFF",
          () => _updateCabinetState('light', false),
        ),
      ],
    );
  }

  Widget _buildDoorControlButton() {
    return _buildActionButton(
      Icons.lock_open,
      "OPEN",
      () => _updateCabinetState('door', true),
    );
  }

  Widget _buildAirconControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          Icons.air,
          "ON",
          () => _updateCabinetState('aircon', true),
        ),
        SizedBox(width: 20),
        _buildActionButton(
          Icons.highlight_off,
          "OFF",
          () => _updateCabinetState('aircon', false),
        ),
      ],
    );
  }

  Widget _buildProjectorControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          Icons.videocam,
          "ON",
          () => _updateCabinetState('projector', true),
        ),
        SizedBox(width: 20),
        _buildActionButton(
          Icons.videocam_off,
          "OFF",
          () => _updateCabinetState('projector', false),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Expanded(child: Container()),
          Icon(
            icon,
            color: Colors.white,
            size: 70,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          Expanded(child: Container()),
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 159, 206, 95),
        fixedSize: Size(120, 120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  void _updateCabinetState(String field, bool value) {
    if (selectedCab != null) {
      FirebaseFirestore.instance
          .collection('cabinets')
          .doc('$selectedCab')
          .update({field: value});
    }
  }
}
