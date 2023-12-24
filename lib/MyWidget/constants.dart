
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context,text,color)
{
  final snackBar = SnackBar(backgroundColor: color,content: Text(text), duration: Duration(seconds: 1),);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  void showLoader(BuildContext context) {
    showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.purple),
                  ),
                ),
              )
            ],
          ));
        });
  }

  void hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
