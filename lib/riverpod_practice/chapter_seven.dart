import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

class MyChapterSeven extends ConsumerWidget {
  const MyChapterSeven({super.key});

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    final count = ref.watch(counterProvider);
    ref.listen(counterProvider, ((previous, next){
      if(next == 5){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:  Text("The value is $next"),
          ));
      }
    }));
   return Scaffold(
      appBar: AppBar(
        title: const Text("Chapter-7"),
      ),
      body: Column(
        children: [
          Center(child: Text(count.toString())),
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
          // ref.read(counterProvider.notifier).state++;
          ref.read(counterProvider.notifier).update((state) => state + 1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}