import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String _address;
  String _name;
  String _password;
  String _phoneNumber;
  DateTime _birthday;

  Customer(
      this._address,
      this._name,
      this._password,
      this._phoneNumber,
      this._birthday,
      );

  static Future<Customer> getCustomerFromFirestore(String documentName) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('user_info')
          .doc(documentName)
          .get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        print('Data from Firestore: $data');

        String address = data['address'] ?? '';
        String name = data['name'] ?? '';
        String password = data['password'] ?? '';
        String phoneNumber = data['phonenumber'] ?? '';
        DateTime birthday = data['birthday'] != null
            ? (data['birthday'] as Timestamp).toDate()
            : DateTime.now();

        return Customer(address, name, password, phoneNumber, birthday);
      } else {
        // Trả về một đối tượng Customer mới nếu không tìm thấy dữ liệu
        return Customer('', '', '', '', DateTime.now());
      }
    } catch (error, stackTrace) {
      // Xử lý lỗi nếu có
      print('Lỗi khi lấy dữ liệu từ Firestore: $error');
      print('Lỗi khi lấy dữ liệu từ Firestore: $stackTrace');
      return Customer('', '', '', '', DateTime.now());
    }
  }



  Future<void> createAppointment(String name, String phoneNumber, String address, DateTime appointmentTime) async {
    try {
      // Reference đến collection trong Firestore
      var collectionReference = FirebaseFirestore.instance.collection('Appointment');

      // Tạo document với tên là 'appointment'
      var documentReference = collectionReference.doc('appointment');

      // Ghi thông tin vào document
      await documentReference.set({
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'appointmentTime': appointmentTime,
      });

      print('Lịch hẹn đã được tạo thành công');
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Lỗi khi tạo lịch hẹn: $e');
    }
  }



  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  DateTime get birthday => _birthday;

  set birthday(DateTime value) {
    _birthday = value;
  }
}
