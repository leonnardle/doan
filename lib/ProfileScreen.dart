import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan/Bloc/sign_up/create_user_bloc.dart';
import 'package:doan/SchedudeScreen.dart';
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
  Customer _customer = Customer.name("", "", "", "", DateTime.now());

  @override
  void initState() {
    super.initState();
    // Lấy thông tin người dùng khi màn hình được tạo
    _loadCurrentUserData();
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
              // Hiển thị tên người dùng
              Text('Hi ${_customer.name}'),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Xử lý khi người dùng nhấn vào nút thông báo
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>SchedudeScreen(appointmentBloc: BlocProvider.of<AppointmentBloc>(context))));
              }, child: Text('dat lich'))
            ],
          ),
        ),
      ),
    );
  }
}
