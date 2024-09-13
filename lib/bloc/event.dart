import 'package:todotry/model/taskmodel.dart';



abstract class TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final int index;
  DeleteTaskEvent(this.index);
}

class UpdateTaskEvent extends TaskEvent {
  final int index;
  final Task updatedTask;
  UpdateTaskEvent(this.index, this.updatedTask);
}

class LoadTasksEvent extends TaskEvent {}
