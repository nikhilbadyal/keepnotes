import 'package:flutter/material.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/Utilites.dart';

class AboutMe extends StatefulWidget {
  const AboutMe();

  @override
  _AboutMeState createState() {
    return _AboutMeState();
  }
}

class _AboutMeState extends State<AboutMe> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //debugPrint('building 4 ');
    return body(context);
  }

  Widget body(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    Utilities.launchUrl('https://github.com/ProblematicDude');
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/${Utilities.aboutMePic}'),
                    radius: 90.0,
                  ),
                ),
              ),
              const Divider(
                height: 60.0,
                color: Colors.black,
              ),
              const Text(
                'Name',
                style: TextStyle(
                  // color: Colors.black,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Nikhil',
                style: TextStyle(
                  color: selectedPrimaryColor,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Email',
                style: TextStyle(
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Utilities.iconColor(),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'nikhildevelops@gmail.com',
                    style: TextStyle(
                      color: selectedPrimaryColor,
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
