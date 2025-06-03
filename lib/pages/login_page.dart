import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/components/sign_in_button.dart';
import '../widgets/components/textfields.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onTap});

  final Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final emailnameController = TextEditingController();
  final passwordController = TextEditingController();


  void signUserIn() async {
    showDialog(
      context: (context),
      barrierDismissible: false,
      builder: (context) =>  const Center(child: CircularProgressIndicator())
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailnameController.text,
        password: passwordController.text);

        if(mounted) {
          Navigator.pop(context);
        }
        } on FirebaseAuthException catch (e){

              if (mounted) {
                Navigator.pop(context);
              }


    if (e.code == 'invalid-email') {
      showErrorMessage('No account found for this email');
    } else if (e.code == 'invalid-credential') {
      showErrorMessage('Wrong password please try again');
    } else {
      
      showErrorMessage('Please make sure your data is correct');
    }
    }
  }


void showErrorMessage(String textmessage) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(textmessage),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const SizedBox(height: 50),
            
                //logo

                  const SizedBox(
                  height: 10,
                  ),

                  const Text(
                    'EnivroWatch',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    ),
            
            
                 const SizedBox(height: 25),
            
                Text('Welcome Back!',
                style: TextStyle(color: Colors.grey[700],
                fontSize: 16,
                ),
                ),
            
                const SizedBox(height: 25,),

                InputTextField(
                  controller: emailnameController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10,),
            
                InputTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 10,),
            
              const SizedBox(height: 25),
            
              SignInButton(onTap: signUserIn, text: 'Sign In',),
            
              const SizedBox(height: 50),
            
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Row(
                  children: [
            
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('Not a user yet?',
                    style: TextStyle(
                      color: Colors.grey[700],
                      ),
                    ),
                      const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register now',
                      style: TextStyle(color:
                        Colors.blue,
                        fontWeight: FontWeight.bold,
                                  
                        ),
                      ),
                    ),
                    ],
              )
            
              ],
            ),
          ),
              ]
        ),
      ),
      )
      )
    );
  }
}