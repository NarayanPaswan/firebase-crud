import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameProvider = Provider<String>((ref){
  return "Hello Ram";
});

class MyNamePage extends ConsumerWidget {
  const MyNamePage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(nameProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter-3"),
      ),
      body: Column(
        children: [
          Center(child: Text(name)),
        ],
      ),
    );
  }
}