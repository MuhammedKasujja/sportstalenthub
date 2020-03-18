import 'package:flutter/material.dart';
import 'package:sth/api/api_service.dart';

class FilesPage extends StatefulWidget {
  final String category;
  final playerId;

  const FilesPage({Key key, @required this.category, this.playerId})
      : super(key: key);
  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final api = ApiService();
  var photos;
  @override
  void initState() {
    super.initState();
    photos = api.getPlayersAttachments(
        playerId: widget.playerId.toString(), category: widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attached ${widget.category}'),
      ),
      body: FutureBuilder(
        future: photos,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  child: Image.network(snapshot.data[index].filename),
                ),
              );
            } else {
              return Center(child: Text("No data Found"));
            }
          } else {
            return Text("No data Found");
          }
        },
      ),
    );
  }
}
