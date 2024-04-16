import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routers/PhoneLoginRouter.dart';

class PhoneLoginState extends State<PhoneLoginRouter> {
  late final TextEditingController _phoneController;
  late final TextEditingController _codeController;
  int _countdown = 60;
  bool checked = false;

  @override
  void initState() {
    super.initState();

    _phoneController = TextEditingController();
    _codeController = TextEditingController();

    _phoneController.addListener(() {
      onEditChange();
    });

    _codeController.addListener(() {
      onEditChange();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _phoneController.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(
              child: Text(
                '欢迎使用DEMO APP',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Center(
              child: Text(
                '若该手机号未注册，我们将自动为您注册',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 52),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('pic/icon_phone.png'),
                      width: 23,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 17, right: 17),
                      width: 240,
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                            hintText: '请输入手机号', border: InputBorder.none),
                      ),
                    ),
                    getCloseView()
                  ],
                ),
                SizedBox(
                  width: 280,
                  child: Divider(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 29),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('pic/icon_code.png'),
                      width: 23,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 17, right: 17),
                      width: 180,
                      child: TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                            hintText: '验证码', border: InputBorder.none),
                      ),
                    ),
                    Container(
                      child: getCodeView(),
                      width: 85,
                    )
                  ],
                ),
                SizedBox(
                  width: 280,
                  child: Divider(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          /**
           * 隐私政策
           */
          Padding(
            padding: EdgeInsets.only(top: 26, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: checked,
                  onChanged: (v) {
                    setState(() {
                      checked = v!;
                    });
                  },
                ),
                getPrivacyView()
              ],
            ),
          ),
          /**
           * 登录按钮
           */
          getLoginBtnView()
          /**
           * 密码登录
           */
          ,
          GestureDetector(
            onTap: () {},
            child: Container(
                margin: EdgeInsets.only(top: 24),
                child: Text(
                  "密码登录",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
          )
        ],
      ),
    );
  }

  // 获取登录按钮
  Container getLoginBtnView() {
    return Container(
      width: 280,
      margin: EdgeInsets.only(top: 40, left: 45, right: 45),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                isCanLogin() ? Color(0xff3b7bee) : Color(0xffcacaca)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22)))),
        child: Text(
          "登录",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () {
          if (isCanLogin()) {
            login();
          }
        },
      ),
    );
  }

  // 能否登录
  isCanLogin() {
    return isPhoneNotEmpty() && isCodeNotEmpty() && checked;
  }

  // 清空手机号
  void clearPhone() {
    setState(() {
      _phoneController.clear();
    });
  }

  // 点击验证码
  void clickGetCode() {
    //  立刻-1
    setState(() {
      _countdown--;
    });
    // 延迟1s-1
    const oneSec = const Duration(seconds: 1);
    Timer _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_countdown == 0) {
            _countdown = 60;
            timer.cancel();
          } else {
            _countdown--;
          }
        });
      },
    );
  }

  // 输入框文本变化
  void onEditChange() {
    setState(() {});
  }

  // 获取关闭按钮
  getCloseView() {
    String phone = _phoneController.text;
    String code = _codeController.text;
    bool checkSuccess = phone.isNotEmpty && code.isNotEmpty;
    return Visibility.maintain(
      child: GestureDetector(
        child: Image(
          image: AssetImage('pic/icon_close.png'),
          width: 21,
        ),
        onTap: () {
          clearPhone();
        },
      ),
      visible: checkSuccess,
    );
  }

  // 获取验证码
  getCodeView() {
    if (_countdown == 60) {
      return GestureDetector(
        child: Text(
          '获取验证码',
          style: TextStyle(
              color: isPhoneNotEmpty() ? Colors.black : Colors.grey,
              fontSize: 16),
        ),
        onTap: () {
          if (isPhoneNotEmpty()) {
            clickGetCode();
          }
        },
      );
    } else {
      return Text(
        "$_countdown" "s",
        style: TextStyle(color: Colors.black, fontSize: 16),
      );
    }
  }

  isPhoneNotEmpty() {
    return _phoneController.text.isNotEmpty;
  }

  isCodeNotEmpty() {
    return _codeController.text.isNotEmpty;
  }

  // 登录
  login() async {
    try {
      // 创建httpClient
      HttpClient httpClient = HttpClient();
      String url = "https://v2.api-m.com/api/weather?city=广东珠海";
      // 打开http连接
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      // 等待连接服务器（会将请求信息发给服务器）
      HttpClientResponse response = await request.close();
      // 读取响应内容
      String data = await response.transform(utf8.decoder).join();
      print('请求成功:' + data);
      //关闭client后，通过该client发起的所有请求都会终止
      httpClient.close();
    } catch (e) {
      print('请求失败:' + e.toString());
    }
  }

  // 获取隐私政策
  getPrivacyView() {
    return Expanded(
        child: Wrap(
      children: [
        Text('请认真阅读并同意'),
        GestureDetector(
          onTap: () {
            clickUserAgreement();
          },
          child: Text(
            '用户协议',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        Text('、'),
        GestureDetector(
          onTap: () {},
          child: Text(
            '隐私政策',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        Text('、'),
        GestureDetector(
          onTap: () {},
          child: Text(
            '儿童隐私协议',
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    ));
  }

  // 点击用户协议
  void clickUserAgreement() {
    Navigator.pushNamed(context, 'webRouter',
        arguments: ['https://www.baidu.com']);
  }
}
