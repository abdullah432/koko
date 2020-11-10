import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String _title;
  String _date;
  String _feeling;
  String _reason;
  String _whatHappened;
  List<dynamic> _images;
  int _totallikes;
  int _totalcomments;
  DocumentReference reference;

  Post(this._title, this._date, this._feeling, this._reason, this._whatHappened,
      this._totallikes, this._totalcomments,
      [this._images]);
  Post.withID(this._title, this._date, this._feeling, this._reason,
      this._whatHappened, this._totallikes, this._totalcomments,
      [this._images]);

  String get title => this._title;
  String get date => this._date;
  String get feeling => this._feeling;
  String get reason => this._reason;
  String get whatHappened => this._whatHappened;
  List<dynamic> get images => this._images;
  int get totallikes => this._totallikes;
  int get totalcomments => this._totalcomments;
  String get postid => this.reference.id;

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

  set images(images) {
    this._images = images;
  }

  set totallikes(value) {
    this._totallikes = value;
  }

  Post.fromMap(Map<String, dynamic> map, {this.reference})
      : _title = map['title'],
        _date = map['date'],
        _feeling = map['feeling'],
        _reason = map['reason'],
        _whatHappened = map['whatHappened'],
        _images = map['images'] != null ? map['images'] : [],
        _totalcomments =
            map['totalcomments'] != null ? map['totalcomments'] : 0,
        _totallikes = map['totallikes'] != null ? map['totallikes'] : 0;

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
