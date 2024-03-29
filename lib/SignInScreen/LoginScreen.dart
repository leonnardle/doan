import 'package:doan/SignUpScreen/createUser.dart';
import 'package:doan/View/Home_Page/HomePage.dart';
import 'package:doan/main.dart';
import 'package:doan/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';

import '../ProfileScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // login functicon
  static Future<User?> loginUsingEmailpassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    // lệnh này đợi và trả về đối tượng rồi từ đó lấy đối tượng đó để thực hiện thao tác xác thực
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("khong tim thay user nay");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController =
        TextEditingController(text: "test@gmail.com");
    TextEditingController _passwordController =
        TextEditingController(text: "00000000");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(

       child: SingleChildScrollView(
         child: Form(
           child: Center(
             child: Container(

               padding: const EdgeInsets.all(20.0),
               child: Column(
                 children: [

                   const Text(
                     'Welcome To Nha Khoa TT',
                     style: TextStyle(
                       color: Colors.black,
                       fontSize: 25,
                       fontWeight: FontWeight.bold,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(
                     height: 23,
                   ),
                   TextFormField(
                     style: const TextStyle(
                       fontSize: 20,
                     ),
                     controller: _emailController,
                     keyboardType: TextInputType.emailAddress,
                     decoration: const InputDecoration(
                       //hintText: "user email",
                       label: Text('Email',style: TextStyle(
                         color: Colors.deepPurpleAccent,
                       ),),
                       prefixIcon: Icon(
                         Icons.mail,
                         color: Colors.black,
                       ),
                     ),
                   ),
                   const SizedBox(
                     height: 30,
                   ),
                   TextField(
                     controller: _passwordController,
                     keyboardType: TextInputType.visiblePassword,
                     obscureText: true,
                     decoration: const InputDecoration(
                       hintText: "user password",
                       prefixIcon: Icon(
                         Icons.lock,
                         color: Colors.black,
                       ),
                     ),
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [

                       TextButton(onPressed: () {}, child: const Text('Quên mật khẩu?'),

                       ),
                     ],
                   ),
                   const SizedBox(
                     height: 23,
                   ),
                   Container(
                     width: double.infinity,
                     child: RawMaterialButton(

                       fillColor: Colors.lightBlue,
                       elevation: 0.0,
                       padding: const EdgeInsets.all(15.0),
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(40.0),
                           side: const BorderSide(color: Colors.white, width: 3.0)

                       ),

                       onPressed: () async {
                         User? user = await loginUsingEmailpassword(
                             email: _emailController.text,
                             password: _passwordController.text,
                             context: context);
                         if (user != null) {
                           // Kiểm tra xem email có phải là "trungquocle636@gmail.com" không
                           if (user.email == "trungquoc@gmail.com") {
                             // Nếu đúng, chuyển hướng đến màn hình AdminScreen
                             Navigator.pushAndRemoveUntil(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => const service(),
                               ),
                                   (route) =>
                               false, // Điều này loại bỏ tất cả các màn hình khỏi ngăn xếp.
                             );
                           } else {
                             // Nếu không phải là email trên, chuyển hướng đến màn hình ProfileScreen
                             Navigator.pushAndRemoveUntil(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => const Home_Page(),
                               ),
                                   (route) =>
                               false, // Điều này loại bỏ tất cả các màn hình khỏi ngăn xếp.
                             );
                           }
                         } else {
                           showToast('Không tìm thấy người dùng, hãy đăng ký');
                         }
                       },
                       child: const Text(
                         'Đăng nhập',
                         style: TextStyle(
                             fontSize: 24,
                             color: Colors.black87,
                             fontWeight: FontWeight.bold),
                       ),
                     ),
                   ),//đăng nhập
                   const SizedBox(height: 30),
                   const SizedBox(height: 10,),
                   const Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Expanded(child: Divider(
                         thickness: 0.7,
                         color: Colors.black45,
                       )),
                       Padding(padding: EdgeInsets.symmetric(
                         vertical: 0,
                         horizontal: 10,
                       ),
                         child: Text('Đăng nhập khác', style: TextStyle(
                           color: Colors.black45,
                         ),),
                       ),
                       Expanded(child: Divider(
                         thickness: 0.7,
                         color: Colors.black45,)),
                     ],
                   ),
                   const SizedBox(height: 13,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                     children: [

                       IconButton(onPressed: (){},icon: Logo(Logos.facebook_f),
                       ),
                       IconButton(onPressed: (){},icon: Logo(Logos.twitch),
                       ),
                       IconButton(onPressed: (){},icon: Logo(Logos.gmail),
                       ),
                       IconButton(onPressed: (){},icon: Logo(Logos.apple),
                       ),
                     ],
                   ),// dang nhap khac
                   const SizedBox(height: 15,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text('Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                       ),
                       GestureDetector(
                         onTap: (){
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (e)=> CreateUser(),
                           ),
                           );
                         },
                         child: Text('Sign up', style: TextStyle(
                           color: Colors.lightBlue
                         ),),
                       )
                     ],
                   ),
                 ],
               ),
             ),
           ),
         ),
       ),
      ),
    );
  }

  void showToast(String Message) => Fluttertoast.showToast(
        msg: "không thấy người dùng , có muốn đăng ký ?",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
}
