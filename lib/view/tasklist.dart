import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todotry/bloc/bloc.dart';
import 'package:todotry/bloc/event.dart';
import 'package:todotry/bloc/state.dart';
import 'package:todotry/view/taskform.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ToDo List')),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskListUpdatedState) {
            final tasks = state.tasks;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('Due: ${task.dueDate.toLocal()}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<TaskBloc>(context)
                          .add(DeleteTaskEvent(index));
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No tasks available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TaskCreationScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
