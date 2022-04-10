import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/screens/PdfHomePage.dart';
import 'package:flutter/material.dart';

class HomePagePdfClick extends StatelessWidget {

  const HomePagePdfClick({
    Key key,
    this.size
  }) : super(key: key);

  final Size size;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: <Widget>[
          //logo
          Expanded(
              flex: 1,
              child: Container(
                width: size.width * .4,
                height: 150,

                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/pdf.png"),
                      fit: BoxFit.scaleDown,
                    )
                ),

              )),

          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  //headline
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Pdf ",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: size.width *0.1, color: CustomColors.colorYellow,fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // info
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: this.size.width * .5,
                            padding: EdgeInsets.only(top: this.size.height * .02),
                            child: Text(
                              "You can import pdf files to read them.",
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: size.width* 0.05,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: this.size.height * .015),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PdfHome(

                                    ),
                                  ),
                                );
                              },
                              child: Text("Import", style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors.colorNavy),),
                            ),
                          )
                        ],
                      ),

                    ],
                  )
                ],
              )
          ),

        ],
      ),
    );
  }
}