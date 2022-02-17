// ignore_for_file: avoid_print, prefer_const_constructors, sized_box_for_whitespace, invalid_use_of_visible_for_testing_member

import 'package:bustank/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _key = GlobalKey<ScaffoldState>();
  File? _image;
  final String _bio =
      "\"Hi, We are Bostank Foundation, working around the clock. If you want to contact us to present your product, call the establishment number.\"";

  Future<void> getImage() async {
    var i = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    File image = File(i!.path);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context);
    FirebaseDatabase _database = FirebaseDatabase.instance;
    final storage = FirebaseStorage.instance;
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    String ref = "users";
    String id = userProvider.user.uid;
    String? imageUrl1;
    String picture1 = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
    storage.ref().child(picture1).putFile(_image!).then((t) {
      t.ref.getDownloadURL().then((value) {
        imageUrl1 = value;
      });
    });
    _database.ref().child("users/$id").update(
        {"picture": imageUrl1}).catchError((e) => {print(e.toString())});

    _fireStore.collection(ref).doc(id).update({
      'picture': imageUrl1,
    });
    setState(() {
      print("Profile Picture uploaded");
    });
  }

  _buildCoverImage() {
    return Container(
      height: 215,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('image/farm3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _buildProfileImage() {
    final userProvider = Provider.of<UserProvider>(context);
    // Object image =
    // _image!.path.isEmpty  ?
    // FileImage(_image!)
    //     :
    // NetworkImage(userProvider.userFetcher.getPicture,);

    return Container(
      height: 150,
      width: 155,
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (userProvider.userFetcher.getPicture.isNotEmpty)
            CircleAvatar(
                maxRadius: 150,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  userProvider.userFetcher.getPicture,
                )),
          if (_image != null)
            CircleAvatar(
              maxRadius: 150,
              backgroundColor: Colors.white,
              backgroundImage: FileImage(_image!),
            ),
          // child: _image != null ?
          //     ClipRect(
          //       child: Image.file(_image!) ,
          //     ) :
          //     ClipRect(
          //       child:Image.network(userProvider.userFetcher.getPicture,),
          //     )
          //
          //     :
          //
          // Image.file(
          //
          // )
          //     :
          // Image.network(
          //
          //   fit: BoxFit.fill,
          // ),
          // child: ClipOval(
          //   child:
          // ),
          //),
          Positioned(
            bottom: 4,
            right: 0.1,
            child: GestureDetector(
              onTap: () {
                getImage();
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.camera_alt,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFullName() {
    final userProvider = Provider.of<UserProvider>(context);
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      userProvider.userFetcher.getName,
      style: _nameTextStyle,
    );
  }

  _buildStatus() {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        //color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        userProvider.userFetcher.getEmail,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    );

    TextStyle _statCountTextStyle = const TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  _buildStatContainer() {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Favourites",
              userProvider.userFetcher.favourites!.length.toString()),
          _buildStatItem("Orders", userProvider.orders.length.toString()),
          _buildStatItem(
              "Cart Items", userProvider.userFetcher.cart!.length.toString()),
        ],
      ),
    );
  }

  _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      //color: Colors.yellowAccent,
      //Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  _buildSeparator() {
    return Container(
      width: 250,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  _buildButtons() {
    final userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async {
                uploadPic(context);
                await userProvider.reloadUserFetcher();
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () {
                userProvider.reloadUserFetcher();
                Navigator.of(context).pop();
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    // return SafeArea(
    //   child: Scaffold(
    //     body:   Container(
    //         child: Column(
    //           children: <Widget>[
    //             Container(
    //               height: 240,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.only(
    //                     bottomRight: Radius.circular(40.0),
    //                     bottomLeft: Radius.circular(40.0),
    //                   ),
    //                   image: DecorationImage(
    //                     image:AssetImage('image/farm3.jpg'),
    //                     fit: BoxFit.fill,
    //                   )
    //               ),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: <Widget>[
    //                   Row(
    //                     children: <Widget>[
    //                       Padding(
    //                         padding: EdgeInsets.only(top:0.0),
    //                         child: IconButton(
    //                           icon: Icon(
    //                             Icons.arrow_back,
    //                             size: 30.0,
    //                             color: Colors.white,
    //                           ),
    //                           onPressed: () {
    //                             userProvider.reloadUserFetcher();
    //                             Navigator.pop(context);
    //                           },
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: <Widget>[
    //                       SizedBox(
    //                         width: 10.0,
    //                       ),
    //                       Align(
    //     //                         alignment: Alignment.center,
    //     //                         child: CircleAvatar(
    //     //                           radius: 80,
    //     //                           child: ClipOval(
    //     //                             child: new SizedBox(
    //     //                               width: 160.0,
    //     //                               height: 160.0,
    //     //                               child:
    //     //                               (_image != null) ? Image.file(
    //     //                                 _image,
    //     //                                 fit: BoxFit.fill,
    //     //                               ):
    //     //                               Image.network(
    //     //                                 "${userProvider.userFetcher.picture}",
    //     //                                 fit: BoxFit.fill,
    //     //                               ),
    //     //                             ),
    //     //                           ),
    //     //                         ),
    //     //                       ),
    //                       Padding(
    //                         padding: EdgeInsets.only(top: 140.0),
    //                         child: IconButton(
    //                           icon: Icon(
    //                             Icons.camera_alt,
    //                             size: 30.0,
    //                             color: Colors.white,
    //                           ),
    //                           onPressed: () {
    //                             getImage();
    //                           },
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(
    //               height: 20.0,
    //             ),
    //             Row(
    //               children: <Widget>[
    //                 Align(
    //                   child: Container(
    //                     child: Row(
    //                       children: <Widget>[
    //                         SizedBox(width: 20,),
    //                         Text('User name',
    //                               style: TextStyle(
    //                                   color: Colors.blueGrey, fontSize: 18.0)),
    //                          SizedBox(width: 10,),
    //                          Text('${userProvider.userFetcher.name}',
    //                               style: TextStyle(
    //                                   color: Colors.black,
    //                                   fontSize: 20.0,
    //                                   fontWeight: FontWeight.bold)),
    //
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Container(
    //               margin: EdgeInsets.all(20.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: <Widget>[
    //                   Text('Email',
    //                       style:
    //                       TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
    //                   SizedBox(width: 50.0),
    //                   Text('${userProvider.user.email}',
    //                       style: TextStyle(
    //                           color: Colors.black,
    //                           fontSize: 20.0,
    //                           fontWeight: FontWeight.bold)),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               child: Row(
    //                 children: <Widget>[
    //                   SizedBox(width: 20,),
    //                   Text('Order',
    //                       style: TextStyle(
    //                           color: Colors.blueGrey, fontSize: 18.0)),
    //                   SizedBox(width: 50,),
    //                   Text('${userProvider.orders.length}',
    //                       style: TextStyle(
    //                           color: Colors.black,
    //                           fontSize: 20.0,
    //                           fontWeight: FontWeight.bold)),
    //
    //                 ],
    //               ),
    //             ),
    //             SizedBox(
    //               height: 20.0,
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: <Widget>[
    //                 RaisedButton(
    //                   color: Colors.blueGrey,
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   elevation: 4.0,
    //                   splashColor: Colors.blueGrey,
    //                   child: Text(
    //                     'Cancel',
    //                     style: TextStyle(color: Colors.white, fontSize: 16.0),
    //                   ),
    //                 ),
    //                 RaisedButton(
    //                   color: Colors.blueGrey,
    //                   onPressed: () async{
    //                     uploadPic(context);
    //                     await userProvider.reloadUserFetcher();
    //                   },
    //                   elevation: 4.0,
    //                   splashColor: Colors.blueGrey,
    //                   child: Text(
    //                     'Submit',
    //                     style: TextStyle(color: Colors.white, fontSize: 16.0),
    //                   ),
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     ),
    // );
    return SafeArea(
      child: Scaffold(
          key: _key,
          body: Builder(
            builder: (BuildContext context) {
              return Stack(
                children: <Widget>[
                  _buildCoverImage(),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 120),
                      _buildProfileImage(),
                      _buildFullName(),
                      _buildStatus(),
                      _buildStatContainer(),
                      _buildBio(context),
                      _buildSeparator(),
                      SizedBox(height: 10.0),
                      //_buildGetInTouch(context),
                      SizedBox(height: 8.0),
                      _buildButtons(),
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }
}
