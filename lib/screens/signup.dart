// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, avoid_print

import 'package:bustank/components/loading.dart';
import 'package:bustank/home_page.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _Key = GlobalKey<ScaffoldState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  String? gender;
  String groupValue = 'male';
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
      body: SafeArea(
        child: user.status == Status.Authenticating
            ? Loading()
            : Stack(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[350]!, blurRadius: 20.0)
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: ListView(
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
                                      controller: _nameTextController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Full name",
                                        icon: Icon(Icons.person_outline),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "The name field cannot be empty";
                                        }
                                        return null;
                                      },
                                    ),
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
                                              // r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              //r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex =
                                              RegExp(pattern.toString());
                                          if (!regex.hasMatch(value)) {
                                            return 'Please make sure your email address is valid';
                                          }
                                        }
                                      },
                                    ),
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
                                        icon: Icon(Icons.remove_red_eye,
                                            size: 20.0),
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
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey.withOpacity(0.3),
                                  elevation: 0.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: ListTile(
                                      title: TextFormField(
                                        controller: _confirmPasswordController,
                                        obscureText: hidePass,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Confirm Password",
                                          icon: Icon(Icons.lock),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "The password field cannot be empty";
                                          } else if (value.length < 6) {
                                            return "the password has to be at least 6 characters long";
                                          } else if (_passwordTextController
                                                  .text !=
                                              value) {
                                            return "the password do not match";
                                          }
                                          return null;
                                        },
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.remove_red_eye,
                                              size: 20.0),
                                          onPressed: () {
                                            setState(() {
                                              hidePass != hidePass;
                                            });
                                          }),
                                    ),
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
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "address",
                                          icon: Icon(Icons.home),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "The address field cannot be empty";
                                          }
                                          return null;
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
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.grey.withOpacity(0.3),
                                  elevation: 0.0,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "male",
                                            textAlign: TextAlign.end,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          trailing: Radio(
                                              value: 'male',
                                              groupValue: groupValue,
                                              onChanged: (e) =>
                                                  valueChanged(e)),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            "female",
                                            textAlign: TextAlign.end,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          trailing: Radio(
                                              value: 'female',
                                              groupValue: groupValue,
                                              onChanged: (e) =>
                                                  valueChanged(e)),
                                        ),
                                      ),
                                    ],
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
                                        if (await user.signUp(
                                            _nameTextController.text,
                                            _emailTextController.text,
                                            _passwordTextController.text,
                                            _addressController.text)) {
                                          setState(() {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage()));
                                          });
                                        } else {
                                          Future.delayed(Duration(seconds: 2));
                                          print("key $_Key");
                                          Fluttertoast.showToast(
                                              msg: "Sign up failed");
                                        }
                                      }
                                    },
                                    minWidth: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Sign Up",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(16.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: <Widget>[
                              //       Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Text(
                              //           "or sign in with",
                              //           style: TextStyle(
                              //               fontSize: 18, color: Colors.grey),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: MaterialButton(
                              //             onPressed: () async {
                              //               // FirebaseUser user = await auth.googleSignIn();
                              //               // if(user==null){
                              //               //   _userServices.createUser({
                              //               //     "name":user.displayName,
                              //               //     "photo":user.photoUrl,
                              //               //     "email":user.email,
                              //               //     "userId":user.uid
                              //               //   });
                              //               //   changeScreenReplacment(context, MyHomePage());
                              //               // }
                              //             },
                              //             child: Image.asset(
                              //               "image/g-logo.png",
                              //               width: 30,
                              //             )),
                              //       ),
                              //     ],
                              //   ),
                              // )
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

  valueChanged(e) {
    setState(() {
      if (e == 'male') {
        groupValue = e;
        gender = e;
      } else if (e == 'female') {
        groupValue = e;
        gender = e;
      }
    });
  }

  // Future validateForm() async {
  //   FormState formState = _formKey.currentState;
  //   Map value;
  //   var id = Uuid();
  //   if (formState.validate()) {
  //     FirebaseUser user = await firebaseAuth.currentUser();
  //     String userId = await id.v1();
  //     value = {
  //       "username": _nameTextController.text,
  //       "email": _emailTextController.text,
  //       "userId": userId,
  //       "gender": gender,
  //     };
  //     if (user == null) {
  //       firebaseAuth
  //           .createUserWithEmailAndPassword(
  //           email: _emailTextController.text,
  //           password: _passwordTextController.text)
  //           .then((user) => {_userServices.createUser(value)})
  //           .catchError((err) => {print(err.toString())});
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => MyHomePage()));
  //     }
  //   }
  // }

  void changeScreen(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  void changeScreenReplacment(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget));
  }
}
