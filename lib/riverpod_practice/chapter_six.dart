import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = Provider<String>((ref){
  return "Hello Ram";
});


class MyChpaterFive extends ConsumerStatefulWidget {
  const MyChpaterFive({super.key});

  @override
  _MyChpaterFiveState createState() => _MyChpaterFiveState();
}

class _MyChpaterFiveState extends ConsumerState<MyChpaterFive> {
  @override
  Widget build(BuildContext context) {
    final name = ref.watch(nameProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter-6"),
      ),
      body: Column(
        children: [
          Center(child: Text(name)),
        ],
      ),
    );
  }
}