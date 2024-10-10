import 'package:Peetie/forgot_pssw.dart';
import 'package:Peetie/sheetscolumn.dart';
import 'package:Peetie/signup.dart';
import 'package:Peetie/timer.dart';
import 'package:http/http.dart' as http;

import 'general_func.dart';
import 'googlesheets.dart';
import 'homepage.dart';
import 'inputbox.dart';
import 'libraries.dart';

class SendGridAPI {
  final String apiKey = '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';

  Future<bool> sendEmail({required String toEmail, required String otp, required bool isReset}) async {
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    var body = isReset?
        jsonEncode({
          "personalizations": [{
            "To": [{"email": toEmail}],
            "Subject": "Account Verification"
          }
          ],
          "From": {"email": "daothihaan@gmail.com"},
          "content": [{
            "type": "text/html",
            "value": """
            <html lang='en'>
            <body>
              <p style='font-size:14px;'>Dear User,</p>
              <h3>Verify your account to reset your password.</h3>
              <p>
                Your OTP code is:   <span style='color:red; font-size: 18px'>$otp</span>
               </p>
              <p><i>Note: OTP is valid for 5 minutes.</i></p>
              <br>
              <p>Regards,</p>
              <p>Dancesmart's team</p>
            </body>
          </html>
          """
          }
          ]
        }) :
        jsonEncode({
          "personalizations": [{
            "To": [{"email": toEmail}],
            "Subject": "Account Verification"
        }],
          "From": {"email": "daothihaan@gmail.com"},
          "content": [{
            "type": "text/html",
            "value": """
              <html lang='en'>
              <body>
                <h2>Welcome to Peetie!</h2>
                <p>Thank you for being our member</p>
                <p>
                  Your OTP code is:   <span style='color:red; font-size: 18px'>$otp</span>
                 </p>
                <p><i>Note: OTP is valid for 5 minutes.</i></p>
                <br>
                <p>Regards,</p>
                <p>Dancesmart's team</p>
              </body>
            </html>
            """
        }]
      });

    final response = await http.post(url, headers: headers, body: body);

    if (kDebugMode) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      if (kDebugMode) {
        print('Send email successfully!');
      }
      return true;
    }

    if (kDebugMode) {
      print('Unsuccessfully send email: ${response.body}');
    }
    return false;
  }
}

class OTPverify extends StatefulWidget {
  final String email;
  final String? name;
  final String? password;
  final bool isResetPssw;

  const OTPverify({Key? key, required this.email, required this.name, required this.password, required this.isResetPssw}) : super(key: key);

  @override
  State<OTPverify> createState() => _OTPverifyState();
}

class _OTPverifyState extends State<OTPverify> {
  late EmailAuth emailAuth;
  final List<TextEditingController> _digitControllers =
        List.generate(4, (index) => TextEditingController()); // Controllers for each digit input box
  bool _isLoading = false;
  String _createOTP = '';
  DateTime? _otpExpiryTime;
  final List<GlobalKey<FormState>> _otpBoxKeys = List.generate(4, (index) => GlobalKey<FormState>()); // Create keys for each OTPBox here
  Future<bool>? _otpFuture;
  // Create a key for the TimerCountdown widget
  Key _timerKey = UniqueKey();  // This will force a rebuild when the key changes


  @override
  void initState() {
    super.initState();
    setState(() {
      _otpExpiryTime = null;
      _otpFuture = _sendOTP();
    });
  }

  Future<bool> _verifyOTP() async {
    if (!mounted) return false;
    setState(() {_isLoading = true;});

    // Get OTP digits from each controller
    String enteredOTP = _digitControllers.map((controller) => controller.text).join('');

    setState(() {_isLoading = false;});

    if (enteredOTP.length != 4) {
      showValidationDialog(context, 'WARNING!', ['Please enter the complete 4-digit OTP.']);
      return false;
    }

    if (_otpExpiryTime == null) {
      showValidationDialog(context, 'WARNING!', ['OTP is expired!\nPlease resend code.']);
      return false;
    }

    if (_createOTP == enteredOTP) {
      if (!widget.isResetPssw) {
        _insertToSheet();
      }
      return true;
    }

    showValidationDialog(context, 'WARNING!', ['Incorrect OTP!\nPlease enter again.']);
    return false;
  }

  String _generateOtp() {
    int num = Random().nextInt(10000);
    if (num < 10) return '000$num';
    if (num >= 10 && num <= 99) return '00$num';
    if (num > 99 && num < 1000) return '0$num';
    return num.toString();
  }

