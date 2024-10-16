//import 'general_func.dart';

import 'dart:convert' as convert;

import 'package:Peetie/general_func.dart';
import 'package:Peetie/learn.dart';
import 'package:Peetie/mappage.dart';
import 'package:Peetie/profile.dart';
import 'package:http/http.dart' as http;

import 'libraries.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            indicatorColor: Colors.pink[60],
            //labelBehavior: ,
            selectedIndex: currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Explore'
              ),
              NavigationDestination(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Map'
              ),
              NavigationDestination(
                  icon: Icon(Icons.school_outlined),
                  label: 'Learn'
              ),
              NavigationDestination(
                  icon: Icon(Icons.perm_identity_outlined),
                  label: 'Profile'
              ),
            ]
        ),
        body: <Widget>[
          SafeArea(  // HOMEPAGE
            child: Stack(
              children: [
                Column(
                  children: [
                    Flexible(
                        flex: 2,
                        child: Container(color: Colors.deepOrange[200])
                    ),
                    Flexible(
                        flex: 5,
                        child: Container(color: Colors.pink[40])
                    )
                  ],
                ),
                Scrollbar(
                  thickness: 7.0,
                  radius: const Radius.circular(10.0),
                  child: ListView(
                    padding: const EdgeInsets.all(10.0),
                    children: [
                      const Align(
                          alignment: Alignment.center,
                          child: NewsOfTheDay()
                      ),
                      const SizedBox(height: 15.0,),
                  
                      Align(
                        alignment: Alignment.centerLeft, // Align the button to the left
                        child: TextButton.icon(
                          onPressed: () {  },
                          label: const Text(
                            'Care',
                            style:  TextStyle(
                              fontFamily: 'More Sugar',
                              fontSize: 20,
                              color: Color(0xff1B4781),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xff1B4781),
                          ),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                      const CareList(),
                      const SizedBox(height: 15.0,),
                  
                      Align(
                        alignment: Alignment.centerLeft, // Align the button to the left
                        child: TextButton.icon(
                          onPressed: () {  },
                          label: const Text(
                            'Curious',
                            style:  TextStyle(
                              fontFamily: 'More Sugar',
                              fontSize: 20,
                              color: Color(0xff1B4781),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xff1B4781),
                          ),
                          iconAlignment: IconAlignment.end,
                        ),
                      ),
                      const SizedBox(height: 15.0,),
                     const CuriousList()
                    ],
                  ),
                ),
              ],
            )
          ),

          const MapPage(),

          const LearnPage(),

          const ProfilePage()
        ][currentPageIndex]
    );
  }
}

class NewsOfTheDay extends StatefulWidget {
  const NewsOfTheDay({Key? key}) : super(key: key);

  @override
  State<NewsOfTheDay> createState() => _NewsOfTheDay();
}

class _NewsOfTheDay extends State<NewsOfTheDay> {
  late NewsOfTheDayModel _newsOfTheDayModel;
  bool _isLoading = false;

  getNewsOfTheDayFromSheet() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var articleRaw = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbzV58xKEanNTh4VC909vz77f2-nbHhAFG8toqkBEwtaGEZfW4AOwZLndE0HNSOA56wF/exec'));
      var jsonArticle = convert.jsonDecode(articleRaw.body);
      if (kDebugMode) {
        print('Article:\n$jsonArticle\n--------------\n');
      }

      setState(() {
        _newsOfTheDayModel = NewsOfTheDayModel.fromJson(jsonArticle[0]);
        _isLoading = false;
      });
    }
    catch(e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Failed to fetch article: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getNewsOfTheDayFromSheet();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 330,
        child: const Card(
          clipBehavior: Clip.hardEdge,
          child: LoadingScreen(),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (kDebugMode) {
            print('News-of-the-date Card tapped.');
          }
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompleteNewsPage(content: _newsOfTheDayModel.body,))
          );
        },
        child: Container(
          color: Colors.deepOrange[300],
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)
                ),
                child: Image(
                  image: NetworkImage(_newsOfTheDayModel.image),
                  height: 330,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    if (kDebugMode) {
                      print('Loading image');
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    if (kDebugMode) {
                      print('Failed to load image');
                    }
                    return const Text(
                    'Failed to load image :(((',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 10
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 7.0,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _newsOfTheDayModel.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins ExtraBold',
                          fontSize: 20,
                          color: Color(0xff14345F)
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    const Image(
                        width: 90,
                        image: AssetImage('assets/images/logo1.png')
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}

class NewsOfTheDayModel {
    late String title;
    late String image;
    late String body;

    NewsOfTheDayModel({required this.title, required this.image, required this.body});

    factory NewsOfTheDayModel.fromJson(dynamic json) {
      return NewsOfTheDayModel(
          title: "${json['title']}",
          image: '${json['image']}',
          body: '${json['body']}'
      );
    }

    Map toJson() => {
      'title': title,
      'image': image,
      'body': body
    };
}

// TODO
class CareList extends StatefulWidget {
  const CareList({Key? key}) : super(key: key);

  @override
  State<CareList> createState() => _CareListState();

}

class _CareListState extends State<CareList>{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Scrollbar(
        thickness: 7.0,
        radius: const Radius.circular(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              children: [
                Container(
                  width: 160,
                  color: Colors.red,
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 160,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 160,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 160,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

//TODO
class CuriousList extends StatefulWidget {
  const CuriousList({Key? key}) : super(key: key);

  @override
  State<CuriousList> createState() => _CuriousList();

}

class _CuriousList extends State<CuriousList>{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Scrollbar(
        thickness: 7.0,
        radius: const Radius.circular(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              children: [
                Container(
                  width: 160,
                  color: Colors.red,
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 160,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 160,
                  color: Colors.blue,
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 160,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//TODO
class CompleteNewsPage extends StatefulWidget {
  final String content;

  const CompleteNewsPage({Key? key, required this.content}) : super(key: key);

  @override
  State<CompleteNewsPage> createState() => _CompleteNewsPage();

}

class _CompleteNewsPage extends State<CompleteNewsPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
                'News Of The Day',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.deepOrange[100],
            shadowColor: Colors.red[50],
          ),
          body: Scrollbar(
            thickness: 7.0,
            radius: const Radius.circular(10.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  color: Colors.white,
                  child: Text( // todo
                      widget.content,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xff1A1717)
                      ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}