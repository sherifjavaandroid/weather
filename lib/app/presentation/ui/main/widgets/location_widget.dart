import 'package:flutter/material.dart';

Padding buildLocationWidget({
  required BuildContext context,
  required String location,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 24, left: 0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: Icon(Icons.location_pin),
        ),
        Flexible(
          child: Text(
            location,
            softWrap: true,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
