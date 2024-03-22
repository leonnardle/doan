import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// dùng để thông báo

class AppointmentData {
  final String name;
  final String phoneNumber;
  final DateTime time;
  final String loaiDichVu;
  final String status;

  AppointmentData({
    required this.name,
    required this.phoneNumber,
    required this.time,
    required this.loaiDichVu,
    required this.status,
  });
}

abstract class AppointmentEvent {}

class TimeButtonPressed extends AppointmentEvent {
  final String name;
  final String phone;
  final DateTime time;
  final String loaiDichVu;

  TimeButtonPressed(this.name, this.phone, this.time, this.loaiDichVu);
}

class ConfirmButtonPressed extends AppointmentEvent {
  final String phone;

  ConfirmButtonPressed(this.phone);
}

class RejectButtonPressed extends AppointmentEvent {
  final String phone;

  RejectButtonPressed(this.phone);
}

class FetchAppointmentData extends AppointmentEvent {}
class AddAppointmentEvent extends AppointmentEvent {
  final AppointmentData newAppointment;

  AddAppointmentEvent(this.newAppointment);
}


//state
abstract class AppointmentState {}

class InitialAppointmentState extends AppointmentState {}

class LoadingState extends AppointmentState {}

class WaitingForConfirmation extends AppointmentState {}

class SendingSucceed extends AppointmentState {}

class SendingError extends AppointmentState {
  final String error;

  SendingError({required this.error});
}

class LoadedAppointmentData extends AppointmentState {
  final List<AppointmentData> appointmentDataList;

  LoadedAppointmentData(this.appointmentDataList);
}

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(InitialAppointmentState());

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is TimeButtonPressed) {
      yield LoadingState();
      yield* _handleSendAppointment(event);
    } else if (event is FetchAppointmentData) {
      yield LoadingState();
      yield* _handleFetchAppointmentData();
    } else if (event is ConfirmButtonPressed) {
      yield* _handleConfirmAppointment(event);
    } else if (event is RejectButtonPressed) {
      yield* _handleRejectAppointment(event);
    }
  }
  Stream<AppointmentState> _handleSendAppointment(TimeButtonPressed event) async* {
    try {
      if (event.time != null) {
        yield WaitingForConfirmation();

        bool adminConfirmation = await _sendAndAwaitConfirmation(event);

        if (adminConfirmation) {
          yield SendingSucceed();
        } else {
          yield SendingError(error: "Admin rejected the appointment.");
        }
      } else {
        yield SendingError(
            error: "Sending failed. Please choose a valid time.");
      }
    } catch (error) {
      yield SendingError(error: "Sending failed: $error");
    }
  }

  Stream<AppointmentState> _handleFetchAppointmentData() async* {
    try {
      List<AppointmentData> appointmentDataList =
      await _fetchAppointmentDataFromFirestore();

      yield LoadedAppointmentData(appointmentDataList);
    } catch (error) {
      yield SendingError(error: "Fetching data failed: $error");
    }
  }

  Stream<AppointmentState> _handleConfirmAppointment(ConfirmButtonPressed event) async* {
    try {
      // Xử lý logic khi xác nhận cuộc hẹn
      await FirebaseFirestore.instance
          .collection('Appointment')
          .doc(event.phone)
          .update({'status': 'confirmed'});

      // Hiển thị thông báo

    } catch (error) {
      print("Error confirming appointment: $error");
    }
  }

  Stream<AppointmentState> _handleRejectAppointment(RejectButtonPressed event) async* {
    try {
      // Xử lý logic khi từ chối cuộc hẹn
      await FirebaseFirestore.instance
          .collection('Appointment')
          .doc(event.phone)
          .update({'status': 'rejected'});
      // Hiển thị thông báo

    } catch (error) {
      print("Error rejecting appointment: $error");
    }
  }


  Future<bool> _sendAndAwaitConfirmation(TimeButtonPressed event) async {
    try {
      await _pushAppointment(event);
      Completer<bool> confirmationCompleter = Completer<bool>();
      FirebaseFirestore.instance
          .collection('Appointment')
          .doc(event.phone)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          String status = snapshot.get('status');
          if (status == 'confirmed') {
            confirmationCompleter.complete(true);
          } else if (status == 'rejected') {
            confirmationCompleter.complete(false);
          }
        }
      });

      await Future.delayed(Duration(days: 1));
      if (!confirmationCompleter.isCompleted) {
        confirmationCompleter.complete(false);
      }
      return confirmationCompleter.future;
    } catch (error) {
      print("Error sending : $error");
      return false;
    }
  }
  Future<void> _pushAppointment(TimeButtonPressed event) async {
    try {
      CollectionReference appointment =
      FirebaseFirestore.instance.collection('Appointment');
      Timestamp appointmentTime = Timestamp.fromDate(event.time);

      await appointment.doc(event.phone).set({
        'name': event.name,
        'phonenumber': event.phone,
        'time': appointmentTime,
        'dichvu': event.loaiDichVu,
        'status': 'pending',
      });
    } catch (error) {
      print("Error storing user info in Firestore: $error");
    }
  }
  Future<List<AppointmentData>> _fetchAppointmentDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Appointment')
          .where('status', isEqualTo: 'pending')
          .get();
      List<AppointmentData> appointmentDataList = querySnapshot.docs
          .map((DocumentSnapshot doc) => AppointmentData(
        name: doc.get('name'),
        phoneNumber: doc.get('phonenumber'),
        time: (doc.get('time') as Timestamp).toDate(),
        loaiDichVu: doc.get('dichvu'),
        status: doc.get('status'),
      ))
          .toList();
      return appointmentDataList;
    } catch (error) {
      print("Error fetching appointment data from Firestore: $error");
      return [];
    }
  }
}
