import 'package:Peetie/general_func.dart';
import 'package:Peetie/googlesheets.dart';
import 'package:Peetie/homepage.dart';
import 'package:Peetie/otp.dart';
import 'package:Peetie/signin.dart';

import 'inputbox.dart';
import 'libraries.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailVerifyState();

}

class _EmailVerifyState extends State<EmailVerify> {
  late TextEditingController _mailController;
  late bool _isLoading;
  late String _inputMail;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _mailController = TextEditingController();
  }

  Future<bool> _checkMail() async {
    if (!mounted) return false;
    setState(() {
      _isLoading = true;
    });

    _inputMail = _mailController.text;
    bool isValid = false;

    if (_inputMail.isEmpty) {
      showValidationDialog(context,'WARNING!', ['Input your email!']);
    }
    else if (!_inputMail.contains('@gmail.com')) {
      showValidationDialog(context,'WARNING!', ["Invalid Email Address"]);
    }
    else {
      List<String> existingEmails = await SheetsAPI.getEmails();
      if (!existingEmails.contains(_inputMail)) {
        if (!mounted) return false;
        showValidationDialog(context, 'WARNING!',
            ['Your email is not registered!\nCreate an account instead.']);
      }
      else {
        isValid = true;
        if (kDebugMode) {
          print('Email is valid');
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    color:  const Color(0xffbf592b),
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        Row(    // BACK arrow
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SignInPage())
                                      );
                                    },
                                  child: const MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Image(
                                      image: AssetImage('assets/images/white_left_arrow.png'),
                                      filterQuality: FilterQuality.high,
                                      width: 60,
                                    ),
                                  ),
                                )
                            ),

                            const Image(
                              image: AssetImage('assets/images/paw.png'),
                              filterQuality: FilterQuality.high,
                              width: 60,
                            ),
                          ],
                        ),
                        const SizedBox(height: 50,),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Email',
                              style: titleStyle
                            ),
                            SizedBox(width: 40,),
                            RotationTransition(
                              turns: AlwaysStoppedAnimation(45/360),
                              child: Image(
                                  image: AssetImage('assets/images/paw2.png'),
                                filterQuality: FilterQuality.high,
                                width: 50,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15,),
                        const Text(
                          'Verification',
                          style: titleStyle,
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          'Enter your email to get the OTP code',
                          style: inputLabelStyle,
                        ),
                        const SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: InputBox(hintTexts: 'xxx@gmail.com', textController: _mailController, isPssw: false),
                        ),
                        const SizedBox(height: 30,),

                        SizedBox(
                          height: 35,
                          width: 100,
                          child: OutlinedButton(
                            style: bottomButtonStyle,
                              onPressed: () async {
                                if (await _checkMail()) {
                                  if (!context.mounted) return;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          OTPverify(
                                              email: _inputMail,
                                              name: null,
                                              password: null,
                                              isResetPssw: true
                                          )
                                      )
                                  );
                                }
                              },
                              child: const Text(
                                  'Verify',
                                  style: buttonLabelStyle,
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(_isLoading) const LoadingScreen()
                ],
              )
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    _mailController.dispose();
    super.dispose();
  }
}


class ResetPssw extends StatefulWidget {
  final String email;

