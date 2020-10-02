import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/form_validator.dart';
import 'package:kuku/model/authentication.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final FocusNode myFocusNodeEmail = FocusNode();
  TextEditingController emailController = TextEditingController();
  FormValidator _formValidator = FormValidator();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Constant.selectedColor,
        body: Constant.primiumThemeSelected
            ? PremiumContainer(
                child: mainBody(),
                gradient: Constant.selectedGradient,
              )
            : NonPremiumContainer(
                child: mainBody(),
                color: Constant.selectedColor,
              ));
  }

  Widget mainBody() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text('Reset Password',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextFormField(
                  focusNode: myFocusNodeEmail,
                  controller: emailController,
                  validator: (value) {
                    if (!_formValidator.validateEmail(email: value))
                      return "Invalid Email";
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      FlutterIcons.envelope_faw5,
                      color: Colors.black,
                      size: 22.0,
                    ),
                    hintText: "Email Address",
                    hintStyle: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Card(
            color: Constant.selectedColor,
            elevation: 4.0,
            child: MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: const Color(0xFFf7418c),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 42.0),
                  child: Text(
                    "Send Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ),
                onPressed: () => forgotPasswordEvent()),
          ),
        ],
      ),
    );
  }

  forgotPasswordEvent() async {
    if (_formKey.currentState.validate()) {
      BaseAuth auth = Auth();
      await auth.sendPasswordResetEmail(email: emailController.text);
      showInSnackBar(
          'A Password reset link has been sent to ${emailController.text}');
    }
  }

  showInSnackBar(String value) {
    // FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
      elevation: 4.0,
      backgroundColor: Colors.yellowAccent[700],
      duration: Duration(seconds: 3),
    ));
  }
}
