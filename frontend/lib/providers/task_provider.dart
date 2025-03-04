import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _authToken;

  bool get isLoading => _isLoading;
  List<Task> get tasks => _tasks;

  // Update to use your actual backend URL
  static const String _baseUrl = "http://127.0.0.1:5000/api/tasks";

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }

  Map<String, String> get _headers {
    final headers = {"Content-Type": "application/json"};
    if (_authToken != null) {
      headers["Authorization"] = "Bearer $_authToken";
    }
    return headers;
  }

  Future<void> fetchTasks() async {
    if (_authToken == null) {
      debugPrint("Cannot fetch tasks: No auth token");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("Fetching tasks from: $_baseUrl");
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> taskData = jsonDecode(response.body);
        _tasks = taskData.map((taskJson) => Task.fromJson(taskJson)).toList();
        debugPrint("Fetched ${_tasks.length} tasks");
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Token may be invalid");
        _authToken = null;
      } else {
        debugPrint("Failed to fetch tasks: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error fetching tasks: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(Task task) async {
    if (_authToken == null) {
      debugPrint("Cannot add task: No auth token");
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint("Adding task: ${task.title}");
      debugPrint("Task JSON: ${jsonEncode(task.toJson())}");
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(task.toJson()),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final newTask = Task.fromJson(responseData);
        _tasks.add(newTask);
        debugPrint("Task added successfully: ${newTask.id}");
        notifyListeners();
        return true;
      } else {
        debugPrint("Failed to add task: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error adding task: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> removeTask(String id) async {
    if (_authToken == null) {
      debugPrint("Cannot remove task: No auth token");
      return false;
    }

    try {
      debugPrint("Removing task: $id");
      final response = await http.delete(
        Uri.parse("$_baseUrl/$id"), 
        headers: _headers
      );
      
      debugPrint("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        debugPrint("Task removed successfully");
        notifyListeners();
        return true;
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Token may be invalid");
        _authToken = null;
        notifyListeners();
      } else {
        debugPrint("Failed to delete task: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error deleting task: $error");
    }
    return false;
  }

  Future<bool> updateTask(Task updatedTask) async {
    if (_authToken == null) {
      debugPrint("Cannot update task: No auth token");
      return false;
    }

    try {
      debugPrint("Updating task: ${updatedTask.id}");
      debugPrint("Updated task JSON: ${jsonEncode(updatedTask.toJson())}");
      
      final response = await http.put(
        Uri.parse("$_baseUrl/${updatedTask.id}"),
        headers: _headers,
        body: jsonEncode(updatedTask.toJson()),
      );

      debugPrint("Response status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        int index = _tasks.indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          _tasks[index] = updatedTask;
          debugPrint("Task updated successfully");
          notifyListeners();
        }
        return true;
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Token may be invalid");
        _authToken = null;
        notifyListeners();
      } else {
        debugPrint("Failed to update task: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error updating task: $error");
    }
    return false;
  }

  Future<bool> toggleTaskCompletion(String id) async {
    debugPrint("Toggling completion for task: $id");
    int index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      debugPrint("Task not found in local list");
      return false;
    }

    Task updatedTask = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    return await updateTask(updatedTask);
  }
}

