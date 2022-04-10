import 'package:eng_story/res/custom_colors.dart';
import 'package:eng_story/utils/authentication.dart';
import 'package:eng_story/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';


class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInScreenState();
  }
}


class SignInScreenState extends State {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.colorNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0xFF54B5F6),
                            offset: new Offset(1.0, 1.0),
                            blurRadius: 5.0,
                          )
                        ],
                        borderRadius: BorderRadius.all(
                            Radius.circular(15.0) //         <--- border radius here
                        ),
                      image: DecorationImage(
                        image: AssetImage(
                'assets/logo_campany.png',

                ),fit: BoxFit.cover

                      )
                    ),
                  ),
                    SizedBox(height: 20),
                    Text(
                      'English Stories',
                      style: TextStyle(
                        color: CustomColors.colorYellow,
                        fontSize: 40,
                      ),
                    ),

                  ],
                ),
              ),

              //If fiebase setup correctly, sign in button shows
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error. Mail bsckbilgi@gmail.com');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.colorOrange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}
