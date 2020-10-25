import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  String _title;
  String _date;
  String _feeling;
  String _reason;
  String _whatHappened;
  String _note;
  DocumentReference reference;

  Story(
      this._title, this._date, this._feeling, this._reason, this._whatHappened,
      [this._note]);
  Story.withID(
      this._title, this._date, this._feeling, this._reason, this._whatHappened,
      [this._note]);

  String get title => this._title;
  String get date => this._date;
  String get feeling => this._feeling;
  String get reason => this._reason;
  String get whatHappened => this._whatHappened;
  String get note => this._note;

  set title(String title) {
    this._title = title;
  }

  set date(String date) {
    this._date = date;
  }

  set feeling(String feeling) {
    this._feeling = feeling;
  }

  set reason(String reason) {
    this._reason = reason;
  }

  set whatHappened(String text) {
    this._whatHappened = text;
  }

  set note(String note) {
    this._note = note;
  }

  Story.fromMap(Map<String, dynamic> map, {this.reference})
      : _title = map['title'],
        _date = map['date'],
        _feeling = map['feeling'],
        _reason = map['reason'],
        _whatHappened = map['whatHappened'],
        _note = map['note'];

  Story.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
