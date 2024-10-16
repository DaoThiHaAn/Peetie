import 'libraries.dart';

class LearnPage extends StatefulWidget{
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();

}

class _LearnPageState extends State<LearnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
          children: const [
            Text('LEARN PAGE')
          ]
      ),
    );
  }

}