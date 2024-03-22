import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doan/View/Home_Page/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/Customer.dart';

class Thong_tin extends StatefulWidget {
  const Thong_tin({Key? key}) : super (key: key);

  @override
  profileScreen_view createState() => profileScreen_view();
}
class profileScreen_view extends State<Thong_tin>{
  int _selectedIndex = 2;
  final Customer _customer = Customer('', ',', '', '', DateTime.now());
  void _loadCurrentUserData() async {
    try {
      // Lấy thông tin người dùng hiện tại đã đăng nhập
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Lấy UID của người dùng
        String? docID = currentUser.email;

        // Truy vấn Firestore để lấy tài liệu của người dùng có UID là userUID
        DocumentSnapshot userInfo = await FirebaseFirestore.instance
            .collection('user_info')
            .doc(docID)
            .get();

        if (userInfo.exists) {
          // Cập nhật thông tin người dùng vào đối tượng Customer
          _customer.name = userInfo['name'];
          _customer.address = userInfo['address'];
          _customer.phoneNumber = userInfo['phonenumber'];

          // Cập nhật các thông tin khác tương ứng

          // Kích hoạt lại build để cập nhật giao diện
          if (mounted) {
            setState(() {});
          }
        } else {
          Fluttertoast.showToast(msg: 'msg');
        }
      } else {
        print("Người dùng chưa đăng nhập");
      }
    } catch (error) {
      print("Lỗi khi lấy thông tin người dùng: $error");
    }
  }
  @override
  void initState() {
    super.initState();
    // Lấy thông tin người dùng khi màn hình được tạo
    _loadCurrentUserData();
  }
  @override
  Widget build(BuildContext context){
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
      body: profileView(),
    );
  }
  Widget profileView()  {
    return Column(
      children: <Widget>[
        Container(
          color: Color(0xff1d1c21),
          child: Padding(padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home_Page()),
                    );
                },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Icon(Icons.arrow_back, size: 20, color: Colors.white,),
                  ),
                ),

                Text('Thông tin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                Container(height: 24, width: 24,),
              ],
            ),
          ),
        ),
        // add box
        SizedBox(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
          ),
        ),
        Expanded(child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // begin: Alignment.topRight,
              // end: Alignment.bottomLeft,
              colors: [Color(0xff1d1c21), Color(0xff1d1c21)],
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20 , 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_customer.name}', style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(width: 1.0, color: Colors.white70)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20 , 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_customer.address}', style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(width: 1.0, color: Colors.white70)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20 , 4),
                child: Container(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_customer.phoneNumber}', style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(width: 1.0, color: Colors.white70)),
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }
}