import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/userprofile_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Room> rooms = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _database =
      FirebaseDatabase.instance.reference(); // Database reference

  @override
  void initState() {
    super.initState();
    // Add the permanent room to the list of rooms
    rooms.add(Room(
      name: 'Room 1',
      color: Color(0xFF2E8BC0),
    ));

    // Show Wi-Fi connect dialog after a delay
    Future.delayed(Duration(seconds: 2), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Wi-Fi Connection'),
          content: Text('Connect with Wi-Fi '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Open Wi-Fi settings
                openWifiSettings();
              },
              child: Text('Connect Wi-Fi'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> openWifiSettings() async {
    try {
      bool isOpen = await const MethodChannel('com.example/wifi')
          .invokeMethod('openWifiSettings');
      if (isOpen) {
        // Wi-Fi settings opened successfully
      } else {
        // Failed to open Wi-Fi settings
      }
    } on PlatformException catch (_) {
      // Handle exception
    }
  }

  void signOut() {
    // Perform signout operations here
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFF2),
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.menu), // Replacing back button with menu icon
              onPressed: () {
                // Open Drawer here
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            Text(
              ' AUTOHOSP',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController controller = TextEditingController();
                    return AlertDialog(
                      title: Text('Create Room'),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Enter Room Name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              setState(() {
                                rooms.add(Room(
                                  name: controller.text,
                                  color: Color(0xFF2E8BC0),
                                ));
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Create'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E8BC0),
        // Set the background color to blue
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            if (rooms.isNotEmpty)
              ...rooms.map((room) {
                return Column(
                  children: [
                    SizedBox(height: 10), // Reduce the space between rooms
                    buildRoomContainer(context, room),
                    SizedBox(height: 20), // Add space between room and device
                  ],
                );
              }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: signOut,
              child: Text(
                'Sign Out',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white), // Set text color to white
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E8BC0),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 0), // Adjusted padding
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2E8BC0),
              ),
              child: Container(
                height: 20, // Set a fixed height for the background color
                child: Center(
                  child: Text(
                    'User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoomContainer(BuildContext context, Room room) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RoomPage(room: room, database: _database)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: room.color,
          borderRadius: BorderRadius.circular(25), // Set border radius to 25%
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              room.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add Device'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                room.addDevice(Device(
                                    name: 'Device ${room.devices.length + 1}'));
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Add Device'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RoomPage extends StatefulWidget {
  final Room room;
  final DatabaseReference database; // Add this line

  RoomPage({required this.room, required this.database}); // Add this line

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAEFF2),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.room.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add Device'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                widget.room.addDevice(Device(
                                    name:
                                        'Device ${widget.room.devices.length + 1}'));
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Add Device'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor:
            widget.room.color, // Set the background color to room's color
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                for (var device in widget.room.devices)
                  Column(
                    children: [
                      SizedBox(height: 10), // Reduce the space between devices
                      buildDeviceContainer(context, device),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDeviceContainer(BuildContext context, Device device) {
    return Container(
      decoration: BoxDecoration(
        color: device.isOn ? Color(0xFF76B947) : Color(0xFFF37970),
        borderRadius: BorderRadius.circular(25), // Set border radius to 25%
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(
          vertical: 5), // Reduce the vertical space between devices
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            device.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          IconButton(
            icon:
                Icon(device.isOn ? Icons.power_settings_new : Icons.power_off),
            onPressed: () {
              setState(() {
                device.toggle();
                // Update device state in Realtime Database
                widget.database
                    .child('rooms')
                    .child(widget.room.name)
                    .child('devices')
                    .child(device.name)
                    .set({'isOn': device.isOn});
              });
            },
          ),
        ],
      ),
    );
  }
}

class Room {
  final String name;
  final Color color;
  List<Device> devices = [];

  Room({required this.name, required this.color});

  void addDevice(Device device) {
    devices.add(device);
  }
}

class Device {
  final String name;
  bool isOn;

  Device({required this.name, this.isOn = false});

  void toggle() {
    isOn = !isOn;
  }
}
