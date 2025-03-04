import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/task_provider.dart";
import "../models/task.dart";
import 'package:confetti/confetti.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  _NewTaskScreenState createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  late ConfettiController _confettiController;
  String? _selectedSubject;
  String? _selectedChapter;
  final TextEditingController _subtopicController = TextEditingController();
  String? _selectedActivityType;
  String? _selectedDifficulty;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isSaving = false;

  final List<String> subjects = [
    "Mathematics",
    "Science",
    "History",
    "Programming",
    "Languages",
  ];
  final List<String> chapters = [
    "Chapter 1",
    "Chapter 2",
    "Chapter 3",
    "Chapter 4",
    "Chapter 5",
  ];
  final List<String> activityTypes = ["Concept", "Notes", "Exercise"];
  final List<String> difficultyLevels = ["Easy", "Medium", "Hard"];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _subtopicController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickStartTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _startTime = pickedTime;
      });
    }
  }

  void _pickEndTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_selectedSubject == null ||
        _selectedChapter == null ||
        _subtopicController.text.isEmpty ||
        _selectedActivityType == null ||
        _selectedDifficulty == null ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final DateTime startDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final DateTime endDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    final String description =
        'Subject: $_selectedSubject\nChapter: $_selectedChapter\nType: $_selectedActivityType\nDifficulty: $_selectedDifficulty\nTime: ${_startTime!.format(context)} to ${_endTime!.format(context)}';

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final newTask = Task(
      id: '',
      title: _subtopicController.text.trim(),
      description: description,
      date: startDateTime,
      isCompleted: false, dueAt: DateTime.now(),
    );

    final success = await taskProvider.addTask(newTask);

    setState(() {
      _isSaving = false;
    });

    if (success) {
      Navigator.pop(context, newTask);
      _confettiController.play();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save task"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
        backgroundColor: Color(0xFF8B6BFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF8B6BFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Subject dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF6A4FBF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedSubject,
                        hint: Text(
                          "Subject",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        dropdownColor: Color(0xFF6A4FBF),
                        style: TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSubject = newValue;
                          });
                        },
                        items: subjects.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Chapter dropdown
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF6A4FBF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedChapter,
                        hint: Text(
                          "Chapter",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        dropdownColor: Color(0xFF6A4FBF),
                        style: TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedChapter = newValue;
                          });
                        },
                        items: chapters.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Subtopic text field
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF6A4FBF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _subtopicController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter the Subtopic",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "For the above topic what are you going to do?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      // Activity type selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: activityTypes.map((type) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedActivityType = type;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedActivityType == type
                                    ? Color(0xFF6A4FBF)
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 24),
                      Text(
                        "What difficulty rating would you give for the task chosen?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      // Difficulty selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: difficultyLevels.map((level) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedDifficulty = level;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedDifficulty == level
                                    ? Color(0xFF6A4FBF)
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    level,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  if (level == "Easy") SizedBox(width: 4),
                                  if (level == "Easy")
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  if (level == "Medium") SizedBox(width: 4),
                                  if (level == "Medium")
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  if (level == "Medium")
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 24),
                      Text(
                        "Date:",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 8),

                      // Date selection
                      InkWell(
                        onTap: _pickDate,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF6A4FBF),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _selectedDate == null
                                  ? "Select Date"
                                  : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                              style: TextStyle(
                                color: Color(0xFF8B6BFF),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24),
                      Text(
                        "Time:",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 8),

                      // Time selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: _pickStartTime,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF6A4FBF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _startTime == null
                                    ? "Select Time From"
                                    : _startTime!.format(context),
                                style: TextStyle(
                                  color: Color(0xFF8B6BFF),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _pickEndTime,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF6A4FBF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _endTime == null
                                    ? "Select Time To"
                                    : _endTime!.format(context),
                                style: TextStyle(
                                  color: Color(0xFF8B6BFF),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B6BFF),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isSaving
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Create Task",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}