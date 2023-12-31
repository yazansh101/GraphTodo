import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_todo_app/core/project_utils.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class EditTodoSheet extends StatefulWidget {
  final TodoModel todoModel;
  final Future<bool> Function(TodoModel todoModel) editTodoCallback;
  final Future<bool> Function(TodoModel todoModel) deleteTodoCallback;
  const EditTodoSheet({
    super.key,
    required this.todoModel,
    required this.editTodoCallback,
    required this.deleteTodoCallback,
  });

  @override
  State<EditTodoSheet> createState() => _EditTodoSheetState();
}

class _EditTodoSheetState extends State<EditTodoSheet> {
  void _showToast(BuildContext context, String message) =>
      fToast.showToast(child: ProjectUtils.toastWidget(context, message));

  late FToast fToast;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController todoController = TextEditingController();
  int _priorityValue = 1;
  bool _isLoading = false;

  @override
  void initState() {
    todoController.text = widget.todoModel.todo;
    _priorityValue = widget.todoModel.priority;
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

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
                  Text(
                    'Edit Todo',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: todoController,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      hintText: 'Edit todo',
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
                          color:Colors.red,
                          fontSize: 26.sp,
                        ),
                        onChanged: (int val) {
                          setState(() {
                            _priorityValue = val;
                          });
                        }),
                  ),
                  SizedBox(height: 16.h),
                  if (_isLoading) ProjectUtils.circularProgressBar(context),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _editTodoOnPressed(context);
                          },
                          label: const Text('Save'),
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      SizedBox(width: 32.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          onPressed: () async {
                            await _deleteTodoOnPressed(context);
                          },
                          label: const Text('Delete'),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editTodoOnPressed(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    widget.todoModel.priority = _priorityValue;
    widget.todoModel.todo = todoController.text;

    bool response = await widget.editTodoCallback(widget.todoModel);
    if (response && mounted) {
      Navigator.pop(context);
    } else {
      _showToast(context, 'Error while saving the edited todo.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTodoOnPressed(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    bool response = await widget.deleteTodoCallback(widget.todoModel);
    if (response && mounted) {
      Navigator.pop(context);
    } else {
      _showToast(context, 'Error while deleting todo.');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
