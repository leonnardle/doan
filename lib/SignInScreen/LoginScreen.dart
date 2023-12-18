import 'package:doan/SignUpScreen/createUser.dart';
import 'package:doan/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    TextEditingController _emailController = TextEditingController(text: "test@gmail.com");
    TextEditingController _passwordController = TextEditingController(text: "00000000");

    return Scaffold(body: Container(
      color: const Color.fromARGB(52, 194, 60, 100),
      child:
      Expanded(child:
      Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo.jpeg',
              scale: 10,
            ),
            const Text(
              'Welcome To Nha Khoa TT',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                //hintText: "user email",

                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
            const Row(
              children: [
                Text(
                  'quên mật khẩu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color.fromARGB(255, 155, 155, 55),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                onPressed: () async {
                  User? user = await loginUsingEmailpassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context);
                  if (user != null) {
                    // Kiểm tra xem email có phải là "trungquocle636@gmail.com" không
                    if (user.email == "trungquocle636@gmail.com") {
                      // Nếu đúng, chuyển hướng đến màn hình AdminScreen
                       Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => service(),
                        ),
                            (route) => false, // Điều này loại bỏ tất cả các màn hình khỏi ngăn xếp.
                      );

                    } else {
                      // Nếu không phải là email trên, chuyển hướng đến màn hình ProfileScreen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                            (route) => false, // Điều này loại bỏ tất cả các màn hình khỏi ngăn xếp.
                      );

                    }
                  } else {
                    showToast('Không tìm thấy người dùng, hãy đăng ký');
                  }

                },
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color.fromARGB(255, 155, 155, 55),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateUser()));
                },
                child: const Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    )));
  }
  void showToast(String Message)=> Fluttertoast.showToast(
    msg: "không thấy người dùng , có muốn đăng ký ?",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
