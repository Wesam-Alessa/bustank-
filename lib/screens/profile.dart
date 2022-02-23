// ignore_for_file: avoid_print, prefer_const_constructors, sized_box_for_whitespace, invalid_use_of_visible_for_testing_member, prefer_typing_uninitialized_variables

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
  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  late var userProvider;

  String ref = "users";
  String id = '';
  bool loading = false;
  File? _image;
  final String _bio =
      "\"Hi, We are Bostank Foundation, working around the clock. If you want to contact us to present your product, call the establishment number.\"";

  @override
  void initState() {
    // TODO: implement initState
    userProvider = Provider.of<UserProvider>(context, listen: false);
    id = userProvider.user.uid;
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    _name.dispose();
    _address.dispose();
  }

  Future<void> getImage() async {
    var i = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    File image = File(i!.path);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    FirebaseDatabase _database = FirebaseDatabase.instance;
    final storage = FirebaseStorage.instance;
    String? imageUrl1;
    String picture1 = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";


    storage.ref().child(picture1).putFile(_image!).then((t) {
      t.ref.getDownloadURL().then((value) {
        imageUrl1 = value;
        _fireStore.collection(ref).doc(id).update({
          'picture': value,
        });
      });
    });
    // _database.ref().child("users/$id").update(
    //     {"picture": imageUrl1}).catchError((e) => {print(e.toString())});


  }

  Future<void> _updateUserInfo(
      BuildContext context, String name, String address) async {
    _fireStore.collection(ref).doc(id).update({
      'name': _name.text.isNotEmpty ? _name.text : name,
      'address': _address.text.isNotEmpty ? _address.text : address,
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
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Container(
      height: 150,
      width: 155,
      child: Stack(
        children: <Widget>[
          if (userProvider.userFetcher.getPicture.isNotEmpty)
            CircleAvatar(
                maxRadius: 150,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  userProvider.userFetcher.picture! ,
                )),
          if (_image != null)
            CircleAvatar(
              maxRadius: 150,
              backgroundColor: Colors.white,
              backgroundImage: FileImage(_image!),
            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userProvider.userFetcher.getName,
          style: _nameTextStyle,
        ),
        SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AlertDialog(
                  title: Text('Edit Your Name'),
                  content: Container(
                    height: 150,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "New Name",
                            icon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The name field cannot be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _name.clear();
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.close),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                _updateUserInfo(
                                    context,
                                    _name.text,
                                    userProvider.userFetcher.getAddress
                                ).then((_) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                   userProvider.reloadUserFetcher().then((_) {
                                     _name.clear();
                                     Navigator.of(context).pop();
                                   });
                                });
                              },
                              child: Icon(Icons.check),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: Icon(
            Icons.edit_outlined,
            size: 22,
          ),
        )
      ],
    );
  }

  _buildStatus() {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userProvider.userFetcher.getAddress,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AlertDialog(
                      title: Text('Edit Your Address'),
                      content: Container(
                        height: 150,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _address,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "New Address",
                                icon: Icon(Icons.home_filled),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The address field cannot be empty";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _address.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.close),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _updateUserInfo(
                                        context,
                                        userProvider.userFetcher.getName,
                                        _address.text
                                    ).then((_) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      userProvider.reloadUserFetcher().then((_) {
                                        _address.clear();
                                        Navigator.of(context).pop();
                                      });
                                    });
                                  },
                                  child: Icon(Icons.check),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.edit_outlined,
                size: 22,
              ),
            )
          ],
        ),
      ],
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
              onTap: () async{
                uploadPic(context).then((_){
                   userProvider.reloadUserFetcher().then((_){
                    Navigator.pop(context);
                  });
                });
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
    return Scaffold(
      body : SafeArea(
          key: _key,
          child : Stack(
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
                  SizedBox(height: 8.0),
                  _buildButtons(),
                ],
              ),
            ],
          )
      ),
    );
  }
}
