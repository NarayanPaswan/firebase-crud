import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = Provider<String>((ref){
  return "Hello Ram";
});

class MyChapterFive extends StatelessWidget {
  const MyChapterFive({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter-5"),
      ),
      body: Column(
        children: [
          Center(child: Consumer(
            builder: (context, ref, child){
              final name = ref.watch(nameProvider);
              return Text(name);
            },
            )
            ),
        ],
      ),
    );
  }
}