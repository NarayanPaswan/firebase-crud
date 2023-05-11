import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final streamProvider = StreamProvider<int>(((ref) {
return Stream.periodic(const Duration(seconds: 2),((computationCount) {
  return computationCount;
}));
}));

class MyChapterTen extends ConsumerWidget {
  const MyChapterTen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamData = ref.watch(streamProvider);
   return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter-10"),
      ),
      body: Column(
        children: [
          // streamData.when(
            // data: Null, 
            // error: ((error, stackTrace) => Text(error.toString())), 
            // loading: loading
            // )     
        ],
      ),
     
    );
  }
}