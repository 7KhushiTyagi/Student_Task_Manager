import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(bool)? onToggleCompleted;
  final VoidCallback? onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    this.onToggleCompleted,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isCompleted,
          activeColor: Colors.purple,
          onChanged: onToggleCompleted != null 
              ? (value) => onToggleCompleted!(value ?? false) 
              : null,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          task.description.split('\n').first,
          style: TextStyle(
            color: Colors.white70,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${task.dueAt.hour}:${task.dueAt.minute.toString().padLeft(2, '0')}",
              style: TextStyle(color: Colors.orange),
            ),
            SizedBox(width: 8),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red[300]),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

