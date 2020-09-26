import 'package:date_format/date_format.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kuku/model/Story.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/utils/customfirestore.dart';

class EditStoryPage extends StatefulWidget {
  final Story story;
  EditStoryPage({@required this.story, Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return EditStoryPageState(story);
  }
}

class EditStoryPageState extends State<EditStoryPage> {
  Story story;
  EditStoryPageState(this.story, {Key key});

  String _selectedFeeling;
  String _selectedReason;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _whatHappenedController = TextEditingController();
  TextEditingController _dailyNotesController = TextEditingController();
  //focusnode
  FocusNode _titleFocusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();

  //customfirestore
  CustomFirestore _customFirestore = CustomFirestore();
  //Snackbar
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _selectedDate = DateTime.parse(story.date);
    _titleController.text = story.title;
    _selectedFeeling = story.feeling;
    _selectedReason = story.reason;
    _whatHappenedController.text = story.whatHappened;
    _dailyNotesController.text = story.note;
    super.initState();

    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _titleController.dispose();
    _whatHappenedController.dispose();
    _dailyNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: GestureDetector(
          onTap: () {
            _titleFocusNode.unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 50, right: 15.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 19.0),
                  ),
                  //Date
                  FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2018, 1, 1),
                          maxTime: DateTime(2199, 12, 31), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          this._selectedDate = date;
                        });
                      }, currentTime: _selectedDate, locale: LocaleType.en);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            formatDate(_selectedDate, [MM, ' ', dd]),
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Raleway',
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 35,
                            color: Colors.black,
                          )
                        ]),
                  ),
                  //title
                  Text(
                    'TITLE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 19.0),
                  ),
                  //space
                  SizedBox(height: 10.0),
                  Container(
                    color: Colors.white,
                    child: TextField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        )),
                  ),
                  //space
                  SizedBox(height: 10.0),
                  //feeling
                  Text(
                    'FEELING',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 19.0),
                  ),
                  //space
                  SizedBox(height: 10.0),
                  DropdownButtonHideUnderline(
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: DropdownButton<String>(
                            onChanged: (newValue) {
                              setState(() {
                                _selectedFeeling = newValue;
                                //unfocus title textfield
                                _titleFocusNode.nextFocus();
                              });
                            },
                            value: _selectedFeeling,
                            items: Constant.listOfFeelings.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )),
                  ),
                  //space
                  SizedBox(height: 20.0),
                  //heading 2
                  Text(
                    'REASON',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 19.0),
                  ),
                  //space
                  SizedBox(height: 10.0),
                  DropdownButtonHideUnderline(
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: DropdownButton<String>(
                            onChanged: (newValue) {
                              setState(() {
                                _selectedReason = newValue;
                                //unfocus title textfield
                                _titleFocusNode.unfocus();
                              });
                            },
                            value: _selectedReason,
                            items: Constant.listOfReasons.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )),
                  ),
                  //space
                  SizedBox(height: 20.0),
                  //heading 3
                  Text(
                    'WHAT HAPPENED TODAY',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 19.0),
                  ),
                  //space
                  SizedBox(height: 10.0),
                  Container(
                    color: Colors.white,
                    child: TextField(
                        controller: _whatHappenedController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        )),
                  ),
                  //space
                  SizedBox(height: 20.0),
                  //heading 4
                  Text(
                    'YOUR DAILY NOTES',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        fontSize: 19.0),
                  ),
                  //space
                  SizedBox(height: 10.0),
                  Container(
                    color: Colors.white,
                    child: TextField(
                        controller: _dailyNotesController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8.0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        )),
                  ),
                  //space
                  SizedBox(height: 15.0),
                  Center(
                    child: RaisedButton(
                      onPressed: () async {
                        Story story = Story(
                            _titleController.text,
                            _selectedDate.toString(),
                            _selectedFeeling,
                            _selectedReason,
                            _whatHappenedController.text,
                            _dailyNotesController.text);
                        String result = await _customFirestore
                            .updateStoryToFirestore(story: story);

                        if (result != 'success')
                          showInSnackBar(result);
                        else {
                          _showInterstitialAd();
                          Navigator.pop(context, story);
                        }
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Text(
                          'UPDATE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                      ),
                    ),
                  ),
                  //space
                  SizedBox(height: 5.0),
                  Center(
                      child: Text(
                    'Ad may appear after click on update button.',
                    style: TextStyle(color: Colors.black, fontSize: 10)
                  )
                      // RichText(
                      //   text: TextSpan(
                      //       text: 'Ad may appear after click on update button.',
                      //       style: TextStyle(color: Colors.black, fontSize: 10),
                      //       children: <TextSpan>[
                      //         TextSpan(
                      //           text: ' Only once',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold, fontSize: 10),
                      //         )
                      //       ]),
                      // ),
                      )
                ],
              ),
            ),
          ),
        ));
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  //facebook audience network
  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "3663243730352300_3663613440315329",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.ERROR &&
            value["invalidated"] == true) {
          print('Ad is reload again');
          _loadInterstitialAd();
        }
      },
    );
  }

  _showInterstitialAd() {
    FacebookInterstitialAd.showInterstitialAd();
  }
}
