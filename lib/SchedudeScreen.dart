import 'package:doan/Bloc/Schedude/schedude_bloc.dart';
import 'package:doan/registerSchedude.dart';
import 'package:doan/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Bloc/serviceBloc/serviceBloc.dart';

class schedudeScreen extends StatefulWidget {
  final AppointmentBloc appointmentBloc;

  const schedudeScreen({Key? key, required this.appointmentBloc})
      : super(key: key);

  @override
  _schedudeScreenState createState() => _schedudeScreenState();
}

class _schedudeScreenState extends State<schedudeScreen> {
  DateTime today = DateTime.now();


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
    _openRegistrationScreen(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.appointmentBloc,
      child: Scaffold(
          body: Column(
        children: [
          TableCalendar(
            rowHeight: 43,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 15)),
            focusedDay: today,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) => isSameDay(day, today),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.yellow, // Màu vàng cho ngày đã chọn
                shape: BoxShape.circle,
              ),
            ),
          ),


        ],
      )),
    );
  }

  void _openRegistrationScreen(DateTime selectedDay) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => registerSchedude(
            appointmentBloc: widget.appointmentBloc, selectedDay: today),
      ),
    );
  }
}