  const ResetPssw({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPssw> createState() => _ResetPasswState();
}

class _ResetPasswState extends State<ResetPssw> {
  late bool _isLoading;
  late TextEditingController _newPsswController;
  late TextEditingController _reenterPsswController;
  late String _newPsswInput;
  late String _reenterPsswInput;

  @override
  void initState() {
    super.initState();
    _newPsswController = TextEditingController();
    _reenterPsswController = TextEditingController();
    _isLoading = false;
  }

  Future<bool> _checkNewPssw() async {
    setState(() {
      _isLoading = true;
    });

    _newPsswInput = _newPsswController.text;
    _reenterPsswInput = _reenterPsswController.text;
    bool isValid = false;

    if (_newPsswInput.isEmpty || _reenterPsswInput.isEmpty) {
      showValidationDialog(context, 'WARNING!', ['Please enter the new password in 2 fields!']);
    }
    else {
      String? dataPssw = await SheetsAPI.getPasswordForEmail(widget.email);
      if (!mounted) return false;

      if (dataPssw == _newPsswInput) {
        showValidationDialog(context, 'WARNING!', [
          'This is your old password!\nEnter the new one or Sign In to continue.'
        ]);
      }
      else if (_newPsswInput.length < 8 ||
          !(RegExp(r'[0-9]').hasMatch(_newPsswInput) && RegExp(r'[a-zA-Z]').hasMatch(_newPsswInput))) {
        showValidationDialog(context, 'WARNING!', ['Password must be at least 8 characters long, and contain number(s) and alphabetical character(s).']);
      }
      else if (_newPsswInput != _reenterPsswInput) {
        showValidationDialog(context, 'WARNING!', ['Two passwords are not identical!']);
      }
      else {
        isValid = true;
        if (kDebugMode) {
          print('Accept new password');
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
    return isValid;
  }
  Future<bool> _modifySheet(String email, String newPssw) async { // Modify only the password value
    try {
      setState(() {_isLoading = false;});
      await SheetsAPI.resetPsswForEmail(email, newPssw);

      if (kDebugMode) {
        print('After modification:\nGmail: $email\nNew password: $newPssw');
      }

      if (!mounted) return false;
      await showValidationDialog(context, ':)', ['Reset your password successfully!']);
    }
    catch (e) {
      if (kDebugMode) {
        print("Error changing password: $e");
      }
      if (!mounted) return false;
      await showValidationDialog(context, 'WARNING!', ['Change Password unsuccessfully :(\nPlease try again.']);
      return false;
    }

    setState(() {_isLoading = false;});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    color:  const Color(0xffbf592b),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        Row(    // BACK arrow
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignInPage())
                                    );
                                  },
                                  child: const MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: MouseRegion(
                                       cursor: SystemMouseCursors.click,
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Image(
                                            image: AssetImage('assets/images/white_left_arrow.png'),
                                            filterQuality: FilterQuality.high,
                                            width: 60,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),

                            const Image(
                              image: AssetImage('assets/images/paw.png'),
                              filterQuality: FilterQuality.high,
                              width: 60,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40,),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                '     Reset',
                                style: titleStyle
                            ),
                            SizedBox(width: 40,),
                            RotationTransition(
                              turns: AlwaysStoppedAnimation(45/360),
                              child: Image(
                                image: AssetImage('assets/images/paw2.png'),
                                filterQuality: FilterQuality.high,
                                width: 50,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15,),
                        const Text(
                          'Password',
                          style: titleStyle,
                        ),
                        const SizedBox(height: 40),

                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'New Password',
                                style: inputLabelStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InputBox(hintTexts: '********', textController: _newPsswController, isPssw: true),
                        ),
                        const SizedBox(height: 30,),

                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Re-enter Password',
                                style: inputLabelStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InputBox(hintTexts: '********', textController: _reenterPsswController, isPssw: true),
                        ),
                        const SizedBox(height: 30,),

                        SizedBox(
                          height: 35,
                          width: 100,
                          child: OutlinedButton(
                              style: bottomButtonStyle,
                              onPressed: () async {
                                if (await _checkNewPssw()) {
                                  if (await _modifySheet(widget.email, _newPsswInput)) {
                                    if (!context.mounted) return;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomePage())
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Verify',
                                style: buttonLabelStyle,
                              )
                          ),
                        ),

                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage()));
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.basic,
                            child: Text(
                              'Sign in',
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
                  ),
                  if(_isLoading) const LoadingScreen()
                ],
              )
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    _reenterPsswController.dispose();
    _newPsswController.dispose();
    super.dispose();
  }
}