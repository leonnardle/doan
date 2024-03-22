import 'package:doan/model/Customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/Schedude/schedude_bloc.dart';
import 'Bloc/serviceBloc/serviceBloc.dart';

class registerSchedude extends StatefulWidget {
  final AppointmentBloc appointmentBloc;

  const registerSchedude(
      {super.key, required this.appointmentBloc, required this.selectedDay});

  final DateTime selectedDay;

  @override
  _registerSchedudeState createState() => _registerSchedudeState();
}

class _registerSchedudeState extends State<registerSchedude> {
  User? user = FirebaseAuth.instance.currentUser;
  Customer customer = Customer('', '', '', '', DateTime.now());
  String? selectedValue;

  late int selectedIndex;

  void _loadCustomerData() async {
    try {
      String userEmail = user!.email ?? '';
      customer = await Customer.getCustomerFromFirestore(userEmail);
      setState(() {});
    } catch (error) {
      print("Error loading customer data: $error");
    }
  }

  void sendAppointmentEvent(DateTime dateTime,
      {int hours = 0, int minutes = 0}) {
    DateTime utcDateTime =
        dateTime.toUtc().add(Duration(hours: hours, minutes: minutes));
    int timestamp = utcDateTime.millisecondsSinceEpoch;
    try {
      BlocProvider.of<AppointmentBloc>(context).add(TimeButtonPressed(
          customer.name,
          customer.phoneNumber,
          DateTime.fromMillisecondsSinceEpoch(timestamp),
          selectedValue!));
      showSuccessDialog(dateTime, hours, minutes);
    } catch (error) {
      showErrorDialog(error.toString());
    }
  }

  void showSuccessDialog(DateTime dateTime, int hours, int minutes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đăng ký thành công"),
          content: Text(
              "Bạn đã đăng ký khám thành công vào lúc ${hours + 7}:${minutes} ${dateTime.day}/${dateTime.month}/${dateTime.year}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.of(context).pop();
              },
              child: Text("Thoát"),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Lỗi"),
          content: Text("Đã xảy ra lỗi: $errorMessage"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print("Calling _loadCustomerData");
    _loadCustomerData();
    BlocProvider.of<serviceBloc>(context).add(FetchDichVuListOnInit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BlocProvider.of<AppointmentBloc>(context),
        child: _buildSchedudeWidget(context));
  }

  Widget _buildSchedudeWidget(BuildContext context) {
    DateTime dateTime = widget.selectedDay;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Center(
                    child:
                    Text('Thông tin lịch khám',
                      style: TextStyle(fontWeight: FontWeight.bold),)),
              ),
              SizedBox(height: 20),

              const Text(
                'Sáng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    //sử dụng async để wait thoi gian gửi dữ liệu lên
                    onPressed: () async {
                      sendAppointmentEvent(dateTime, hours: 0, minutes: 30);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child:
                        Text('7:30-8h30', style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      sendAppointmentEvent(dateTime, hours: 1, minutes: 30);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child: const Text('8:30-9h30',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      sendAppointmentEvent(dateTime, hours: 2, minutes: 30);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child: const Text('9:30-10h30',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      sendAppointmentEvent(dateTime, hours: 3, minutes: 30);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child: const Text('10:30-11h30',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const Text(
                'chiều',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      sendAppointmentEvent(dateTime, hours: 6, minutes: 0);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child: const Text('13:00-14h00',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      sendAppointmentEvent(dateTime, hours: 7, minutes: 0);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child: const Text('14:00-15h00',
                        style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      sendAppointmentEvent(dateTime, hours: 8, minutes: 0);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child: const Text('15:00-16h00',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      sendAppointmentEvent(dateTime, hours: 9, minutes: 0);
                    },
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.blue),
                      minimumSize: Size(100, 20),
                    ),
                    child:
                        Text('16:00-17h00', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Chọn loại dịch vụ",
                    style: TextStyle(
                      fontSize: 18,
                    ),),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Spacer(flex: 1,),
                        Container( // Wrap DropdownButton with Container
                          decoration: BoxDecoration( // Add border decoration
                            border: Border.all(
                              color: Colors.grey, // Customize border color
                              width: 1.0, // Adjust border width
                            ),
                          ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<serviceBloc, serviceState>(
                            builder: (context, state) {
                              if (state is LoadedDichVuList) {
                                return DropdownButton(
                                  value: selectedValue,
                                  items:
                                      state.danhSachGiaTri.asMap().entries.map((entry) {
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
                                        selectedValue = newValue;
                                      });
                                    }
                                  },
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  SizedBox( width: 20,),
                  Text(
                    'kín giờ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 50),

                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                SizedBox( width: 20,),
                const Text(
                  'còn trống',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
