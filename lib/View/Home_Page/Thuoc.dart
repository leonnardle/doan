import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doan/View/Home_Page/Thongtin.dart';
import 'package:doan/View/Home_Page/HomePage.dart';

class Thuoc extends StatefulWidget {
  const Thuoc({Key? key}) : super (key: key);

  @override
  Thuoc_View createState() => Thuoc_View();
}
class Thuoc_View extends State<Thuoc> {
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white24,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Call'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });

            switch (index) {
              case 0: // Home
              // Navigate to your Home screen (replace with your implementation)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home_Page()),
                );
                break;
              case 1: // Call
              // Handle making a call (implement call functionality)
              //makeCall();
                break;
              case 2: // Call
              // Handle making a call (implement call functionality)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Thong_tin()),
                );
                break;
            }
          }),
        appBar: AppBar(

          title: Center(
            child: Text('Danh sách thuốc',
              style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
          flexibleSpace: Padding( // Add padding for better search bar placement
            padding: const EdgeInsets.only(top: 80.0, left: 16.0, right: 16.0),

          ),
        ),
      body: Column( // Use Column for vertical layout
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: TextField(
              onChanged: (value) {
                // Implement your search logic here (e.g., filterThuoc(value))
                // Update searchQuery if needed for UI changes
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên thuốc...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded( // Fill remaining space with the medication list
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.asset('hình'),
                    title: Text('Tên thuốc'),
                    subtitle: Text('Công dụng'),
                    trailing: Text('giá'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
