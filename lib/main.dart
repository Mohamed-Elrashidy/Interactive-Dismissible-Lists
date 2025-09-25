import 'package:app/task_entity.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TaskEntity> items = [
    TaskEntity(title: "Task 1", order: 1, completed: false),
    TaskEntity(title: "Task 2", order: 2, completed: false),
    TaskEntity(title: "Task 3", order: 3, completed: false),
    TaskEntity(title: "Task 4", order: 4, completed: false),
    TaskEntity(title: "Task 5", order: 5, completed: false),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                  ),

                  Text(
                    "Task Manager",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(width: 20),
                ],
              ),
              Expanded(
                child: ReorderableListView(
                  children: [
                    for (int index = 0; index < items.length; index++)
                      Dismissible(
                        confirmDismiss: (_) async {
                          return await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content: Text(
                                    'Are you sure you want to delete this task?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                        setState(() {});
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                ),
                          );
                        },
                        onDismissed: (_) {
                          // show confirmation Dialog
                          TaskEntity removedItem = items[index];
                          setState(() {
                            items.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Task deleted'),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        items.insert(index, removedItem);
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).hideCurrentSnackBar();
                                    },
                                    child: Text(
                                      'UNDO',
                                      style: TextStyle(color: Colors.yellow),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        key: ValueKey<TaskEntity>(items[index]),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            tileColor: Color(0xBEBC9FCE),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            title: Text(
                              items[index].title,
                              style: TextStyle(
                                decoration:
                                    items[index].completed
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                              ),
                            ),
                            leading: const Icon(Icons.drag_handle),
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  items[index].completed =
                                      !items[index].completed;
                                });
                              },
                              child: Icon(
                                items[index].completed
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                  onReorder: (first, second) {
                    setState(() {
                      print('first: $first, second: $second');
                      if (first < second) {
                        second -= 1;
                      }
                      final item = items.removeAt(first);
                      items.insert(second, item);
                      for (int i = 0; i < items.length; i++) {
                        items[i].order = i + 1;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
