import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eng_story/res/Story.dart';
import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/res/data.dart';
import 'package:eng_story/widgets/app_bar_title.dart';
import 'package:eng_story/widgets/story_list.dart';
import 'package:eng_story/widgets/story_list_tile.dart';
import 'package:flutter/material.dart';

class ShortStoryHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShortStoryHomeState();
  }

}

class ShortStoryHomeState extends State {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: CustomColors.colorNavy,
      appBar: AppBar(
        elevation: 20,
        backgroundColor: CustomColors.colorNavy,
        title: AppBarTitle(),



      ),
      //drawer: DrawerPage(),

      //story names tile
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

//story ye yeni malan ekle onu shared ten al
            FutureBuilder(
              future: fireins.collection("stories").get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(child: CircularProgressIndicator());
                }
                final data = snapshot.data;

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data.size,
                    itemBuilder: (context, index)  {

                      Story story = new Story(
                        data.docs[index]["body"],
                        data.docs[index]["level"],
                        data.docs[index]["title"],
                        data.docs[index]["author"],


                      );


                      //return StoryListTile(story: story);
                      return StoryList(story: story);

                    });
              },
            ),

          ],
        ),
      ),
    );
  }
}