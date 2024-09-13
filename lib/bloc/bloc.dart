import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive/hive.dart';
import 'package:todotry/bloc/event.dart';
import 'package:todotry/bloc/state.dart';
import 'package:todotry/helper/notification_helper.dart';
import 'package:todotry/model/taskmodel.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<Task> tasksBox;

  TaskBloc(this.tasksBox) : super(TaskInitialState()) {
    on<AddTaskEvent>((event, emit) {
      tasksBox.add(event.task); // Directly add to the box
      scheduleNotification(event.task);
      emit(TaskListUpdatedState(tasksBox.values.toList()));
    });

    on<DeleteTaskEvent>((event, emit) {
      tasksBox.deleteAt(event.index); // Use deleteAt to remove task by index
      emit(TaskListUpdatedState(tasksBox.values.toList()));
    });

    on<UpdateTaskEvent>((event, emit) {
      tasksBox.putAt(
          event.index, event.updatedTask); // Use putAt to update task
      emit(TaskListUpdatedState(tasksBox.values.toList()));
    });

    on<LoadTasksEvent>((event, emit) {
      emit(TaskListUpdatedState(
          tasksBox.values.toList())); // Return all tasks in the box
    });
  }
}
