import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CreateUserEvent {}

// Sự kiện khi nhấn nút đăng ký
class RegisterButtonPressed extends CreateUserEvent {
  final String email;
  final String password;
  /*final String fullName;
  final String phoneNumber;
  final String address;
  final DateTime dateOfBirth;*/

  RegisterButtonPressed({
    required this.email,
    required this.password,
   /* required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,*/
  });
}

// States
abstract class CreateUserState {}

class CreateUserInitialState extends CreateUserState {}

class EmailPasswordEnteredState extends CreateUserState {}

class UserInfoEnteredState extends CreateUserState {}

// Xử lý trạng thái trong quá trình gửi dữ liệu đi
class LoadingState extends CreateUserState {}

// Trạng thái khi quá trình đăng ký thành công.
class RegistrationSuccessState extends CreateUserState {}

// Trạng thái khi quá trình đăng ký thất bại.
class RegistrationErrorState extends CreateUserState {
  final String error;

  RegistrationErrorState({required this.error});
}

// Bloc
class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  CreateUserBloc() : super(CreateUserInitialState());

  @override
  Stream<CreateUserState> mapEventToState( CreateUserEvent event) async* {
    if (event is RegisterButtonPressed) {
      try {
        print("RegisterButtonPressed event received");
        // Sử dụng các thông tin từ sự kiện để thực hiện đăng ký
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        // Kiểm tra xem đăng ký thành công hay không
        if (userCredential.user != null) {
          // Đăng ký thành công, chuyển sang trạng thái RegistrationSuccessState
          yield RegistrationSuccessState();
        } else {
          // Đăng ký thất bại, chuyển sang trạng thái RegistrationErrorState
          yield RegistrationErrorState(error: "Registration failed. User not created.");
        }
      } catch (error) {
        // Xử lý lỗi nếu có
        yield RegistrationErrorState(error: "Registration failed: $error");
      }
    }
  }
}
