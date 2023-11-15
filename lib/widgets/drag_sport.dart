import 'package:flutter/material.dart';
import 'package:sth/models/sport.dart';

class DragSportBox extends StatefulWidget {
  final Sport sport;
  final Offset offset;

  const DragSportBox({Key? key, required this.sport, required this.offset});
  @override
  _DragSportBoxState createState() => _DragSportBoxState();
}

class _DragSportBoxState extends State<DragSportBox> {
  Offset position = Offset(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    position = widget.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Draggable(
        data: widget.sport,
        child: Container(
          width: 100.0,
          height: 100.0,
          child: Center(
            child: Chip(
              label: Text(
                widget.sport.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            position = offset;
          });
        },
        feedback: Container(
          width: 120.0,
          height: 120.0,
          child: Center(
            child: Chip(
              label: Text(
                widget.sport.name,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18.0,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
