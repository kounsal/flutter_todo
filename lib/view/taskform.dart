import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todotry/bloc/bloc.dart';
import 'package:todotry/bloc/event.dart';
import 'package:todotry/helper/datetimepick.dart';
import 'package:todotry/model/taskmodel.dart';

// ignore: must_be_immutable
class TaskCreationScreen extends StatefulWidget {
  TaskCreationScreen({super.key});

  @override
  State<TaskCreationScreen> createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  DateTime? _dueDate;
  TimeOfDay? dueTime;
  int _priority = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButton<int>(
              value: _priority,
              items: [
                DropdownMenuItem(value: 1, child: Text('High')),
                DropdownMenuItem(value: 2, child: Text('Medium')),
                DropdownMenuItem(value: 3, child: Text('Low')),
              ],
              onChanged: (value) {
                _priority = value!;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await selectDate(context);
                    if (selectedDate != null) {
                      setState(() {
                        _dueDate = selectedDate;
                      });
                    }
                  },
                  child: Text(_dueDate == null
                      ? 'Select Due Date'
                      : 'Due Date: ${_dueDate!.toLocal()}'.split(' ')[0]),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await selectTime(context);
                    if (selectedTime != null) {
                      setState(() {
                        dueTime = selectedTime;
                      });
                    }
                  },
                  child: Text(dueTime == null
                      ? 'Select Due Time'
                      : 'Due Time: ${dueTime!.format(context)}'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                final task = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  priority: _priority,
                  dueDate: DateTime(
                    _dueDate!.year,
                    _dueDate!.month,
                    _dueDate!.day,
                    dueTime!.hour,
                    dueTime!.minute,
                  ),
                );
                BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(task));
                Navigator.pop(context);
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
