
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

//event
abstract class serviceEvent{}
class themButtonPressed extends serviceEvent{
  final String loaidichvu;
  themButtonPressed({required this.loaidichvu});
}
class FetchDichVuList extends serviceEvent {}

class FetchDichVuListOnInit extends serviceEvent {}

class updateButtonPressed extends serviceEvent {
  final String giaTriMoi;
  final int selectedIndex;

  updateButtonPressed({required this.giaTriMoi, required this.selectedIndex});
}
class deleteButtonPressed extends serviceEvent {
  final int selectedIndex;

  deleteButtonPressed({ required this.selectedIndex});
}
//state
abstract class serviceState{}
class InitialserviceState extends serviceState {}

class LoadingState extends serviceState {}
class SendingSucceed extends serviceState {}
class SendingError extends serviceState {
  //thong bao loi
  final String error;
  SendingError({required this.error});
}
class LoadedDichVuList extends serviceState {
  final List<String> danhSachGiaTri;

  LoadedDichVuList(this.danhSachGiaTri);
}


//bloc
class serviceBloc extends Bloc<serviceEvent, serviceState>{
  serviceBloc() : super(InitialserviceState());
  @override
  Stream<serviceState> mapEventToState(serviceEvent event) async* {
    if (event is themButtonPressed) {
      yield* _handleSendService(event);
    }
    else if (event is FetchDichVuList) {
      yield* _handleFetchDichVuList();
    }
    else if (event is FetchDichVuListOnInit) {
      yield* _handleFetchDichVuListOnInit();
    }
    else if (event is updateButtonPressed) {
      yield* _handleCapNhatGiaTri(event);
    }
    else if (event is deleteButtonPressed) {
      yield* _handledeleteGiaTri(event);
    }
  }
  Stream<serviceState> _handleFetchDichVuListOnInit() async* {
    try {
      // Fetch data from Firestore
      List<String> danhSachGiaTri = await _fetchLoaiDichVuList();

      // Return the list of values as a state
      yield LoadedDichVuList(danhSachGiaTri);
    } catch (error) {
      yield SendingError(error: "Fetching failed: $error");
    }
  }

  Stream<serviceState> _handleSendService(themButtonPressed event) async* {
    try {
      if (event.loaidichvu != null) {
        // Gửi thành công, đưa ra trạng thái SendingSucceed
        yield SendingSucceed();

        // Lưu thông tin người dùng vào Firestore
        await _pushservice(event);

        add(FetchDichVuList());
      } else {
        // Gửi thất bại, đưa ra trạng thái SendingError
        yield SendingError(error: "Gửi thất bại.");
      }
    } catch (error) {
      // Xử lý lỗi
      yield SendingError(error: "Gửi thất bại: $error");
    }
  }
  Stream<serviceState> _handleCapNhatGiaTri(updateButtonPressed event) async* {
   try {
     if (event.selectedIndex>=0) {
       // lấy danh sách các document
       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
           .collection('service').get();
       // Lấy DocumentSnapshot tương ứng với selectedIndex
       DocumentSnapshot selectedDocument = querySnapshot.docs[event
           .selectedIndex];
       //tham chiếu toi document đó để sửa
       await selectedDocument.reference.update({
         'loaidichvu': event.giaTriMoi
       });
       Fluttertoast.showToast(msg: 'update thành công');
       //cập nhật lại dropdown
       List<String> danhsachmoi = await _fetchLoaiDichVuList();
       yield LoadedDichVuList(danhsachmoi);
     }
   }
    catch(error)
    {
      yield SendingError(error: "Cập nhật giá trị thất bại: $error");
    }
}
  Stream<serviceState> _handledeleteGiaTri(deleteButtonPressed event) async*{
    try {
      if (event.selectedIndex >= 0) {
        // lấy danh sách các document
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('service').get();
        // Lấy DocumentSnapshot tương ứng với selectedIndex
        DocumentSnapshot selectedDocument = querySnapshot.docs[event
            .selectedIndex];
        //tham chiếu toi document đó để sửa
        await selectedDocument.reference.delete();
        Fluttertoast.showToast(msg: 'xóa thành công');
        //cập nhật lại dropdown
        List<String> danhsachmoi = await _fetchLoaiDichVuList();
        yield LoadedDichVuList(danhsachmoi);
      }
    }
    catch(error)
    {
      yield SendingError(error: "Gửi thất bại: $error");
    }
  }
}

  Future<void> _pushservice(themButtonPressed event) async{
  try{
    CollectionReference Appointment =
    FirebaseFirestore.instance.collection('service');
    await Appointment.doc(event.loaidichvu).set({
      'loaidichvu': event.loaidichvu,
    });
  }
  catch(error){
    print("Error storing loaidichvu in Firestore: $error");
  }
}
Stream<serviceState> _handleFetchDichVuList() async* {
  try {
    // Lấy dữ liệu từ Firestore
    List<String> danhSachGiaTri = await _fetchLoaiDichVuList();

    // Trả về danh sách giá trị như là một trạng thái
    yield LoadedDichVuList(danhSachGiaTri);
  } catch (error) {
    yield SendingError(error: "Lấy dữ liệu thất bại: $error");
  }
}
Future<List<String>> _fetchLoaiDichVuList() async {
  try {
    CollectionReference serviceCollection =
    FirebaseFirestore.instance.collection('service');
    QuerySnapshot querySnapshot = await serviceCollection.get();

    // Trích xuất giá trị từ tất cả các trường 'loaidichvu' trong các tài liệu
    List<String> danhSachGiaTri = [];
    querySnapshot.docs.forEach((doc) {
      // Lấy giá trị từ trường 'loaidichvu' và thêm vào danh sách
      String loaiDichVu = doc.get('loaidichvu').toString();
      danhSachGiaTri.add(loaiDichVu);
    });

    return danhSachGiaTri;
  } catch (error) {
    print("Lỗi khi lấy danh sách loaidichvu từ Firestore: $error");
    throw error;
  }
}



