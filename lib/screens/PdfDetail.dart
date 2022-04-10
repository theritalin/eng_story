import 'package:eng_story/res/PdfObject.dart';
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

class PdfDetail extends StatefulWidget {
  final PdfObject pdfdata;

  PdfDetail({@required this.pdfdata});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PdfDetailState(pdfdata: this.pdfdata);
  }
}

class PdfDetailState extends State {
  //Google Ads
  BannerAd _ad;
  bool isLoading = false;

  var ref;
  final PdfObject pdfdata;
  int sira = 0;
  PdfDetailState({@required this.pdfdata});

  @override
  void initState() {
    pdfdata.splited = pdfdata.body.split(" ");
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


//story part
    final bottomContent = Container(
      height: MediaQuery.of(context).size.height * 0.70,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Wrap(
                children: genarateWords(),
              ),

            ],
          ),
        ),
      ),
    );




    // TODO: implement build
    return Scaffold(
      backgroundColor: CustomColors.colorNavy,
      appBar: AppBar(
        backgroundColor: CustomColors.colorNavy,
        title: Text(pdfdata.name.toString()),
      ),
      body: Column(
        children: [
          checkforad(),
          bottomContent,

        ],
      ),


    );
  }


  genarateWords() {
    List<Widget> list = [];
    int count = 0;
    pdfdata.splited.forEach((pdfs) {
      Widget element = Container(

        margin: EdgeInsets.fromLTRB(0, 0, 5, 7),
        child: GestureDetector(
          child: Text(
            pdfs.toString(),
            style: TextStyle(color: Colors.white, fontSize: 20,),

          ),
          onTap: () async {
            var translation = await translator.translate(pdfs, to: translanguage);
            dialogBilgi(
                context, "${pdfs.toString()} : ${translation.text}");

          },
        ),
      );
      list.add(element);
      count++;
    });
    return list;
  }
}
