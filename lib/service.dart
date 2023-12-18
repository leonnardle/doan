import 'package:doan/Bloc/serviceBloc/serviceBloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SignInScreen/LoginScreen.dart';

class service extends StatefulWidget {
  const service({super.key});

  @override
  _serviceState createState() => _serviceState();
}

class _serviceState extends State<service> {
  late int selectedIndex;
  final TextEditingController _loaidichvuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<serviceBloc>(context).add(FetchDichVuListOnInit());
  }
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Đăng xuất thành công, bạn có thể thực hiện các công việc cần thiết sau khi đăng xuất ở đây
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/image/logo.jpeg'),
            ),
            SizedBox(width: 15),
            Text('Hi admin'),
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
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            TextField(
              controller: _loaidichvuController,
              decoration: const InputDecoration(
                hintText: "Nhập loại dịch vụ",
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<serviceBloc>(context).add(
                      themButtonPressed(loaidichvu: _loaidichvuController.text),
                    );
                    setState(() {
                      // Reset giá trị của TextField khi thêm mới
                      _loaidichvuController.text = "";
                    });
                  },
                  child: Text("thêm"),
                ),
                SizedBox(width: 40), // Điều chỉnh khoảng cách giữa TextField và nút

                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<serviceBloc>(context).add(
                      updateButtonPressed(
                        giaTriMoi: _loaidichvuController.text,
                        selectedIndex: selectedIndex,
                      ),
                    );
                    setState(() {
                      // Reset giá trị của TextField khi sửa
                      _loaidichvuController.text = "";
                    });
                  },
                  child: const Text("sửa"),
                ),
                SizedBox(width: 40),

                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<serviceBloc>(context).add(
                      deleteButtonPressed(selectedIndex: selectedIndex),
                    );
                    setState(() {
                      // Reset giá trị của TextField khi xóa
                      _loaidichvuController.text = "";
                      selectedIndex = -1; // Cập nhật selectedIndex về trạng thái không chọn
                    });
                  },
                  child: const Text("xóa"),
                ),

              ],
            ),
            BlocBuilder<serviceBloc, serviceState>(
              builder: (context, state) {
                if (state is LoadedDichVuList) {
                  return DropdownButton(
                    value: _loaidichvuController.text.isNotEmpty
                        ? _loaidichvuController.text
                        : null,
                    items: state.danhSachGiaTri.asMap().entries.map((entry) {
                      int index = entry.key;
                      String value = entry.value;

                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        // Khi giá trị thay đổi, cập nhật selectedIndex
                        setState(() {
                          selectedIndex = state.danhSachGiaTri.indexOf(newValue);
                          _loaidichvuController.text = newValue;
                        });
                      }
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

