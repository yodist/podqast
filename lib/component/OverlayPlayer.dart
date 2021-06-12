import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlayPlayer extends StatelessWidget {
  final VoidCallback onReply;

  final String message;

  const OverlayPlayer({
    Key? key,
    required this.onReply,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTile(
        leading: SizedBox.fromSize(size: const Size(20, 20)),
        title: Text('Boyan'),
        subtitle: Text(message),
        trailing: IconButton(
            icon: Icon(CupertinoIcons.play),
            onPressed: () {
              onReply();
            }),
      ),
      // ),
    );
  }
}
