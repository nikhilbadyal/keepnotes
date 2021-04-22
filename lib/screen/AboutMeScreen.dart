import 'package:flutter/material.dart';
import 'package:notes/util/AppConfiguration.dart';
import 'package:notes/util/Languages/Languages.dart';
import 'package:notes/util/Navigations.dart';
import 'package:notes/util/Utilites.dart';
import 'package:notes/widget/SocialRow.dart';

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
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/me.png'),
                    radius: 50.0,
                  ),
                ),
              ),
              const Divider(
                  height: 60.0, color: Colors.black, indent: 12, endIndent: 12),
              Text(
                Languages.of(context).name,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Product Sans',
                    color: Theme.of(context).textTheme.bodyText1!.color),
              ),
              const SizedBox(height: 30.0),
              Text(
                Languages.of(context).devName,
                style: TextStyle(
                  color: selectedPrimaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                Languages.of(context).email,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Product Sans',
                    color: Theme.of(context).textTheme.bodyText1!.color),
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
                  GestureDetector(
                    onTap: () => goToBugScreen(context),
                    child: Text(
                      'nikhildevelops@gmail.com',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedPrimaryColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                  height: 60.0, color: Colors.black, indent: 12, endIndent: 12),
              Container(
                margin: const EdgeInsets.only(left: 16, top: 8),
                child: Center(
                  child: Text(
                    Languages.of(context).social,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Product Sans',
                        color: Theme.of(context).textTheme.bodyText1!.color),
                  ),
                ),
              ),
              SocialLinksRow(),
              const SizedBox(height: 16),
              const Divider(indent: 12, endIndent: 12),
            ],
          ),
        ),
      ),
    );
  }
}
