import 'dart:convert';

import 'package:doan/SchedudeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'Bloc/Schedude/schedude_bloc.dart';
import 'Bloc/serviceBloc/serviceBloc.dart';
import 'SignInScreen/LoginScreen.dart';
import 'notification_service.dart';

class service extends StatefulWidget {
  const service({super.key});

  @override
  _serviceState createState() => _serviceState();
}

class _serviceState extends State<service> {
  late int selectedIndex;
  final TextEditingController _loaidichvuController = TextEditingController();
  NotificationService notificationService=NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.requestNotificationPermission();
    //notificationService.isTokenRefesh();
    notificationService.FirebaseInit();
    notificationService.getDeviceToken().then((value) {
      print('device token: ');
      print(value);
    }
    );
    BlocProvider.of<serviceBloc>(context).add(FetchDichVuListOnInit());
    BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentData());

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        child: Expanded(child:
        Column(
          children: [
            TextField(
              controller: _loaidichvuController,
              decoration: const InputDecoration(
                hintText: "Nhập loại dịch vụ",
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<serviceBloc>(context).add(
                      themButtonPressed(loaidichvu: _loaidichvuController.text),
                    );
                    setState(() {
                      _loaidichvuController.text = "";
                    });
                  },
                  child: Text("thêm"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<serviceBloc>(context).add(
                      updateButtonPressed(
                        giaTriMoi: _loaidichvuController.text,
                        selectedIndex: selectedIndex,
                      ),
                    );
                    setState(() {
                      _loaidichvuController.text = "";
                    });
                  },
                  child: const Text("sửa"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<serviceBloc>(context).add(
                      deleteButtonPressed(selectedIndex: selectedIndex),
                    );
                    setState(() {
                      _loaidichvuController.text = "";
                      selectedIndex = -1;
                    });
                  },
                  child: const Text("xóa"),
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
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentData());
                  },
                  child: const Text("reset dich vu"),
                ),
              ],
            )),
            SizedBox(height: 20),

            Expanded(child:
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<AppointmentBloc, AppointmentState>(
                    builder: (context, state) {
                      if (state is LoadedAppointmentData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Số điện thoại')),
                              DataColumn(label: Text('Dịch vụ')),
                              DataColumn(label: Text('Thời gian')),
                              DataColumn(label: Text('Xác nhận')),
                              DataColumn(label: Text('Từ chối')),
                            ],
                            rows: List<DataRow>.generate(
                              state.appointmentDataList.length,
                                  (index) {
                                var rowData = state.appointmentDataList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(rowData.phoneNumber)),
                                    DataCell(Text(rowData.loaiDichVu)),
                                    DataCell(Text(rowData.time.toString())),
                                    DataCell(ElevatedButton(
                                      onPressed: () {
                                        BlocProvider.of<AppointmentBloc>(context).add(
                                          ConfirmButtonPressed(rowData.phoneNumber),
                                        );
                                        BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentData());
                                        notificationService.getDeviceToken().then((value) async  {
                                          var data={
                                            'to':'dGrqrQULQxGCVnZLXjubKf:APA91bENe8q2Lmp-vJt0CO2TviM8Iv5YOZA9vTEOQ7lpWnAFh07RGszi6Rk3oTcS70Jap34viTV4u6LMo8Eh6pzdEu-I0G3x8u606cBtEez_ZlMMfj2HKjUjn3FKF2wI6aZNUHN2rYT8',
                                            'priority' :'high',
                                            'notification' :{
                                              'title' : 'xac nhan lich hen',
                                              'body': 'ban da dang ky lich thanh cong'
                                            },
                                            'data' :{
                                              'type' : 'msj',
                                              'id' :'trung'
                                            }
                                          };
                                          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                                          body: jsonEncode(data),
                                            headers: {
                                            'Content-Type': 'application/json; charset=UTF-8',
                                              'Authorization' : 'key=AAAAHYUTZR0:APA91bEq_VX59V_Sh_5zK-Pd5vd9s0Vryk_8caiiSxEyBldAFX-arYbePZNuaQX5peftb-lLa5MKl6fw0gutm4IXkKWNH3sJAeLu-r7aCkZTAm5ce0BpPhvy2q4qb6VSU2NooGWhqz5S'
                                            }
                                          );
                                        });

                                      },
                                      child: Text("Xác nhận"),
                                    )),
                                    DataCell(ElevatedButton(
                                      onPressed: () {
                                        BlocProvider.of<AppointmentBloc>(context).add(
                                          RejectButtonPressed(rowData.phoneNumber),
                                        );
                                        BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentData());
                                      },
                                      child: Text("Từ chối"),
                                    )),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),

                ),
              ],
            ),
            )],
        ),
      ),
      ) );
  }
}
