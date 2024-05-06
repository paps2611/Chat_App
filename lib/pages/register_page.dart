import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  void signUp() async {
    if (passwordController.text != confirmpasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Password doesnt match!')));
      return ;
    }
    final authService = Provider.of<AuthService>(context,listen: false);
    try {
      await authService.signUpWithEmailAndPassword(
          emailController.text,
          nameController.text,
          passwordController.text,
      );
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0 ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),

                  Icon(
                    Icons.message,
                    size: 80,
                  ),

                  Text('Lets Create An Account For You :)',
                      style: TextStyle(
                        fontSize: 16,
                      )
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obsecureText: false,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  MyTextField(
                      controller: nameController,
                      hintText: "Name",
                      obsecureText: false),

                  const SizedBox(
                    height: 25,
                  ),

                  MyTextField(
                    controller: passwordController,
                    hintText: "password",
                    obsecureText: true,
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                    MyTextField(
                    controller: confirmpasswordController,
                    hintText: "confirm password",
                    obsecureText: true,
                    ),

                    const SizedBox(
                    height: 50,
                    ),


                  MyButton(
                    onTap: signUp,
                    text:"Sign Up",
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a member?'),

                      const SizedBox(
                        width: 4,
                      ),

                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Login Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

