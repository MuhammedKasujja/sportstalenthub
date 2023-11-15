import 'package:flutter/material.dart';

class PaginationPage extends StatefulWidget{

  @override
  _PaginationPageState createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> {
 
  List<int> items = List.generate(10, (i) => i);
  final ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
           getMoreItems();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagination Example"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          if(index == items.length){
            return _buildProgressIndicator();
          }else{
            return ListTile(
               title: Text("data $index"),
            );
          }
          
        },
        controller: _scrollController,
      )
    );
  }

  Future getMoreItems() async{
    if(!isPerformingRequest){
      setState(() {
       isPerformingRequest = true; 
      });
      List<int> newEntries;
      if(newEntries.isEmpty){
        double edge = 50.0;
        double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
        if(offsetFromBottom < edge){
          _scrollController.animateTo(
             _scrollController.offset - (edge - offsetFromBottom),
             duration: new Duration(microseconds: 500),
             curve: Curves.easeOut
          );
        } 
      }
      setState(() {
         items.addAll(newEntries);
         isPerformingRequest = false;
      });
    }
    return null;
  }

  Widget _buildProgressIndicator(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
          child: Opacity(
            opacity: isPerformingRequest ? 1.0 : 0.0,
            child: new CircularProgressIndicator(),
          ),
      ),
    );
  }

  Future<List<int>> fakeRequest(int from, int to) async{
   return Future.delayed(Duration(seconds: 5), () {
        return List.generate(to - from, (i) => i + from);
   });
  }
}