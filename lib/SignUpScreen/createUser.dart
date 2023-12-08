import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/sign_up/create_user_bloc.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    )) ??
        selectedDate;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>CreateUserBloc(),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 58, 218, 200),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                Image.asset(
                  'assets/image/logo.jpeg',
                  scale: 10,
                ),
                const Text(
                  'Welcome to nha khoa TT',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: "user_email",
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.black,
                      )),
                ),
                TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      )
                  ) ,
                ),
                 TextField(
                  controller: _fullName,
                  decoration: const InputDecoration(
                    hintText: "Họ và tên",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  controller: _phoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "số điện thoại",
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                TextField(
                  controller: _address,
                  decoration: const InputDecoration(
                    hintText: "địa chỉ",
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.datetime,
                  controller: TextEditingController(
                      text: "${selectedDate.toLocal()}".split(' ')[0]),
                  decoration: InputDecoration(
                    hintText: "Ngày sinh",
                    prefixIcon: const Icon(Icons.date_range),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                ),

                RawMaterialButton(
                  fillColor: const Color.fromARGB(255, 155, 155, 55),
                  onPressed: () {
                    BlocProvider.of<CreateUserBloc>(context).add(
                        RegisterButtonPressed(
                          email: _emailController.text,
                          password: _passwordController.text,
                          fullName: _fullName.text,
                          phoneNumber: _phoneNumber.text,
                          address: _address.text,
                          dateOfBirth: selectedDate,
                        ),
                    );
                  },
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: 50,
                  ),
                  child: const Text('ĐĂNG KÝ'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
