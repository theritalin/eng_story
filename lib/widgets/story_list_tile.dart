
import 'package:eng_story/res/Story.dart';
import 'package:eng_story/screens/storyDetail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryListTile extends StatefulWidget{

  final Story story;


  StoryListTile({@required this.story});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StoryListTileState(story: story);
  }



}

class StoryListTileState extends State{
  final Story story;
  bool readingStatus=false;

  StoryListTileState({@required this.story});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(

              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return StoryDetail(storydata: story);
                    },
                  ),
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24))),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    if(readingStatus==false){


                  setState(() {
                    readingStatus=true;

                  });
                      await pref.setBool(this.story.title+"reading", true);
                    }else{
                      setState(() {
                        readingStatus=false;

                      });
                      await pref.setBool(this.story.title+"reading", false);
                    }
                        print(this.story.title+"reading");
                  } ,
                  child: readingStatus?Icon(Icons.assignment_turned_in, color: Colors.green):Icon(Icons.auto_stories, color: Colors.white),
                ),
              ),
              title: Text(
                "${story.title}",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),


              subtitle: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Icon(Icons.linear_scale, color: Colors.yellowAccent),
                      Text(" by ${story.author}", style: TextStyle(color: Colors.white))
                    ],
                  ),
                  Text("${story.level}", style: TextStyle(color: Colors.white),)
                ],
              ),
              trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0))),
    );
  }
}