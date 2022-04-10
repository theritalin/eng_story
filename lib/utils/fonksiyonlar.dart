import 'package:flutter/material.dart';


//meaning dialog dialog
dialogBilgi(BuildContext context, String t) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Container(
          child: Text(t),
        ),
      );
    },
  );
}


// snackbar
SnackBar meaningBar(String content) {
  return SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      content,
      style: TextStyle(color: Colors.black, letterSpacing: 0.5),
    ),
  );
}