// number_picker.dart

import 'package:flutter/material.dart';

Future<int?> showNumberPicker(BuildContext context) async {
  return await showModalBottomSheet<int>(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          GridView.count(
            crossAxisCount: 3,
            children: List<Widget>.generate(9, (index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, index + 1);
                },
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              );
            }),
          ),
          Positioned(
            right: 27,
            bottom: 50,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, 0);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 28,
                  ),
                  Text(
                    'Delete',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}