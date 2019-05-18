import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workshop/presentation/ui_components/Alerts.dart';
import 'package:flutter_workshop/presentation/ui_components/LoadableWidget.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';
import 'package:flutter_workshop/resources/ImageRes.dart';
import 'package:flutter_workshop/resources/StringRes.dart';
import 'package:flutter_workshop/services/Authentication.dart';
import 'package:flutter_workshop/services/PhotoService.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String _photoUrl;
  String _name;
  String _email;
  String _password;
  String _errorMessage;

  FormMode _formMode = FormMode.LOGIN;
  bool _isLoading;
  bool isPhotoUploading = false;
  UploadPhotoTask currentTask;

  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate() &&
        (_formMode == FormMode.LOGIN ||
            _formMode == FormMode.SIGNUP && _photoUrl != null)) {
      form.save();
      return true;
    }

    if (_formMode == FormMode.SIGNUP && _photoUrl == null) {
      setState(() {
        _errorMessage = StringRes.emptyAvatar;
      });
    }

    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_name, '', _email, _password);
          print('Signed up user: $userId');
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
          _formMode = FormMode.LOGIN;
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadableWidget(
      loading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringRes.auth),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _showBody(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _showPrimaryButton(),
              _showSecondaryButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(StringRes.verifyTitle),
          content: Text(StringRes.verifyMessage),
          actions: <Widget>[
            FlatButton(
              child: Text(StringRes.dismiss),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showNameInput(),
              _showEmailInput(),
              _showPasswordInput(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    if (_formMode == FormMode.LOGIN) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset(ImageRes.flutter),
        ),
      );
    } else {
      return GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                  color: ColorRes.darkIndigo5,
                  shape: BoxShape.circle,
                  image: _photoUrl == null
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_photoUrl),
                        ),
                  border: Border.all(color: ColorRes.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: ColorRes.black40,
                      offset: Offset(0.0, 3),
                      blurRadius: 6,
                    ),
                  ]),
            ),
            isPhotoUploading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : Container()
          ],
        ),
        onTap: _openChooseDialog,
      );
    }
  }

  Widget _showEmailInput() {
    final double topPadding = _formMode == FormMode.SIGNUP ? 15 : 100;

    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, topPadding, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: StringRes.email,
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? StringRes.emptyEmail : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showNameInput() {
    if (_formMode != FormMode.SIGNUP) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        autofocus: false,
        decoration: InputDecoration(
            hintText: StringRes.name,
            icon: Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? StringRes.emptyName : null,
        onSaved: (value) => _name = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: StringRes.password,
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? StringRes.passwordEmpty : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return FlatButton(
      child: _formMode == FormMode.LOGIN
          ? Text(StringRes.createAccount,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : Text(StringRes.signIn,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: RaisedButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: _formMode == FormMode.LOGIN
                ? Text(StringRes.login,
                    style: TextStyle(fontSize: 20.0, color: ColorRes.white))
                : Text(StringRes.createAccount,
                    style: TextStyle(fontSize: 20.0, color: ColorRes.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  void _openChooseDialog() async {
    ImageSourceType type = await _showImageSourceDialog(context);
    if (type != null) {
      getImage(type);
    }
  }

  Future<ImageSourceType> _showImageSourceDialog(BuildContext context) async {
    return showDialog<ImageSourceType>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(StringRes.imageResource),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ImageSourceType.CAMERA);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(StringRes.camera),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ImageSourceType.GALLERY);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(StringRes.gallery),
                ),
              ),
            ],
          );
        });
  }

  Future getImage(ImageSourceType type) async {
    ImageSource imageSource;

    switch (type) {
      case ImageSourceType.CAMERA:
        imageSource = ImageSource.camera;
        break;

      case ImageSourceType.GALLERY:
        imageSource = ImageSource.gallery;
        break;
    }

    var image = await ImagePicker.pickImage(source: imageSource);
    _cropImage(image);
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      toolbarColor: ColorRes.darkIndigo,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (croppedFile != null) {
      setState(() {
        isPhotoUploading = true;
      });

      currentTask?.task?.cancel();

      currentTask = PhotoService.instanse.uploadPhoto(croppedFile);

      currentTask.task.onComplete.then((result) {
        if (result.error != null) {
          setState(() {
            isPhotoUploading = false;
          });
          showOperationFailedAlert(context, retry: () => _cropImage(imageFile));
        } else {
          _getDownLoadUrl(result);
        }
      });
    }
  }

  Future<void> _getDownLoadUrl(StorageTaskSnapshot result) async {
    _photoUrl = await result.ref.getDownloadURL();

    setState(() {
      isPhotoUploading = false;
    });
  }
}

enum ImageSourceType { CAMERA, GALLERY }
