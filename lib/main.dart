import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:gota/adventure.dart';
import 'package:gota/parser.dart';
import 'package:gota/room.dart';

void main() {
  runApp(Destini());
}

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
  Adventure _adventure;
  CommandParser _commandParser;
  GlobalKey<AutoCompleteTextFieldState<String>> _textFieldKey = GlobalKey();

  List<Expanded> drawNavigationButtons() {
    List<Expanded> buttons = [];

    for (var dir in Direction.values) {
      if (_adventure.directionVisible(dir)) {
        buttons.add(
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  _adventure.navigate(dir);
                });
              },
              color: Colors.teal,
              child: Text(
                EnumToString.parse(dir),
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
  void initState() {
    super.initState();
    _commandParser = CommandParser();
    _adventure = Adventure();
    _adventure.load('assets/map.json').then((value) => setState(() {
          var result = _commandParser.parse('use shiny lamp with mumbo jumbo');
          //result.
          if (result.isSuccess) {
            print('Result of the 1 parsing ${result.value}');
          }

          result = _commandParser.parse('use chicken on hook');
          //result.
          if (result.isSuccess) {
            print('Result of the 2 parsing ${result.value}');
          }

          result = _commandParser.parse('open chicken');
          //result.
          if (result.isSuccess) {
            print('Result of the 3 parsing ${result.value}');
            _adventure.command(result.value);
          }
        }));
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
            children: [
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        _adventure.getTitle(),
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
                        _adventure.getStory(),
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: SimpleAutoCompleteTextField(
                        key: _textFieldKey,
                        decoration: new InputDecoration(errorText: "Command"),
                        controller: TextEditingController(text: ""),
                        suggestions: (Command.values
                            .map((e) => EnumToString.parse(e))
                            .toList()), //+ Preposition.values.map((e) => EnumToString.parse(e))),// ,
                        textChanged: (text) => text,
                        clearOnSubmit: true,
                        textSubmitted: (text) => setState(() {
                          var result = _commandParser.parse(text);
                          if (result.isSuccess) {
                            _adventure.command(result.value);
                          }
                        }),
                      ),
                    ),
                  ),
                ] +
                drawNavigationButtons(),
          ),
        ),
      ),
    );
  }
}
