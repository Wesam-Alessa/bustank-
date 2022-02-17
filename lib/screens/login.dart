// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, implementation_imports

import 'package:bustank/components/loading.dart';
import 'package:bustank/home_page.dart';
import 'package:bustank/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/rendering/object.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _Key = GlobalKey<ScaffoldState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      key: _Key,
      body: SafeArea(
        child: user.status == Status.Authenticating
            ? Loading()
            : Stack(
                children: <Widget>[
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 20.0)
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: Image.asset(
                                    'image/bustank-logo.png',
                                    width: 260.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey.withOpacity(0.3),
                                  elevation: 0.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: TextFormField(
                                        controller: _emailTextController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          icon: Icon(Icons.alternate_email),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            Pattern pattern =
                                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                            RegExp regex =  RegExp(pattern.toString());
                                            if (!regex.hasMatch(value))
                                              // ignore: curly_braces_in_flow_control_structures
                                              return 'Please make sure your email address is valid';
                                            else
                                              // ignore: curly_braces_in_flow_control_structures
                                              return null;
                                          }
                                        }),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey.withOpacity(0.3),
                                  elevation: 0.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: ListTile(
                                      title: TextFormField(
                                        controller: _passwordTextController,
                                        obscureText: hidePass,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          icon: Icon(Icons.lock_outline),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "The password field cannot be empty";
                                          } else if (value.length < 6) {
                                            return "the password has to be at least 6 characters long";
                                          }
                                          return null;
                                        },
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            hidePass = false;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.blueGrey,
                                  elevation: 0.0,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (await user.signIn(
                                            _emailTextController.text,
                                            _passwordTextController.text)) {
                                          // Status.Authenticated;
                                          //user.status = Status.Authenticated;
                                          Future.delayed(Duration(seconds: 2));
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => MyHomePage()));
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text("Sign in failed")));
                                        }
                                      }
                                    },
                                    minWidth: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Login",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        "Forgot Password",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUp()));
                                      },
                                      child: Text(
                                        "Create an account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "or sign in with",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MaterialButton(
                                          onPressed: () {},
                                          child: Image.asset(
                                            "image/g-logo.png",
                                            width: 30,
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
