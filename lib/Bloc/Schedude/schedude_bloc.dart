import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// event cuộc hẹn
abstract class AppointmentEvent{}

//sự kiện khi ấn nút chọn giờ
class timeButtonPressed extends AppointmentEvent{
  final String name;
  final String phone;
  final DateTime time;

  timeButtonPressed(this.name, this.phone, this.time);
}
//state
   /* + trạng thái loading : khi ấn nút
    + trạng thái thành công : khi gửi lên firebase mà không gặp ván đề nào
    + trạng tháithaatsst bai : khi gửi lên firebase mà gặp ván đề
    + trạng thái đã hoàn thành
*/
abstract class AppointmentState{}
class InitialAppointmentState extends AppointmentState {}

class LoadingState extends AppointmentState {}
class SendingSucceed extends AppointmentState {}
class SendingError extends AppointmentState {
  //thong bao loi
  final String error;
  SendingError({required this.error});
}
//bloc

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc() : super(InitialAppointmentState());

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is timeButtonPressed) {
      yield* _handleSendAppointment(event);
    }
  }

  Stream<AppointmentState> _handleSendAppointment(
      timeButtonPressed event) async* {
    try {
      if (event.time != null) {
        // Đăng ký thành công, chuyển sang trạng thái RegistrationSuccessState
        yield SendingSucceed();

        // Lưu trữ thông tin người dùng trong Firestore
        await _pushAppointment(event);
      } else {
        // Đăng ký thất bại, chuyển sang trạng thái RegistrationErrorState
        yield SendingError(
            error: "Sending failed. .");
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      yield SendingError(error: "Sending failed: $error");
    }
  }

  Future<void> _pushAppointment(timeButtonPressed event) async {
    try {
      CollectionReference Appointment =
      FirebaseFirestore.instance.collection('Appointment');
      await Appointment.doc(event.name).set({
        'name': event.name,
        'phone': event.phone,
        'time': event.time,
      });
    } catch (error) {
      print("Error storing user info in Firestore: $error");
      // Xử lý lỗi nếu cần thiết
    }
  }
}