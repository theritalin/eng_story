import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/screens/ShortStoryHome.dart';
import 'package:flutter/material.dart';

class HomePageStoryClick extends StatelessWidget {

  const HomePageStoryClick({
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
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  //headline
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Short Story ",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: size.width *0.08, color: CustomColors.colorYellow,fontWeight: FontWeight.bold,
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
                            padding: EdgeInsets.only(top: this.size.height * .02,left: 5),
                            child: Text(
                              "You can read short stories from various writers.",
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
                                    builder: (context) => ShortStoryHome(

                                    ),
                                  ),
                                );
                              },
                              child: Text("Read", style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors.colorNavy),),
                            ),
                          )
                        ],
                      ),

                    ],
                  )
                ],
              )
          ),
                 //logo
          Expanded(
              flex: 1,
              child: Container(
                width: size.width * .4,
                height: 150,

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.scaleDown,
                  )
                ),

              )),
        ],
      ),
    );
  }
}