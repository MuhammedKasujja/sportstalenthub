import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class DragDropSettiogsPage extends StatefulWidget {
  const DragDropSettiogsPage({super.key});

  @override
  State<DragDropSettiogsPage> createState() => _DragDropSettiogsPageState();
}

class _DragDropSettiogsPageState extends State<DragDropSettiogsPage> {
  List<DragAndDropList> _contents = <DragAndDropList>[];

  @override
  void initState() {
    _contents = [
      DragAndDropList(header: const Text('My Sports'), children: [
        DragAndDropItem(child: const Text('kasujja')),
        DragAndDropItem(child: const Text('kato')),
        DragAndDropItem(child: const Text('kimera')),
        DragAndDropItem(child: const Text('ismail'))
      ]),
      DragAndDropList(header: const Text('Other Sports'), children: [
        DragAndDropItem(child: const Text('meddie')),
        DragAndDropItem(child: const Text('kimbugwe')),
        DragAndDropItem(child: const Text('lubega')),
        DragAndDropItem(child: const Text('charles'))
      ]),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Into List'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 10,
            child: DragAndDropLists(
              children: _contents,
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              onItemAdd: _onItemAdd,
              onListAdd: _onListAdd,
              listGhost: const SizedBox(
                height: 50,
                width: 100,
                child: Center(
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }

  _onItemAdd(DragAndDropItem newItem, int listIndex, int itemIndex) {
    print('adding new item');
    setState(() {
      if (itemIndex == -1) {
        _contents[listIndex].children.add(newItem);
      } else {
        _contents[listIndex].children.insert(itemIndex, newItem);
      }
    });
  }

  _onListAdd(DragAndDropListInterface newList, int listIndex) {
    print('adding new list');
    setState(() {
      if (listIndex == -1) {
        _contents.add(newList as DragAndDropList);
      } else {
        _contents.insert(listIndex, newList as DragAndDropList);
      }
    });
  }
}
