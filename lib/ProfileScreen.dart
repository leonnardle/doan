import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan/Bloc/sign_up/create_user_bloc.dart';
import 'package:doan/SchedudeScreen.dart';
import 'package:doan/SignInScreen/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Bloc/Schedude/schedude_bloc.dart';
import 'model/Customer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Đối tượng Customer để lưu thông tin người dùng
  final Customer _customer = Customer('',',','','',DateTime.now());
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
    }
  }
  @override
   void initState()  {
    super.initState();
    // Lấy thông tin người dùng khi màn hình được tạo
    _loadCurrentUserData();
    // khởi tạo quyền đề nhận thông báo


  }

  // Phương thức để load thông tin người dùng đã đăng nhập
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
          // Cập nhật thông tin người dùng vào  Customer
          _customer.name = userInfo['name'];
          _customer.address = userInfo['address'];

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateUserBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/image/logo.jpeg'),
              ),
              SizedBox(width: 15),
              Text('Hi ${_customer.name}'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.lock_open_rounded),
              onPressed: () {
                signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
              },
            ),
          ],
        ),
        body: schedudeScreen(appointmentBloc: AppointmentBloc(),)
      ),
    );
  }
}


