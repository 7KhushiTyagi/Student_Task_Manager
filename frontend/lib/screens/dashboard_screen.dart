import "package:flutter/material.dart";
import "package:frontend/screens/add_task_screen.dart";
import "package:frontend/screens/sidebar_menu.dart";
import "package:frontend/widgets/taskcard.dart";
import "package:provider/provider.dart";
import "../providers/task_provider.dart";
import "../models/task.dart";

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedDay = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  void _scrollToToday() {
    final today = DateTime.now();
    setState(() {
      _selectedDay = today;
    });

    final offset = (today.day - 1) * 68.0;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, 
        elevation: 10, 
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple], 
                            begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), 
                blurRadius: 10, 
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        title: const Text(
          'Hi Khushi!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black, 
                blurRadius: 5,
                offset: Offset(2, 2), 
              ),
            ],
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.purple),
          ),
          SizedBox(width: 16),
        ],
      ),
      drawer: const SidebarMenu(),
      body: Column(
        children: [
          _buildCalendarSection(),
          _buildTaskSummary(context),
          Expanded(child: _buildDailyTasks(context)),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(context),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildCalendarSection() {
    final monthYear =
        "${_getMonthName(_selectedDay.month)} ${_selectedDay.year}";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthYear,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: _scrollToToday,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount:
                DateTime(_selectedDay.year, _selectedDay.month + 1, 0).day,
            itemBuilder: (context, index) {
              DateTime date = DateTime(
                _selectedDay.year,
                _selectedDay.month,
                index + 1,
              );
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDay = date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color:
                        isSameDay(_selectedDay, date)
                            ? Colors.orange
                            : Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:
                        isSameDay(_selectedDay, date)
                            ? [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                            : [],
                  ),
                  alignment: Alignment.center,
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                        ][date.weekday % 7],
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTaskSummary(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    return Column(
      children: [
        _taskCard(
          'Daily Tasks',
          '${taskProvider.tasks.length} tasks',
          80,
          Colors.orange,
        ),
        _taskCard('Weekly Tasks', '35 tasks', 52, Colors.cyan),
        _taskCard('Monthly Tasks', '60 tasks', 28, Colors.green),
      ],
    );
  }

  Widget _taskCard(String title, String count, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: CircularProgressIndicator(
            value: (progress / 100).clamp(0.0, 1.0),
            color: color,
            strokeWidth: 5,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(count, style: const TextStyle(color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDailyTasks(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasksForSelectedDay =
        taskProvider.tasks
            .where((task) => isSameDay(task.date, _selectedDay))
            .toList();
    final completedTasks =
        tasksForSelectedDay.where((task) => task.isCompleted).length;
    final totalTasks = tasksForSelectedDay.length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (totalTasks > 0)
            LinearProgressIndicator(
              value: totalTasks == 0 ? 0 : completedTasks / totalTasks,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              minHeight: 8,
            ),
          const SizedBox(height: 16),
          Expanded(
            child:
                tasksForSelectedDay.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 80,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks for ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: tasksForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final task = tasksForSelectedDay[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to a detailed task view
                            _navigateToTaskDetails(context, task);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TaskCard(
                              task: task,
                              onToggleCompleted:
                                  (value) =>
                                      task.id != null
                                          ? taskProvider.toggleTaskCompletion(
                                            task.id!,
                                          )
                                          : null,
                              onDelete:
                                  () =>
                                      task.id != null
                                          ? _confirmDeleteTask(
                                            context,
                                            task.id!,
                                          )
                                          : null,
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _navigateToTaskDetails(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsScreen(task: task)),
    );
  }

  void _confirmDeleteTask(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<TaskProvider>().removeTask(taskId);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildAnimatedFAB(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      child: const Icon(Icons.add, color: Colors.white),
      onPressed: () async {
        final newTask = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewTaskScreen()),
        );
        if (newTask != null && newTask is Task) {
          context.read<TaskProvider>().addTask(newTask);
        }
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
        BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 0,
      onTap: (index) {},
    );
  }

  bool isSameDay(DateTime date, DateTime selectedDay) {
    return date.year == selectedDay.year &&
        date.month == selectedDay.month &&
        date.day == selectedDay.day;
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

// Task Details Screen
class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              task.description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Due: ${task.date.toLocal()}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
