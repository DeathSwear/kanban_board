import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:flutter/material.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  List<List<String>> tasks = [
    ["Task 1", "Task 2"],
    ["Task 3"],
    [],
  ];

  List<String> headers = ["To Do", "In Progress", "Done"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kanban Board")),
      body: BoardView(
        lists: List.generate(tasks.length, (listIndex) {
          return BoardList(
            header: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue,
                child: Text(
                  headers[listIndex],
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
            items: List.generate(tasks[listIndex].length, (itemIndex) {
              return BoardItem(
                onStartDragItem: (listIndex, itemIndex, state) {},
                onDropItem: (
                  listIndex,
                  itemIndex,
                  oldListIndex,
                  oldItemIndex,
                  state,
                ) {
                  setState(() {
                    final moved = tasks[oldListIndex!].removeAt(oldItemIndex!);
                    tasks[listIndex!].insert(itemIndex!, moved);
                  });
                },
                onTapItem: (listIndex, itemIndex, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Clicked ${tasks[listIndex!][itemIndex!]}"),
                    ),
                  );
                },
                item: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(tasks[listIndex][itemIndex]),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
