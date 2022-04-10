import 'package:eng_story/res/Story.dart';
import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/screens/storyDetail.dart';
import 'package:flutter/material.dart';

class StoryList extends StatelessWidget {
  // final String name;
  // final String tag;
  // final int chapterNumber;

  final Story story;


  StoryList({@required this.story});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: EdgeInsets.fromLTRB(8, 16, 8, 0),
      width: size.width - 48,
      decoration: BoxDecoration(
        color: Color.fromRGBO(64, 75, 96, .9),
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 33,
            color: Color(0xFFD3D3D3).withOpacity(.14),
          ),
        ],
      ),
      child: Row(
        children: [

          Column(
            children: <Widget>[

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${story.title}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: " by ${story.author}",
                      style: TextStyle(color: Colors.white,),
                    ),

                  ],
                ),
              ),

            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(

              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return StoryDetail(storydata: story);
                  },
                ),
              );
            },
          )
        ],
      ),


    );
  }


}