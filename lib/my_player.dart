import 'package:flutter/material.dart';

class myPlayer extends StatefulWidget {
  const myPlayer({ Key? key }) : super(key: key);

  @override
  State<myPlayer> createState() => _myPlayerState();
}

class _myPlayerState extends State<myPlayer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Image.asset(
        'lib/images/pac-man.png'
      ),
    );
  }
}
