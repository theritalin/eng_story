import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/screens/ShortStoryHome.dart';
import 'package:eng_story/screens/sign_in_screen.dart';
import 'package:eng_story/screens/storyDetail.dart';
import 'package:eng_story/utils/advert_service.dart';
import 'package:eng_story/utils/authentication.dart';
import 'package:eng_story/widgets/HomePageClicks.dart';
import 'package:eng_story/widgets/HomePagePdfClick.dart';
import 'package:eng_story/widgets/app_bar_title.dart';
import 'package:eng_story/widgets/story_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/Story.dart';
import '../res/data.dart';
import 'PdfHomePage.dart';

class HomePage extends StatefulWidget {
  final User user;

  //screen orientation yap gönder
  //

  HomePage({@required this.user});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState(user: user);
  }
}

class HomePageState extends State {

  //Google Ads
  BannerAd _ad;
  bool isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    languageControl();
    readingCheck();
    _ad=BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_){
          setState(() {
            isLoading=true;
          });
        },
        onAdFailedToLoad: (_,error){
          _ad.dispose();



        }
      ),
    );

    _ad.load();

  }

  @override
  void dispose(){
    _ad?.dispose();
    super.dispose();
  }

  //ad checking
  Widget checkforad(){
    if(isLoading==true){
      return Container(
        child: AdWidget(
          ad: _ad, ),
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
        alignment: Alignment.center,
      );

    }else {
      return CircularProgressIndicator(value: 0,

      );
    }
  }

  ///
  final User user;
  HomePageState({@required this.user});
  bool _isSigningOut = false;



  //sign out button route to loginpage
  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final routeToScreens= Container(
      child: Column(
        children: [

          HomePageStoryClick(size:size),
          SizedBox(height: 15,),
          HomePagePdfClick(size:size),
        ],
        )
    );

    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: CustomColors.colorNavy,
        appBar: AppBar(
          elevation: 20,
          backgroundColor: CustomColors.colorNavy,
          title: AppBarTitle(),

          //sign out button
          actions: [
            _isSigningOut
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : signOutButton()
          ],
        ),
        //drawer: DrawerPage(),

        //story names tile
        body: ListView(
          children: [
            checkforad(),
            routeToScreens,
          ],
        )
//         SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Column(
//             children: [
//               checkforad(),
// //story ye yeni malan ekle onu shared ten al
//               FutureBuilder(
//                 future: fireins.collection("stories").get(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//
//                   if (snapshot.hasError) {
//                     return Text(snapshot.error.toString());
//                   }
//
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Container(child: CircularProgressIndicator());
//                   }
//                   final data = snapshot.data;
//
//                   return ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       itemCount: data.size,
//                       itemBuilder: (context, index)  {
//
//                         Story story = new Story(
//                             data.docs[index]["body"],
//                             data.docs[index]["level"],
//                             data.docs[index]["title"],
//                             data.docs[index]["author"],
//
//
//                         );
//
//
//                         return StoryListTile(story: story);
//
//                       });
//                 },
//               ),
//
//             ],
//           ),
//         ),
      ),
    );
  }

//signut button to login page
  signOutButton() {
    return PopupMenuButton(
      child: Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              '${user.displayName}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomColors.colorYellow,
                letterSpacing: 0.5,
              ),
            ),
          ),
      onSelected: (result)  {
       if (result == "settings"){


           languagePickScreen();

       }else if (result == "logout"){

         logout();
       }
        },
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          value: "settings",
          child: Text('Settings'),
        ),
        const PopupMenuItem(
          value: "logout",
          child: Text('Log out'),
        ),

      ],
    );
    // return ElevatedButton(
    //   style: ButtonStyle(
    //     backgroundColor: MaterialStateProperty.all(CustomColors.colorNavy),
    //   ),
    //   onPressed: () async {
    //     setState(() {
    //       _isSigningOut = true;
    //     });
    //     await Authentication.signOut(context: context);
    //     setState(() {
    //       _isSigningOut = false;
    //     });
    //     Navigator.of(context).pushReplacement(_routeToSignInScreen());
    //   },
    //   child: Padding(
    //     padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
    //     child: Text(
    //       '${user.displayName}',
    //       style: TextStyle(
    //         fontSize: 16,
    //         fontWeight: FontWeight.bold,
    //         color: CustomColors.colorYellow,
    //         letterSpacing: 0.5,
    //       ),
    //     ),
    //   ),
    // );
  }


  Future languageControl() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    translanguage=pref.getString("translanguage");

    if(translanguage==null){
      print("if : $translanguage");
      languagePickScreen();

    }else{
      print("else : $translanguage");
    }

  }

   readingCheck() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // snap =  await fireins.collection("stories").get();
    // for (var i in snap.docs){
    //
    //   var title= i['title'].toString();
    //   bool readStatus = pref.getBool(title+"reading");
    //   statusMap[title]=readStatus;
    //   print(statusMap["title"]);
    // }

  }

  languagePickScreen(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),

              ],
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: ListView(
                    children: [
                      Text("Choose languguge"),

                     languageTile("Türkçe", "tr"),
                      languageTile("Czech", "cs"),
                      languageTile("Irish", "ga"),
                      languageTile("Chinese Simplified", "zh-CN"),
                      languageTile("Italian", "it"),
                      languageTile("Arabic", "ar"),
                      languageTile("Japanese", "ja"),
                      languageTile("Russian", "ru"),
                      languageTile("French", "fr"),
                      languageTile("Spanish", "es"),
                      languageTile("Greek", "el"),

                    ],
                  )
              ),
            );
          });}
    );
  }
  logout() async {


    setState(() {
            _isSigningOut = true;
          });
          await Authentication.signOut(context: context);
          setState(() {
            _isSigningOut = false;
          });
          Navigator.of(context).pushReplacement(_routeToSignInScreen());
  }
  languageTile (String lan,String code){
    return ListTile(
      title:  Text(lan),
      leading: Radio(
        value: code,
        groupValue: translanguage,
        onChanged: ( value) async {
          setState(() {
            translanguage = value;
          });
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("translanguage", translanguage);
          Navigator.pop(context);
        },
      ),
    );

}
}
