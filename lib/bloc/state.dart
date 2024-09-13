import 'package:todotry/model/taskmodel.dart';

abstract class TaskState {}

class TaskInitialState extends TaskState {}

class TaskListUpdatedState extends TaskState {
  final List<Task> tasks;
  TaskListUpdatedState(this.tasks);
}
