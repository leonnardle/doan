import 'package:doan/Bloc/Schedude/schedude_bloc.dart';
import 'package:doan/registerSchedude.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedudeScreen extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  SchedudeScreen({Key? key, required this.appointmentBloc}) : super(key: key);
  @override
  _SchedudeScreenState createState() => _SchedudeScreenState();
}

class _SchedudeScreenState extends State<SchedudeScreen> {


  DateTime today = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
    _openRegistrationScreen(selectedDay);
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => AppointmentBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            TableCalendar(
              rowHeight: 43,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2099, 3, 14),
              focusedDay: today,
              // Xử lý sự kiện khi ngày được chọn
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (day) => isSameDay(day, today),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.yellow, // Màu vàng cho ngày đã chọn
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: MediaQuery.of(context).size.width * 0.2,
              child: ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text("Chọn ngày"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != today) {
      setState(() {
        today = picked;
        _onDaySelected(today, DateTime.now());
      });
    }
  }

  void _openRegistrationScreen(DateTime selectedDay) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => registerSchedude(appointmentBloc:widget.appointmentBloc),
      ),
    );
  }
}
