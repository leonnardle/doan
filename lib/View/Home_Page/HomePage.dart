import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan/Bloc/sign_up/create_user_bloc.dart';
import 'package:doan/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doan/View/Home_Page/Thongtin.dart';
import 'package:doan/View/Home_Page/Thuoc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/Customer.dart';
import '../../notification_service.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int _selectedIndex = 2;
  final Customer _customer = Customer('', ',', '', '', DateTime.now());
  NotificationService notificationService=NotificationService();
    Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
    }
  }
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
    notificationService.requestNotificationPermission();
    //notificationService.isTokenRefesh();
    notificationService.FirebaseInit();
    notificationService.getDeviceToken().then((value) {
      print('device token: ');
      print(value);
    }
    );
    _loadCurrentUserData();
  }

  // Phương thức để load thông tin người dùng đã đăng nhập

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
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
      body: SafeArea(
        child: Column(
          children: [
            // row 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Chào
                      BlocProvider(
                          create: (context) => CreateUserBloc(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi ${_customer.name}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),

                      //
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.cyan,
                        ),
                        padding: EdgeInsets.all(16),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  // Tìm kiếm
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(13),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  //Dịch vị
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dịch vụ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      // Adjust as desired for corner roundness
                      color: Colors.blueAccent,
                    ),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigate to ProfileScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors
                                        .transparent, // Transparent background
                                  ),
                                  Image(
                                    image:
                                        AssetImage('assets/image/suckhoe.png'),
                                    width: 60,
                                    height: 60,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Sức khỏe',
                                style: TextStyle(
                                  fontSize: 14, // Adjust font size as needed
                                  color: Colors.white,
                                  overflow: TextOverflow
                                      .ellipsis, // Enable ellipsis for long textrap text in 2 lines
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // Repeat the same structure for other buttons, replacing
                        // image and text content
                        InkWell(
                          onTap: () {
                            // Navigate to ProfileScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.transparent,
                                  ),
                                  Image(
                                    image:
                                        AssetImage('assets/image/datlich.png'),
                                    width: 60,
                                    height: 60,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              const Text(
                                'Đặt lịch',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigate to ProfileScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Thuoc()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.transparent,
                                  ),
                                  Image(
                                    image: AssetImage(
                                        'assets/image/thuvienthuoc.png'),
                                    width: 60,
                                    height: 60,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Thuốc',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigate to ProfileScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()),
                            );
                          },
                          child: Column(


                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: PageView(
                  controller: PageController(),
                  onPageChanged: (index) {
                    print('Đang ở trang $index');
                  },
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    // Thêm các hình ảnh vào đây
                    Image(
                      image: AssetImage('assets/image/banner1.png'),
                    ),
                    Image(
                      image: AssetImage('assets/image/banner2.png'),
                    ),
                    Image(
                      image: AssetImage('assets/image/banner3.png'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
