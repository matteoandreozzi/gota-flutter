import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gota/adventure.dart';
import 'package:gota/parser.dart';
import 'package:gota/syntax.dart';

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
  final _typeAheadController = TextEditingController();
  final _focusNode = FocusNode();

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
          // refresh the widget
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
                        _adventure.title,
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
                        _adventure.story,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          focusNode: _focusNode,
                          decoration: InputDecoration(labelText: 'Command'),
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                          controller: _typeAheadController,
                          onSubmitted: (text) => setState(() {
                            var result = _commandParser.parse(text);
                            if (result.isSuccess) {
                              _adventure.command(result.value);
                            }
                            _typeAheadController.text = '';
                          }),
                        ),
                        suggestionsCallback: (pattern) {
                          var hint = pattern.toLowerCase().split(' ').last;
                          if (hint != '') {
                            return _adventure.commandSuggestions.where(
                                (element) =>
                                    element.toLowerCase().startsWith(hint));
                          }
                          // todo maybe define a noSuggestions widget
                          return [''];
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (suggestion) {
                          // TODO FOCUS AGAIN HERE - NEEDS FIXING THE OVERLAY NOT SHOWING
                          //_focusNode.requestFocus();

                          var spaceIndex =
                              this._typeAheadController.text.lastIndexOf(' ');

                          this._typeAheadController.text = (spaceIndex > -1
                                  ? this
                                      ._typeAheadController
                                      .text
                                      .substring(0, spaceIndex)
                                  : ' ') +
                              ' ' +
                              suggestion;
                        },
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
