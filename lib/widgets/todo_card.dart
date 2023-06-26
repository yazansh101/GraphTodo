import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_app/core/project_constants.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todoModel;
  final Future<bool> Function(bool val) onCheckedCallback;
  final Function(TodoModel todoModel) onTappedCallback;
  const TodoCard(
      {super.key,
      required this.todoModel,
      required this.onCheckedCallback,
      required this.onTappedCallback});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.todoModel.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color cardBackgroundColor = ProjectConstants.cardBackgroundColor(context);
    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Card(

          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation:3,
          color: cardBackgroundColor,
          child: InkWell(
            onTap: () => widget.onTappedCallback(widget.todoModel),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  color: Colors.green,
                  height: 3,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCheckBox(),
                      _buildDateTime(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildCheckBox() {
    return Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.orange,
                          fillColor: MaterialStateProperty.all(
                              Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          value: isChecked,
                          onChanged: (val) async {
                            bool originalState = isChecked;
                            setState(() {
                              isChecked = val!;
                            });
                            await widget
                                .onCheckedCallback(val!)
                                .then((response) {
                              if (!response) {
                                setState(() {
                                  isChecked = originalState;
                                });
                              }
                            });
                          },
                        ),
                        _buildTodoText(),
                      ],
                    );
  }

  Flexible _buildTodoText() {
    return Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              widget.todoModel.todo,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22.sp, color: Colors.white),
                            ),
                          ),
                        );
  }

  Row _buildDateTime(BuildContext context) {
    return Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                DateFormat('dd MMM yyyy')
                                    .format(widget.todoModel.createdAt),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
  }
}
