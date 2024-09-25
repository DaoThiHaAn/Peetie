import 'package:Peetie/signin.dart';
import 'package:flutter/material.dart';
import 'googlesheets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'inputbox.dart';
import 'main.dart';
import 'otp.dart';

class SignUpHome extends StatefulWidget {
  const SignUpHome({Key? key}) : super(key: key);

  @override
  State<SignUpHome> createState() => _SignUpHomeState();
}

class _SignUpHomeState extends State<SignUpHome> {
  bool _isTapped = false;
  bool _isLoading = false;
  late TextEditingController _nameController;
  late TextEditingController _mailController;
  late TextEditingController _psswController;

  String _inputName = '';
  String _inputMail = '';
  String _inputPssw = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mailController = TextEditingController();
    _psswController = TextEditingController();
  }

  void _showValidationDialog(BuildContext context, List<String> messages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "INVALID!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
              child: Text(messages.join('\n\n'), textAlign: TextAlign.justify)),
          contentPadding: const EdgeInsets.all(20.0),
          actions: [
            ElevatedButton(
              onPressed: () {Navigator.of(context).pop();},  // Close the dialog
              child: const Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _isEmailUnique(String email) async {     //Fetch existing emails from Google Sheet
    List<String> existingEmails = await SheetsAPI.getEmails();
    return !existingEmails.contains(email);
  }

  Future<bool> _checkInput() async {
    if (!mounted) return false;
    setState(() {
      _isLoading = true;
    });

    //await Future.delayed(const Duration(seconds: 3));

    _inputName = _nameController.text;
    _inputMail = _mailController.text;
    _inputPssw = _psswController.text;

    bool trueName = false, trueMail = false, truePssw = false;
    List<String> mess = [];

    if (_inputName.isEmpty ||
        _inputName.length < 2 ||
        RegExp(r'^\d').hasMatch(_inputName)) {
      mess.add("Username must be at least 2 characters long and can not began with a number.");
    } else {
      trueName = true;
    }

    if (_inputMail.isEmpty || !_inputMail.contains('@gmail.com')) {
      mess.add("Invalid Email Address");
    } else {
      // Check Email Uniqueness
      bool isEmailUnique = await _isEmailUnique(_inputMail);
      if (!isEmailUnique) {
        mess.add("This email address is already registered!.\nChoose another name or Sign in to continue.");
      } else {
        trueMail = true;
      }
    }

    if (_inputPssw.length < 8 ||
        !(RegExp(r'[0-9]').hasMatch(_inputPssw) && RegExp(r'[a-zA-Z]').hasMatch(_inputPssw)))
    {
      mess.add(
          "Password must be at least 8 characters long, and contain number(s) and alphabetical character(s).");
    } else {
      truePssw = true;
    }

    if (!(trueName && trueMail && truePssw)) {
      if (!mounted) return false;
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      if (!mounted) return false;
      _showValidationDialog(context, mess);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows the body to resize when the keyboard appears
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      //  1ST PART
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.45,
                      color: const Color(0xffE7F0F1),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image(
                                image: AssetImage('assets/images/paw.png'),
                                filterQuality: FilterQuality.high,
                                width: 60,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Welcome to',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff926D6D),
                                ),
                              ),
                              const SizedBox(height: 20),
                              DefaultTextStyle(
                                style: const TextStyle(
                                  fontFamily: 'More Sugar',
                                  fontSize: 40,
                                  color: Color(0xffBF592B),
                                  fontWeight: FontWeight.w900,
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    WavyAnimatedText(
                                      'Peetie',
                                    )
                                  ],
                                  repeatForever: true,
                                ),
                              )
                            ],
                          ),
                          Animate(
                            autoPlay: true,
                            onPlay: (controller) => controller.repeat(reverse: true),
                            effects: const [
                              ScaleEffect(
                                duration: Duration(seconds: 1),
                                begin: Offset(1, 1), // start scale at original size
                                end: Offset(1.2, 1.2), // end scale at 1.2 times the original size
                              )
                            ],
                            child: Image(
                              image: const AssetImage('assets/images/cat.png'),
                              filterQuality: FilterQuality.high,
                              height: MediaQuery.of(context).size.height * 0.2,
                              //height: 150,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // 2ND PART
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 8),
                      height: MediaQuery.of(context).size.height * 0.65,
                      decoration: const BoxDecoration(
                        color: Color(0xffbf592b),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'New life for your besties',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Poppins ExtraBold',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              RotationTransition(
                                turns: AlwaysStoppedAnimation(45 / 360),
                                child: Image(
                                  image: AssetImage('assets/images/paw2.png'),
                                  filterQuality: FilterQuality.high,
                                  width: 50,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10.0),

                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Name', style: MyApp.customTextStyle),
                            ],
                          ),
                          InputBox(
                            textController: _nameController,
                            hintTexts: 'at least 2 alphabetical digits, not start with a number',
                            isPssw: false,
                          ),

                          const Row(
                            children: <Widget>[
                              Text('Email', style: MyApp.customTextStyle),
                            ],
                          ),
                          InputBox(
                            hintTexts: 'xxx@gmail.com',
                            textController: _mailController,
                            isPssw: false,
                          ),

                          const Row(
                            children: <Widget>[
                              Text('Password', style: MyApp.customTextStyle),
                            ],
                          ),
                          InputBox(
                            hintTexts: 'at least 8 digits (number(s) and alphabet(s))',
                            textController: _psswController,
                            isPssw: true,
                          ),

                          SizedBox(
                            width: 100,
                            height: 35,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xffbf592b),
                                side: const BorderSide(color: Colors.white, width: 2.0),
                                padding: const EdgeInsets.symmetric(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () async {
                                if (await _checkInput()) {
                                  if (!context.mounted) return;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => OTPverify(
                                        email: _inputMail,
                                        password: _inputPssw,
                                        name: _inputName,
                                      ))); // go to OTP verification step
                                }
                                },
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                'Already had an account?',
                                style: TextStyle(fontSize: 13, color: Colors.white),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () {
                                  _isTapped = true;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignInPage()));
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color:
                                      _isTapped ? Colors.yellow[700] : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  Container(
                      height: MediaQuery.sizeOf(context).height,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                          )
                      )
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mailController.dispose();
    _psswController.dispose();
    super.dispose();
  }
}
