import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



//The main App
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Creating and returning a Material App
    return MaterialApp(
      title: 'Quotes Sharing',
      home: MyHomePage(),
    );
  }
}




//Home Page Class
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //SafeArea is important to avoid the issues of UI overlapping in devices have screen till the edges.
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(title: Text('Quotes of the day')),
      body: _buildBody(context),
    ),
    );
  }




  //Surrounded with StreamBuilder to listen to database changes in realtime.
  //If Snapshot has data - shows the data
  // Else shows progress indicator

  //The Body contains a list UI
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('quotes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }



  //It builds the List View and returns
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }


  //List Items are built in this method,
  //Two const created for creating and serving the title view and subtitle view
  //Title view holds the 'quote' value - With no interaction
  //Subtitle holds the - like, dislike, share, comment views with icons - The interactions of each item will update the database.

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = QuoteModel.fromSnapshot(data);

    final _listTitle = Padding(
      padding: const EdgeInsets.all(8.0), child: Text(record.quote),);


    final _listSubTitle = Padding(padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
        Column(children: <Widget>[
          Text("Likes:" + record.likes.toString()),
          IconButton(icon: Icon(Icons.thumb_up),
            color: Colors.green,
            tooltip: 'Like',
            onPressed: () {
              print('Pressed Like');
              Firestore.instance.runTransaction((transaction) async {
                final freshSnapshot = await transaction.get(record.reference);
                final fresh = QuoteModel.fromSnapshot(freshSnapshot);

                await transaction.update(
                    record.reference, {'likes': fresh.likes + 1});
              },);
            },),
        ],),
        SizedBox(width: 10,),
        Column(children: <Widget>[
          Text("Dislikes:" + record.dislikes.toString()),
          IconButton(icon: Icon(Icons.thumb_down),
            color: Colors.deepOrangeAccent,
            tooltip: 'Dislike',
            onPressed: () {
              print('Pressed DisLike');
              Firestore.instance.runTransaction((transaction) async {
                final freshSnapshot = await transaction.get(record.reference);
                final fresh = QuoteModel.fromSnapshot(freshSnapshot);

                await transaction.update(
                    record.reference, {'dislikes': fresh.dislikes + 1});
              },);
            }
          ),
        ],),
        SizedBox(width: 10,),
        Column(children: <Widget>[
          Text("Shares:" + record.shareCount.toString()),
          IconButton(icon: Icon(Icons.share),
            color: Colors.lightBlue,
            tooltip: 'Share',
            onPressed: () {
              print('Pressed Share');
              //Getting the snapshot and using transaction to update the db helps avoiding the issues from race condition.
              //So, At a time if any other device tries to update the db, both updates will be recorded properly in database.
              Firestore.instance.runTransaction((transaction) async {
                final freshSnapshot = await transaction.get(record.reference);
                final fresh = QuoteModel.fromSnapshot(freshSnapshot);
                await transaction.update(
                    record.reference, {'share_count': fresh.shareCount + 1});
              });
            },),
        ],),
        SizedBox(width: 10,),
        Column(children: <Widget>[
          Text("Comments:" + record.comments.length.toString()),
          IconButton(icon: Icon(Icons.comment),
            color: Colors.deepPurple,
            tooltip: 'Comments',
            onPressed: () {
              print('Pressed Comment');

              //Updating array values in Firestore is little different from string and int updates.
              //Here below the code for that.
              Firestore.instance.runTransaction((transaction) async {
                await transaction.update(record.reference, {
                  'comments': FieldValue.arrayUnion(['Commented' +
                      new DateTime.now().millisecondsSinceEpoch.toString()
                  ])
                });
              });
            },
          ),
        ],
        ),
      ],
      ),
    );


    return Padding(
      key: ValueKey(record.quote),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        child: ListTile(
          title: _listTitle,
          subtitle: _listSubTitle,
        ),
      ),
    );
  }
}



//Data Model Class
class QuoteModel {
  final String quote;
  final int likes;
  final int dislikes;
  final int shareCount;
  final List comments;
  final DocumentReference reference;

  QuoteModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['quote'] != null),
        assert(map['likes'] != null),
       assert(map['dislikes'] != null),
       assert(map['share_count'] != null),
       assert(map['comments'] != null),

        quote = map['quote'],
        likes = map['likes'],
        dislikes = map['dislikes'],
        shareCount = map['share_count'],
        //Notice the difference for array types
        comments = map['comments'] as List;

  QuoteModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$quote:$likes:$dislikes:$shareCount>";
}