  Future<bool> _sendOTP() async {
    String otp = _generateOtp();  // Generate OTP
    bool result = await SendGridAPI().sendEmail(toEmail: widget.email, otp: otp, isReset: widget.isResetPssw);

    if (result) {
      if (!mounted) return false;  // Ensure widget is still mounted before setting state
      setState(() {
        _createOTP = otp;
        _timerKey = UniqueKey();
        _otpExpiryTime = DateTime.now().add(
            const Duration(minutes: 5)); // OTP valid for 5 minutes
      });
      _clearOTPFields();
      showValidationDialog(context, ':)', ['Send OTP to your email successfully!']);
      return true;
    }
    else {
      if (mounted) {
        showValidationDialog(context, 'WARNING!', ['Failed to send OTP to your email.\nPlease try again.']);
      }
      return false;
    }
  }

  Future<void> _insertToSheet() async {   // Insert Data into Google Sheet:
    try {
      setState(() {_isLoading = true;});
      final user = User(name: widget.name, gmail: widget.email, pssw: widget.password);
      await SheetsAPI.insert([user.toJson()]);

      if (kDebugMode) {
        print("Data inserted successfully!");
        print("Name: ${widget.name}");
        print("Email: ${widget.email}");
        print("Password: ${widget.password}");
      }

      if (!mounted) return;
      Navigator.pushReplacement(  //prevent going back to OTP screen
          context,
          MaterialPageRoute(builder: (context) => const HomePage())
      );
    }
    catch (e) {
      if (kDebugMode) {
        print("Error inserting data: $e");
      }
      showValidationDialog(context, 'WARNING!', ['Register unsuccessfully :(\nPlease try again.']);
    }
    finally {
      setState(() {_isLoading = false;});
    }
  }


  void _clearOTPFields() {
    for (var controller in _digitControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: _otpFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: LoadingScreen());
          }
          else if (snapshot.hasError) {
            return const Center(child: Text('SNAPSHOT HAS ERROR!'));
          }
          else if (!snapshot.hasData) {
            return const Center(child: Text('SNAPSHOT DOES NOT HAVE DATA!'));
          }
          else if (snapshot.data == false) {
            return const Center(child: Text('SNAPSHOT\'S LATEST DATA IS FALSE!'));
          }
          else {
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    color: const Color(0xffbf592b),
                    child: Column(
                      children: [
                        Row(      // BACK arrow
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.isResetPssw) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const EmailVerify()));
                                  }
                                  else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignUpHome()));
                                  }
                                },
                                child: const Image(
                                  image: AssetImage('assets/images/white_left_arrow.png'),
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
                        const SizedBox(height: 20),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ' Account',
                              style: titleStyle
                            ),
                            SizedBox(width: 20,),
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
                        const SizedBox(height: 15),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verification',
                              style: titleStyle
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Check your email inbox.\nThen, please enter the 4-digit code\nsent to your email.',
                              style: inputLabelStyle
                            )
                          ],
                        ),
                        const SizedBox(height: 30),

                        TimerCountdown(
                          key: _timerKey,  // Use the key here to force rebuild on resending the code
                          enableDescriptions: false,
                          format: CountDownTimerFormat.minutesSeconds,
                          timeTextStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[700]
                          ),
                          colonsTextStyle: const TextStyle(
                              color: Colors.white
                          ),
                          endTime: _otpExpiryTime ?? DateTime.now(),
                          onEnd: () async {
                            if (!mounted) return;
                            if (kDebugMode) {
                              print("Timer finished");
                            }
                            WidgetsBinding.instance.addPostFrameCallback((_) {    // ensures that the navigation happens after the current frame is fully rendered.
                              if (mounted) {
                                if (kDebugMode) {
                                  print("Expiration notification in Timer");
                                }
                                showValidationDialog(context, 'WARNING!', ['OTP is expired!\nPlease resend code.']);
                                setState(() {
                                  _createOTP = '';
                                  _otpExpiryTime = null;
                                });
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OTPBox(
                                key: _otpBoxKeys[0],
                                textController: _digitControllers[0],
                              ),
                              const SizedBox(width: 7),

                              OTPBox(
                                key: _otpBoxKeys[1],
                                textController: _digitControllers[1],
                              ),
                              const SizedBox(width: 7),

                              OTPBox(
                                key: _otpBoxKeys[2],
                                textController: _digitControllers[2],
                              ),
                              const SizedBox(width: 7),

                              OTPBox(
                                key: _otpBoxKeys[3],
                                textController: _digitControllers[3],
                              ),
                            ]
                        ),
                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _sendOTP();
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 2.5),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.white,
                                              width: 1.5
                                          )
                                      )
                                  ),
                                  child: const Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

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
                              if (await _verifyOTP()) {
                                if (!context.mounted) return;
                                if (widget.isResetPssw) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          ResetPssw(email: widget.email)));
                                }
                                else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (
                                          context) => const HomePage()));
                                }
                              }
                            },
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_isLoading) const LoadingScreen()
                ],
              );
          }
        }
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _digitControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

