import 'package:flutter/material.dart';

const TextStyle inputLabelStyle = TextStyle(
  fontSize: 15,
  color: Colors.white,
);

const TextStyle titleStyle = TextStyle(
  fontFamily: 'Poppins ExtraBold',
  fontSize: 26,
  color: Colors.white,
  fontWeight: FontWeight.w900
);

const TextStyle buttonLabelStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold,
);

ButtonStyle bottomButtonStyle = OutlinedButton.styleFrom(
  backgroundColor: const Color(0xffbf592b),
  side: const BorderSide(color: Colors.white, width: 2.0),
  padding: const EdgeInsets.symmetric(),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
);

Future<void> showValidationDialog(BuildContext context, String title, List<String> messages) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
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

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height,
        color: Colors.black.withOpacity(0.5),
        child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 5.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            )
        )
    );
  }
}