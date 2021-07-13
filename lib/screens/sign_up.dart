import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:investment_portfolio/components/loading.dart';
import 'package:investment_portfolio/components/loading_overlay.dart';
import 'package:investment_portfolio/helper.dart';
import 'package:investment_portfolio/models/user.dart';
import 'package:provider/provider.dart';
import 'package:investment_portfolio/components/rounded_button.dart';
import 'package:investment_portfolio/constants.dart';
import 'package:investment_portfolio/models/auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = new TextEditingController(
    text: Helper.generateString(6) + '@gmail.com',
  );
  final passwordController = new TextEditingController(text: 'menglove');
  final nameController = new TextEditingController(text: 'Test');
  bool _isLoading = false;

  PickedFile? pickedFile;

  uploadAvatar() async {
    if (pickedFile == null) {
      return;
    }

    final file = File(pickedFile!.path);

    String fileName = Helper.generateString(16);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');

    TaskSnapshot taskSnapshot = await firebaseStorageRef.putFile(file);

    return taskSnapshot.ref.getDownloadURL();
  }

  _signUpCallback() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await Auth.signUp(
        context: context,
        email: emailController.text,
        password: passwordController.text,
      );

      final auth = User.fromFirebaseAuthUserWithName(
        userCredential.user!,
        nameController.text,
      );

      auth.profileUrl = await uploadAvatar();
      print("Done upload avatar: ${auth.profileUrl}");

      auth.persist();
      print(userCredential);

      await userCredential.user!.updateDisplayName(auth.name);
      await userCredential.user!.updatePhotoURL(auth.profileUrl);

      Auth.afterAuthenticatedFromFirebase(context, userCredential);

      Navigator.pop(context);
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _selectAvatarCallback() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LoadingOverlay(
          isLoading: _isLoading,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildAvatar(),
                TextButton(
                  child: Text('Select an avatar'),
                  onPressed: _selectAvatarCallback,
                ),
                SPACE_BETWEEN_ELEMENT,
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  controller: nameController,
                ),
                SPACE_BETWEEN_ELEMENT,
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'khmer@gmail.com',
                  ),
                  controller: emailController,
                ),
                SPACE_BETWEEN_ELEMENT,
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: '********',
                  ),
                  controller: passwordController,
                ),
                SPACE_BETWEEN_ELEMENT,
                SPACE_BETWEEN_ELEMENT,
                RoundedButton(
                  text: 'Sign Up',
                  minWidth: double.infinity,
                  height: 50,
                  onPressed: _signUpCallback,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildAvatar() {
    return Container(
      width: 75,
      height: 75,
      child: pickedFile != null
          ? GestureDetector(
              onTap: _selectAvatarCallback,
              child: FutureBuilder(
                future: pickedFile!.readAsBytes(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(
                            snapshot.data as Uint8List,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(75),
                      ),
                    );
                  }

                  return Loading();
                },
              ),
            )
          : FlutterLogo(),
    );
  }
}
