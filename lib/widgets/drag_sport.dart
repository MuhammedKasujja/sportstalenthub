import 'package:flutter/material.dart';
import 'package:sth/models/sport.dart';

class DragSportBox extends StatefulWidget {
  final Sport sport;
  final Offset offset;

  const DragSportBox({
    super.key,
    required this.sport,
    required this.offset,
  });
  @override
  State<DragSportBox> createState() => _DragSportBoxState();
}

class _DragSportBoxState extends State<DragSportBox> {
  Offset position = const Offset(0.0, 0.0);

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
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            position = offset;
          });
        },
        feedback: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Center(
            child: Chip(
              label: Text(
                widget.sport.name,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18.0,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
        child: SizedBox(
          width: 100.0,
          height: 100.0,
          child: Center(
            child: Chip(
              label: Text(
                widget.sport.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
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
