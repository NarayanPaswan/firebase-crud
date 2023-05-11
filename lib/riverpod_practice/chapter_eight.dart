
import 'package:firbasecrud/riverpod_practice/counter_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateNotifierProvider<CounterDemo, int>((ref) => CounterDemo());

class MyChapterEight extends ConsumerWidget {
  const MyChapterEight({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter-7"),
      ),
      body: Column(
        children: [
          Center(child: Text(counter.toString())),
          IconButton(
            onPressed: (){
              // ref.invalidate(counterProvider);
              ref.refresh(counterProvider);
            }, 
            icon: const Icon(Icons.refresh)
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          ref.read(counterProvider.notifier).increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}