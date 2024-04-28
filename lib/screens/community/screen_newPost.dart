import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:seoul/screens/community/db_connect_test/send_db_server.dart';

import '../../models/model_board.dart';

class newPostScreen extends StatefulWidget {
  const newPostScreen({super.key});
  @override
  State<newPostScreen> createState() => _newPostScreen();
}

class _newPostScreen extends State<newPostScreen> {
  var _userEnterBody = '';
  bool showSpinner = false;

  final _bodyController = TextEditingController();
  final picker = ImagePicker();
  List<XFile?> multiImage = []; // 갤러리에서 선택한 이미지 저장할 변수
  List<XFile?> images = []; // 가져온 사진들 보여주는 변수

  Board createBoard(){

    return Board(
        userId: 1,
        body: _bodyController.text,
        category: 'gold',
        likeCnt: 0,
        commentCnt: 0,
        uploadImageId: 0
    );
  }

  Future<void> _dialogBuilder(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(

            title: Container(
              alignment: Alignment.center,
              child: Text(
                '게시물을 업로드 하시겠습니까?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: Color(0xffcfe6fb),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () async{
                      await saveNewPost(createBoard());
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      side: BorderSide(color: Colors.white), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),

                    ),
                  ),
                  OutlinedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white, // Button background color
                      side: BorderSide(color: Colors.white), // Border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('게시글 작성',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          leading: TextButton(
            child: Text(
              '취소',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,

            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 350, height: 200,
                padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xffcfe6fb),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      _userEnterBody = value;
                    });
                  },
                  controller: _bodyController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '지금 무슨 생각을 하시는 중인가요?',
                    hintStyle: TextStyle(
                      color: Color(0xffabb0bc),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Container(
                width: 350, height: 1, color: Color(0xffd9d9d9),
                margin: EdgeInsets.only(bottom: 20),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('사진 업로드',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                  ),
                )
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 130, height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xffc4c4c4), width: 1),
                ),
                child: IconButton(
                  onPressed: () async {multiImage = await picker.pickMultiImage();
                    setState(() {
                      images.addAll(multiImage);
                    });
                  },
                  icon: Image.asset(
                    'assets/images/uploadImage.png',
                  ),
                  iconSize: 50,
                ),

              ), //사진 추가하기 버튼
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  '사진 추가하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ), //사진 추가하기 text
              Container(
                width: 350, height: 1, color: Color(0xffd9d9d9),
                margin: EdgeInsets.only(bottom: 20),
              ), //실선
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('자주 쓰는 태그 추가',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  )
              ), //자주쓰느태그추가
              Container(
                width: 350, height: 1, color: Color(0xffd9d9d9),
                margin: EdgeInsets.only(bottom: 20),
              ), //실선
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('장소 공유 하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  )
              ), //장소공유하기
              Container(
                width: 202, height: 50,
                child: OutlinedButton(
                  onPressed: (){
                    _dialogBuilder(context);
                  },
                  child: Text('업로드',
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
                )
              ),


            ],
          ),
        ),
      ),
    );
  }
}


