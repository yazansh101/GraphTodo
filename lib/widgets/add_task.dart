import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_todo_app/core/project_utils.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class AddTodoSheet extends StatefulWidget {
  final Future<bool> Function(TodoModel todoModel) addTodoCallback;
  const AddTodoSheet({super.key, required this.addTodoCallback});

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  void showSnackBarMessage(String message) {
    if (mounted) ProjectUtils.showSnackBarMessage(context, message);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController todoController = TextEditingController();
  int _priorityValue = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Container(color: Colors.orangeAccent, width: 5.w),
            SizedBox(
              width: 15.w,
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'Add new task',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: todoController,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'write your task to do',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    'from highest to lowest',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Center(
                    child: NumberPicker(
                        minValue: 1,
                        maxValue: 3,
                        axis: Axis.horizontal,
                        haptics: true,
                        value: _priorityValue,
                        selectedTextStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 26.sp,
                        ),
                        onChanged: (int val) {
                          setState(() {
                            _priorityValue = val;
                          });
                        }),
                  ),
                  // SizedBox(height: 32.h),
                  const Spacer(),
                  if (_isLoading) ProjectUtils.circularProgressBar(context),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: Colors.grey,
                      child: const Icon(Icons.done),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String todoText = todoController.text;
                          int todoPriority = _priorityValue;

                          TodoModel model = TodoModel(
                            id: -1,
                            createdAt: DateTime.now(),
                            todo: todoText,
                            userId: 'ASD',
                            isDone: false,
                            priority: todoPriority,
                          );

                          setState(() {
                            _isLoading = true;
                          });
                          bool result = await widget.addTodoCallback(model);
                          if (!result) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
