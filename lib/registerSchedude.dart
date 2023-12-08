import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/Schedude/schedude_bloc.dart';

class registerSchedude extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  const registerSchedude({super.key, required this.appointmentBloc});
  @override
  _registerSchedudeState createState() => _registerSchedudeState();
}

class _registerSchedudeState extends State<registerSchedude> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BlocProvider.of<AppointmentBloc>(context),
        child:_buildSchedudeWidget(context));
    }
  Widget _buildSchedudeWidget(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              'Thông tin lịch khám',
            ),
            SizedBox(height: 20),
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
                Text(
                  'kín giờ',
                ),
                const SizedBox(width: 50),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                Text(
                  'còn trống',
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'SÁNG',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    BlocProvider.of<AppointmentBloc>(context).add(
                        timeButtonPressed(
                            'trung', '03999', DateTime.now()));
                    // Gửi sự kiện lịch hẹn lên Bloc
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('7:30-8h30',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('8:30-9h30',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('9:30-10h30',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('10:30-11h30',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            Text(
              'chiều',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('13:00-14h00',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('14:00-15h00',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('15:00-16h00',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    minimumSize: Size(100, 20),
                  ),
                  child: Text('16:00-17h00',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
