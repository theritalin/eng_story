import 'package:eng_story/res/Story.dart';
import 'package:eng_story/res/data.dart';
import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/utils/advert_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:translator/translator.dart';

import '../utils/fonksiyonlar.dart';

final translator = GoogleTranslator();

class StoryDetail extends StatefulWidget {
  final Story storydata;

  StoryDetail({@required this.storydata});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoryDetailState(storydata: this.storydata);
  }
}

class StoryDetailState extends State {
  //Google Ads
  BannerAd _ad;
  bool isLoading = false;

  var ref;
  final Story storydata;
  int sira = 0;
  StoryDetailState({@required this.storydata});

  @override
  void initState() {
    getir();
    storydata.splited = storydata.body[sira].split(" ");

    super.initState();
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(() {
          isLoading = true;
        });
      }, onAdFailedToLoad: (_, error) {
        _ad.dispose();

      }),
    );

    _ad.load();
  }

  @override
  void dispose() {
    kaydet();
    _ad?.dispose();
    super.dispose();
  }

  Widget checkforad() {

    if (isLoading == true) {
      return Container(
        child: AdWidget(
          ad: _ad,
        ),
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
        alignment: Alignment.center,
      );
    } else {
      return CircularProgressIndicator(value: 0,

      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //image section
    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width,
          child: Image.asset("assets/example.jpg",fit: BoxFit.fill,),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
        ),
      ],
    );

//story part
    final bottomContent = Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
     
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SwipeDetector(
                child: Wrap(

                  children: genarateStories(),
                ),
                onSwipeRight: backSheet,
                onSwipeLeft: forwardSheet,
              ),

            ],
          ),
        ),
      ),
    );


    final sheetChangeContainer=Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GestureDetector(

            child:Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child:  Text("Previous Sheet",style: TextStyle(color: Colors.white),),
              ),
            ),
            onTap: backSheet,
          ),
          Text("${sira + 1} / ${storydata.body.length}",
              style: TextStyle(
                color: Colors.white,
              )),
          GestureDetector(

            child:Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                child:  Text("Next Sheet",style: TextStyle(color: Colors.white),),
              ),
            ),
            onTap: forwardSheet,
          ),

        ],
      ),
    );

    // TODO: implement build
    return Scaffold(
      backgroundColor: CustomColors.colorNavy,
      appBar: AppBar(
        backgroundColor: CustomColors.colorNavy,
        title: Text(storydata.title),
      ),
      body: Column(
        children: [
          checkforad(),
          topContent,
          bottomContent,
          sheetChangeContainer,
        ],
      ),


    );
  }

  //sheet to back
  Function backSheet() {
    setState(() {
      if (sira > 0) {
        sira = sira - 1;

        storydata.splited = storydata.body[sira].split(" ");
      }
    });
  }

  //initsatete kaldığımız sayfayı getiriyor.
  Future getir() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int gelensira = pref.getInt(this.storydata.title);
    if (gelensira != null) {
      setState(() {
        sira = gelensira;
      });
    }
  }

  //dispose da kalan sayfayı shared ile kaydediyor.
  Future kaydet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt(this.storydata.title, sira);

  }

  //sheet to forward
  Function forwardSheet() {
    setState(() {
      if (sira < storydata.body.length - 1) {
        sira = sira + 1;
        print(sira);
        storydata.splited = storydata.body[sira].split(" ");
      }
    });
  }

  genarateStories() {
    List<Widget> list = [];
    int count = 0;
    storydata.splited.forEach((stories) {
      Widget element = Container(


        margin: EdgeInsets.fromLTRB(0, 0, 5, 7),
        child: GestureDetector(
          child: Text(
            stories.toString(),
            style: TextStyle(color: Colors.white, fontSize: 20,),

          ),
          onTap: () async {
            var translation = await translator.translate(stories, to: translanguage);
            dialogBilgi(
                context, " ${stories.toString()} : ${translation.text}");
            //ScaffoldMessenger.of(context).showSnackBar( meaningBar("${stories.toString()} : ${translation.text}"));
          },
        ),
      );
      list.add(element);
      count++;
    });
    return list;
  }
}
