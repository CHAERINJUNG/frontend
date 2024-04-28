import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seoul/screens/screen_map.dart';
import 'package:seoul/screens/signup/screen_signup.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//



class _LoginScreenState extends State<LoginScreen> {
  final _authentication = FirebaseAuth.instance;

  bool showSpinner = false;
  final formKey = GlobalKey<FormState>();
  late ScrollController _controller;
  final RestorableDouble _scrollOffset = RestorableDouble(0);

  String useremail = '';
  String userpassword = '';

  void _tryValidation(){
    // 현재 상태가 null인지 확인합니다.
    if (formKey.currentState != null) {
      final isValid = formKey.currentState!.validate();
      if (isValid) {
        formKey.currentState!.save();
      }
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {

      _scrollOffset.value = _controller.offset;

      // 컨트롤러가 SingleChildScrollView에 연결이 됐는지 안돼는지
      _controller.hasClients;
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Replace with your own logo
                FlutterLogo(size: 100),
                SizedBox(height: 30),
                Text.rich(
                  TextSpan(
                    text: '어디서나 나의 ',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '스타',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xffcfe6fb),
                        ),
                      ),
                    TextSpan(
                        text: '와 함께',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width-140,
                  height: 288,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 1)
                  ),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          width: 202, height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xffd9d9d9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) {
                              useremail = value!;
                            },
                            onChanged: (value) {
                              formKey.currentState?.validate();
                              useremail = value;
                            },

                            decoration: InputDecoration(
                              hintText: '아이디 입력', // Username input
                              hintStyle: TextStyle(
                                  color: Color(0xff767676),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 202, height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xffd9d9d9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) {
                              userpassword = value!;

                            },
                            onChanged: (value) {
                              formKey.currentState?.validate();
                              userpassword = value;
                            },

                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '비밀번호 입력', // Username input
                              hintStyle: TextStyle(
                                color: Color(0xff767676),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 202, height: 50,
                          child: OutlinedButton(
                            onPressed: () async{
                              FocusScope.of(context).unfocus();
                              setState(() {
                                showSpinner = true;
                              });
                              try{
                                _tryValidation();
                                final loginUser = await _authentication.signInWithEmailAndPassword(
                                    email: useremail,
                                    password: userpassword,
                                );
                                if (loginUser.user != null){
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context){
                                  //       return MapScreen();
                                  //     })
                                  // );
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              } catch(e){
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('아이디 혹은 비밀번호가 올바르지 않습니다.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                setState(() {
                                  showSpinner = false;
                                });
                              }

                            },
                            child: Text('로그인',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                color: Colors.black
                              ),
                            ),
                            style: OutlinedButton.styleFrom(

                              backgroundColor: Color(0xffcfe6fb), // Button background color
                              side: BorderSide(color: Color(0xffcfe6fb)), // Border color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        SizedBox(
                          width: 100, height: 28,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                  MaterialPageRoute(builder: (context) => SignupScreen()),
                              );
                            },
                            child: Text('처음이신가요?',
                              style: TextStyle(
                                  fontSize: 16,
                                color: Color(0xff767676),
                                decoration: TextDecoration.underline,
                              ),

                            ), // Guest

                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        SizedBox(
                          width: 84, height: 28,
                          child: TextButton(
                            onPressed: () {
                              // Implement guest login logic
                            },
                            child: Text('<GUEST>',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),

                            ), // Guest
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      SizedBox(width: 80,),
                      SizedBox(
                        width: 84, height: 28,
                        child: TextButton(
                          onPressed: () {
                            // Implement guest login logic
                          },
                          child: Text('아이디 찾기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff767676),
                            ),

                          ), // Guest
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),

                      Container(
                        width: 1, height: 17,
                        color: Color(0xff767676),
                      ),

                      SizedBox(
                        width: 84, height: 28,
                        child: TextButton(
                          onPressed: () {
                            // Implement guest login logic
                          },
                          child: Text('비밀번호 찾기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff767676),
                            ),

                          ), // Guest
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      SizedBox(width: 80,),

                    ],
                  ),
                ),

                SizedBox(height: 10,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container( width: 95, height: 1,
                      color: Color(0xff767676),),

                    SizedBox(width: 8,),

                    Text('SNS 계정으로 로그인',
                      style: TextStyle(
                        color: Color(0xff767676),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(width: 8,),

                    Container( width: 95, height: 1,
                      color: Color(0xff767676),),
                  ],
                ),

                SizedBox(height: 15,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 42, height: 42,
                      child: IconButton(
                        padding: EdgeInsets.zero, // 패딩 설정
                        icon: Image.asset('assets/images/Facebook.png'),
                        onPressed: () {
                          // Implement Facebook login logic
                        },
                      ),
                    ),

                    SizedBox(width: 18,),

                    SizedBox(
                      width: 42, height: 42,
                      child: IconButton(
                        padding: EdgeInsets.zero, // 패딩 설정

                        icon: Image.asset('assets/images/apple.png'),
                        onPressed: () {
                          // Implement Facebook login logic
                        },
                      ),
                    ),

                    SizedBox(width: 18,),

                    SizedBox(
                      width: 42, height: 42,
                      child: IconButton(
                        padding: EdgeInsets.zero, // 패딩 설정

                        icon: Image.asset('assets/images/google.png'),
                        onPressed: () {
                          // Implement Facebook login logic
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}