import 'libraries.dart';

class ProfilePage extends StatefulWidget{
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     resizeToAvoidBottomInset: true,
     body: ListView(
       children: const [
         Text('PROFILE')
       ]
     ),
   );
  }

}