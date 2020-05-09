import 'package:flutter/material.dart';
import 'package:gota/adventure.dart';
import 'package:gota/room.dart';

void main() => runApp(Destini());

class Destini extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StoryPage(),
    );
  }
}

class StoryPage extends StatefulWidget {
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  Adventure adventure = Adventure('assets/map.json');

  List<Widget> drawTitleAndText() {
    return [
      Expanded(
        flex: 4,
        child: Center(
          child: Text(
            adventure.getTitle(),
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 8,
        child: Center(
          child: Text(
            adventure.getStory(),
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> drawNavigationButtons() {
    List<Widget> buttons = [];

    for (var dir in Direction.values) {
      if (adventure.directionVisible(dir)) {
        buttons.add(
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  adventure.navigate(dir);
                });
              },
              color: Colors.teal,
              child: Text(
                dir.toShortString(),
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        );
      }
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage('images/background.png'),
//          ),
//        ),
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: drawTitleAndText() + drawNavigationButtons(),
          ),
        ),
      ),
    );
  }
}
