import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/model/authentication.dart';
import 'package:kuku/styles/theme.dart' as Theme;
import 'package:kuku/utils/bubble_indication_painter.dart';
import 'package:kuku/utils/constant.dart';
import 'forgotpasswordpage.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  //by default error text will be hidden
  bool loginErrorVisibility = false;
  bool signupErrorVisibility = false;

  //circular progressbar after login or signup click
  bool signinWaiting = false;
  bool signupWaiting = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Constant.selectedColor,
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height >= 775.0
                      ? MediaQuery.of(context).size.height
                      : 775.0,
                  color: Constant.selectedColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: new Image(
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                            image: new AssetImage('images/logo.png')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: _buildMenuBar(context),
                      ),
                      Expanded(
                        flex: 2,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (i) {
                            if (i == 0) {
                              setState(() {
                                right = Colors.white;
                                left = Colors.black;
                              });
                            } else if (i == 1) {
                              setState(() {
                                right = Colors.black;
                                left = Colors.white;
                              });
                            }
                          },
                          children: <Widget>[
                            new ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: _buildSignIn(context),
                            ),
                            new ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: _buildSignUp(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  @override
  void dispose() {
    myFocusNodeEmailLogin.dispose();
    myFocusNodePasswordLogin.dispose();

    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();

    // loginEmailController.dispose();
    // loginEmailController.dispose();

    // signupEmailController.dispose();
    // signupNameController.dispose();
    // signupPasswordController.dispose();

    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      elevation: 4.0,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Raleway"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Raleway"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 210.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "This field can't be empty";
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
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
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            validator: (value) {
                              if (value.isEmpty)
                                return "This field can't be empty";
                              return null;
                            },
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FlutterIcons.lock_faw5s,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextLogin
                                      ? FlutterIcons.eye_faw5
                                      : FlutterIcons.eye_slash_faw5,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 190.0),
                color: Constant.selectedColor,
                elevation: 4.0,
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    onPressed: () => loginButtonPressed()),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()));
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0),
                )),
          ),
          Visibility(
            visible: signinWaiting,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 3,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Constant.selectedColor),
              ),
            ),
          ),
          loginErrorVisibility ? errorTextWidget() : Container(),
          orSeperatorWidget(),
          fgAccounts(),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 290.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeName,
                            controller: signupNameController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "This field can't be empty";
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FlutterIcons.user_faw5,
                                color: Colors.black,
                              ),
                              hintText: "Name",
                              hintStyle: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodeEmail,
                            controller: signupEmailController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "This field can't be empty";
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FlutterIcons.envelope_faw5,
                                color: Colors.black,
                              ),
                              hintText: "Email Address",
                              hintStyle: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            focusNode: myFocusNodePassword,
                            controller: signupPasswordController,
                            validator: (value) {
                              if (value.isEmpty)
                                return "This field can't be empty";
                              return null;
                            },
                            obscureText: _obscureTextSignup,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FlutterIcons.lock_faw5s,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FlutterIcons.eye_faw5
                                      : FlutterIcons.eye_slash_faw5,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(top: 270.0),
                color: Constant.selectedColor,
                elevation: 4,
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    ),
                    onPressed: () => singupButtonPressed()),
              ),
            ],
          ),
          SizedBox(height: 30),
          Visibility(
            visible: signupWaiting,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Constant.selectedColor),
            ),
          ),
          signupErrorVisibility ? errorTextWidget() : Container(),
          orSeperatorWidget(),
          fgAccounts(),
        ],
      ),
    );
  }

  errorTextWidget() {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text('Email or Password is wrong',
            style: TextStyle(color: Colors.red)));
  }

  orSeperatorWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white10,
                    Colors.white,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
            child: Text(
              "OR",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white10,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  fgAccounts() {
    return Padding(
      padding: EdgeInsets.only(top: 1.0),
      child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 1.25,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 8,
                  child: RaisedButton(
                    padding: EdgeInsets.all(13),
                    color: Color.fromRGBO(70, 99, 139, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    onPressed: () {
                      signInWithFacebook();
                    },
                    child: Text(
                      'Facebook',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                  )),
              Spacer(
                flex: 1,
              ),
              Expanded(
                  flex: 8,
                  child: RaisedButton(
                    padding: EdgeInsets.all(13),
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    onPressed: () {
                      signInWithGoogle();
                    },
                    child: Text(
                      'Google',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                  )),
            ],
          )),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  //singup and login with facebook and login
  void signInWithGoogle() async {
    try {
      startSigninProgressbar();
      startSignupProgressbar();

      BaseAuth auth = new Auth();
      String result = await auth.signInWithGoogle();
      print(result);
      navigateAndReplace(page: HomePage());
    } on PlatformException catch (e) {
      print(e.details.toString());
      print(e.message);
      if (e.code == 'network_error')
        stopProgreessbarAndShowScafold('Check your internet connection');
      else
        stopProgreessbarAndShowScafold(e.code);
    } catch (error) {
      setState(() {
        print(error.toString());
        signinWaiting = false;
        signupWaiting = false;
        showInSnackBar(error.toString());
      });
    }
  }

  stopProgreessbarAndShowScafold(message) {
    setState(() {
      signinWaiting = false;
      signupWaiting = false;
      showInSnackBar(message);
    });
  }

  void signInWithFacebook() async {
    try {
      startSigninProgressbar();
      startSignupProgressbar();

      BaseAuth auth = new Auth();
      String result = await auth.signInWithFacebook();
      if (result == 'success') {
        navigateAndReplace(page: HomePage());
      } else {
        signinWaiting = false;
        signupWaiting = false;
        setState(() {
          if (result == 'CONNECTION_FAILURE: CONNECTION_FAILURE') {
            showInSnackBar('Check your internet connection');
          } else {
            showInSnackBar(result);
          }
        });
      }
    } catch (error) {
      setState(() {
        print(error.toString());
        signinWaiting = false;
        signupWaiting = false;
        showInSnackBar(error.toString());
      });
    }
  }

  //login and signup through gmail and password
  loginButtonPressed() async {
    if (_formKey.currentState.validate()) {
      try {
        startSigninProgressbar();
        BaseAuth auth = new Auth();
        String uid = await auth.signIn(
            loginEmailController.text, loginPasswordController.text);
        print('uid: $uid');
        if (uid != null) {
          print('hi');
          Constant.useruid = uid;
          navigateAndReplace(page: HomePage());
        }
      } catch (error) {
        print('error during signin: ' + error.toString());
        print('error message signin: ' + error.code.toString());
        if (error.code == 'network-request-failed') {
          stopProgreessbarAndShowScafold('Check your internet connection');
        }
        // else if (error.code == 'user-not-found') {
        //   stopProgreessbarAndShowScafold('User not found. Check ');
        // }
        setState(() {
          signinWaiting = false;
          loginErrorVisibility = true;
        });
      }
    }
  }

  singupButtonPressed() async {
    if (_formKey.currentState.validate()) {
      try {
        startSignupProgressbar();
        BaseAuth auth = new Auth();
        await auth.signUp(signupNameController.text, signupEmailController.text,
            signupPasswordController.text);
      } catch (error) {
        print('error during signin: ' + error.toString());
        print('error message signin: ' + error.code.toString());
        if (error.code == 'network-request-failed') {
          stopProgreessbarAndShowScafold('Check your internet connection');
        } else if (error.code == 'invalid-email') {
          stopProgreessbarAndShowScafold('Please enter correct email');
        } else if (error.code == 'weak-password') {
          stopProgreessbarAndShowScafold(
              'Password should be at least 6 characters');
        }
        setState(() {
          signupWaiting = false;
        });
      }
    }
  }

  //navigation
  navigateAndReplace({@required page}) {
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => page));
  }

  //progess bar animation
  startSigninProgressbar() {
    setState(() {
      signinWaiting = true;
    });
  }

  startSignupProgressbar() {
    setState(() {
      signupWaiting = true;
    });
  }
}
