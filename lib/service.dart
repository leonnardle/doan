import 'package:doan/SchedudeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/Schedude/schedude_bloc.dart';
import 'Bloc/serviceBloc/serviceBloc.dart';
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
        child: Column(
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
          ],
        ),
      ),
    );
  }
}
