import 'package:Peetie/forgot_pssw.dart';
import 'package:Peetie/signup.dart';

import 'general_func.dart';
import 'googlesheets.dart';
import 'homepage.dart';
import 'inputbox.dart';
import 'libraries.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  bool _isLoading = false;
  late TextEditingController _mailController;
  late TextEditingController _psswController;

  String _inputMail = '';
  String _inputPssw = '';

  @override
  void initState() {
    super.initState();
    _mailController = TextEditingController();
    _psswController = TextEditingController();
  }


  Future<bool> _checkInput() async {
    if (!mounted) return false;
    setState(() {
      _isLoading = true;
    });

    _inputMail = _mailController.text;
    _inputPssw = _psswController.text;

    bool trueMail = false, truePssw = false;
    List<String> mess = [];

    if (_inputMail.isEmpty) {
      mess.add('Input your email!');
    }
    else if (!_inputMail.contains('@gmail.com')) {
      mess.add("Invalid Email Address");
    }
    else if (_inputPssw.isEmpty) {
      mess.add("Input your password!");
    }
    else { // Check if email has correct password
      String? dataPssw = await SheetsAPI.getPasswordForEmail(_inputMail);
      if (dataPssw == null) {
        mess.add('Email is not registered!');
      } else {
        trueMail = true;
        if (_inputPssw != dataPssw) {
          mess.add('Incorrect password!');
        } else {
          truePssw = true;
        }
      }
    }

    if (!(trueMail && truePssw)) {
      if (!mounted) return false;
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      showValidationDialog(context, 'INVALID!', mess);
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignUpHome()));
                                  },
                                  child: const Image(
                                    image: AssetImage('assets/images/left_arrow.png'),
                                    filterQuality: FilterQuality.high,
                                    width: 60,
                                  ),
                                ),
                              ),

                              const Image(
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
                                'Sign In',
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
                            children: <Widget>[
                              Text('Email', style: inputLabelStyle),
                            ],
                          ),
                          InputBox(
                            hintTexts: 'xxx@gmail.com',
                            textController: _mailController,
                            isPssw: false,
                          ),

                          const Row(
                            children: <Widget>[
                              Text('Password', style: inputLabelStyle),
                            ],
                          ),
                          InputBox(
                            textController: _psswController,
                            isPssw: true,
                            hintTexts: '',
                          ),
                          const SizedBox(height: 20,),

                          SizedBox(
                            width: 100,
                            height: 35,
                            child: OutlinedButton(
                              style: bottomButtonStyle,
                              onPressed: ()  async {
                                if (await _checkInput()) {
                                  if (!context.mounted) return;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomePage())); // go to OTP verification step
                                }
                              },
                              child: const Text(
                                'Sign In',
                                style: buttonLabelStyle
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const EmailVerify()));
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.yellow[700],
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
                  const LoadingScreen()
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mailController.dispose();
    _psswController.dispose();
    super.dispose();
  }
}
