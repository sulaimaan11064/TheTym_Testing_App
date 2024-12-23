import 'package:firstapp/pages/add_task_page.dart';
import 'package:firstapp/pages/calender_page.dart';
import 'package:firstapp/pages/invite/add_invite_page.dart';
import 'package:firstapp/pages/project/add_project_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  String _priority = "";
  Set<String> _selectedAssignees = {};
   bool isExpanded = false;

  // Animation Controller to control the animation timing
  AnimationController? _controller;
  Animation<double>? _heightAnimation;


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  void _showBottomSheet() {
    String? selectedProject; // Holds the selected project
    List<String> projectList = [
      'Project A',
      'Project B',
      'Project C'
    ]; // Example list

    DateTime selectedDate = DateTime.now(); // Default selected date

    void _showCalendarDatePicker(
        BuildContext context, Function(DateTime) onDateSelected) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (DateTime newDate) {
                      onDateSelected(newDate); // Update date on selection
                    },
                  ),
                ),

                // Align(
                //   alignment: Alignment.center,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.pop(context); // Close the date picker
                //       setState(() {}); // Trigger UI update
                //     },
                //     child: const Text("Confirm Date"),
                //   ),
                // ),
              ],
            ),
          );
        },
      );
    }

    void _showPriorityBottomSheet(
        BuildContext context, Function(String) onPrioritySelected) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          String selectedPriority =
              _priority; // Keep track of the selected priority

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  height: 400, // Adjust height as needed
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select Priority",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: ["Low", "Medium", "High"].map((priority) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              color: Colors.grey[
                                  300], // Set background color for each row
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal:
                                        16.0), // Padding for text and icon
                                leading: Icon(
                                  Icons.info_outline,
                                  color: priority == "Low"
                                      ? Colors.green
                                      : priority == "Medium"
                                          ? Colors.orange
                                          : Colors.red,
                                ), // Place the icon on the left
                                title: Text(priority),
                                trailing: selectedPriority == priority
                                    ? const Icon(Icons.check,
                                        color: Colors.blue)
                                    : null,
                                onTap: () {
                                  setModalState(() {
                                    selectedPriority = priority;
                                  });
                                  onPrioritySelected(
                                      priority); // Assuming this is defined to handle priority change
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            // Use StatefulBuilder to handle state changes inside bottom sheet
            builder: (BuildContext context, StateSetter setModalState) {
             if (_controller == null) {
              _controller = AnimationController(
                vsync: this, // Correct way to use TickerProvider
                duration: const Duration(milliseconds: 500),
              );

              _heightAnimation = Tween<double>(
                begin: MediaQuery.of(context).size.height * 0.4,
                end: MediaQuery.of(context).size.height * 0.9,
              ).animate(CurvedAnimation(
                parent: _controller!,
                curve: Curves.easeInOut,
              ));
            }
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child:  AnimatedBuilder(
                animation: _heightAnimation!,
                builder: (context, child) {
                  return
            Container(
             height: _heightAnimation!.value,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          value: selectedProject, // Display selected value
                          hint: const Text(
                            "Select Project",
                            style: TextStyle(color: Colors.black),
                          ),
                          underline: const SizedBox(), // Removes underline
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.black),
                          items: projectList.map((String project) {
                            return DropdownMenuItem<String>(
                              value: project,
                              child: Text(
                                project,
                                style: TextStyle(
                                    color: selectedProject == "" ||
                                            selectedProject == null
                                        ? null
                                        : Colors.blue,
                                    fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setModalState(() {
                              selectedProject =
                                  newValue; // Update the selected value
                            });
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                        icon: Icon(
                          size: 28.0,
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          //color: Colors.blue,
                        ),
                        onPressed: () {
                           if (isExpanded) {
                                  _controller?.reverse();
                                } else {
                                  _controller?.forward();
                                }

                                setModalState(() {
                                  isExpanded = !isExpanded;
                                });
                        },
                      ),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedAssignees = {};
                              _priority = "";
                            });

                            Navigator.pop(context); // Close the bottom sheet
                          },
                          icon: const Icon(Icons.close),
                        ),
                          ],
                        )
                      
                      ],
                    ),
                    //const SizedBox(height: 7.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Type your task name...",
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none, // Removes the border
                        focusedBorder:
                            InputBorder.none, // Removes border on focus
                        enabledBorder:
                            InputBorder.none, // Removes border when enabled
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10), // Padding adjustment
                      ),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_selectedAssignees.isEmpty)
                          ElevatedButton.icon(
                            onPressed: () {
                              _showAssigneeBottomSheet(
                                  (Set<String> selectedAssignees) {
                                setModalState(() {
                                  _selectedAssignees = selectedAssignees;
                                });
                              });
                            },
                            icon: const Icon(Icons.person_add,
                                color: Colors.blue),
                            label: const Text(
                              "Assignee",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              minimumSize:
                                  const Size(160, 48), // Fixed width and height
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        // if (_selectedAssignees.isNotEmpty)
                        // GestureDetector(
                        //   onTap: () {
                        //      _showAssigneeBottomSheet(
                        //           (Set<String> selectedAssignees) {
                        //         setModalState(() {
                        //           _selectedAssignees = selectedAssignees;
                        //         });
                        //       });

                        //   },
                        //   child:  _buildSelectedAssigneesRow(_selectedAssignees),
                        // ),

                        if (_selectedAssignees.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _showAssigneeBottomSheet(
                                  (Set<String> selectedAssignees) {
                                setState(() {
                                  _selectedAssignees = selectedAssignees;
                                });
                              });
                            },
                            onLongPress: () {
                              // Show the tooltip on mobile
                              final tooltip = Tooltip(
                                message: _selectedAssignees.join(', '),
                                waitDuration: const Duration(milliseconds: 500),
                                showDuration: const Duration(
                                    seconds: 3), // Tooltip stays longer
                              );

                              // The following hack is needed to manually show the Tooltip widget
                              final overlay = Overlay.of(context);
                              final entry = OverlayEntry(
                                builder: (context) => Positioned(
                                  left: 50.0, // Customize position
                                  top: 200.0, // Customize position
                                  child: Material(
                                    color: Colors.transparent,
                                    child: tooltip,
                                  ),
                                ),
                              );
                              overlay.insert(entry);
                              Future.delayed(Duration(seconds: 3), () {
                                entry.remove();
                              });
                            },
                            child: Tooltip(
                              message: _selectedAssignees
                                  .join(', '), // Display all assignee names
                              waitDuration: const Duration(milliseconds: 500),
                              child: _buildSelectedAssigneesRow(
                                  _selectedAssignees),
                            ),
                          ),

                        const SizedBox(width: 10.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showCalendarDatePicker(context,
                                (DateTime newDate) {
                              setModalState(() {
                                selectedDate = newDate;
                              });
                              Navigator.pop(context);
                            });
                          },
                          icon: const Icon(Icons.calendar_today,
                              color: Colors.blue),
                          label: Text(
                            "${selectedDate.toLocal()}"
                                .split(' ')[0], // Display the selected date
                            style: const TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            minimumSize:
                                const Size(160, 48), // Fixed width and height
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //if (_selectedAssignees.isNotEmpty)
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Text(
                    //         _selectedAssignees.isEmpty
                    //             ? "Select Assignee"
                    //             : _selectedAssignees.length > 3
                    //                 ? "${_selectedAssignees.take(5).join(", ")}..." // Limit to 3 assignees with ellipsis
                    //                 : _selectedAssignees.join(", "),
                    //         style: const TextStyle(color: Colors.black),
                    //         overflow: TextOverflow
                    //             .ellipsis, // Add ellipsis if text overflows
                    //         maxLines: 2, // Prevent multiple lines
                    //       ),
                    //     )
                    //   ],
                    // ),

                    // if (_selectedAssignees.isNotEmpty)
                    //  _buildSelectedAssigneesRow(_selectedAssignees),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          "Priority",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            _showPriorityBottomSheet(context,
                                (String selectedPriority) {
                              setModalState(() {
                                _priority =
                                    selectedPriority; // Update the selected priority
                              });
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: _priority == "Low"
                                    ? Colors.green
                                    : _priority == "Medium"
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _priority.isEmpty
                                    ? "Select Priority"
                                    : _priority,
                                style: TextStyle(
                                  color: _priority == "Low"
                                      ? Colors.green
                                      : _priority == "Medium"
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if(isExpanded == true)
                    const TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Add Description",
                        border: InputBorder.none, // Removes the border
                        focusedBorder:
                            InputBorder.none, // Removes border on focus
                        enabledBorder:
                            InputBorder.none, // Removes border when enabled
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10), //
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedAssignees = {};
                              _priority = "";
                            });

                            Navigator.pop(context); // Close the bottom sheet
                          },
                          icon: const Icon(Icons.attach_file),
                        ),

                        ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Create Task",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF72162),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                      ),
                      ],
                    )
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //     child: const Text(
                    //       "Create Task",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Color(0xFFF72162),
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 32, vertical: 12),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );}),
          );
        });
      },
    );
  }

  Widget _buildSelectedAssigneesRow(Set<String> selectedAssignees) {
    // Limit to show only 5 assignees for display
    const maxVisibleAssignees = 5;
    final assigneesList = selectedAssignees.toList();
    final visibleAssignees = assigneesList.length > maxVisibleAssignees
        ? assigneesList.take(maxVisibleAssignees).toList()
        : assigneesList;

    return Container(
      width: 160.0, // Set a fixed width
      height: 48.0, // Fixed height
      //alignment: Alignment.center,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Stack(
        clipBehavior:
            Clip.none, // Allow avatars to overflow outside the container
        alignment: Alignment.center,
        children: [
          ...visibleAssignees.asMap().entries.map((entry) {
            final index = entry.key;
            final assignee = entry.value;

            return Positioned(
              left: index * 20.0, // Overlap by controlling the left position
              child: CircleAvatar(
                radius: 16.0, // Adjust size of avatar
                backgroundColor: Colors.blue, // Placeholder color
                child: Text(
                  assignee[0]
                      .toUpperCase(), // Display first letter as placeholder
                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            );
          }).toList(),
          // Show "+X" if there are more assignees than visible
          if (assigneesList.length > maxVisibleAssignees)
            Positioned(
              left: visibleAssignees.length * 23.0,
              top: 6, // Position after the last avatar
              child: Text(
                "+${assigneesList.length - maxVisibleAssignees}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAssigneeBottomSheet(Function(Set<String>) onAssigneesSelected) {
    Set<String> selectedAssignees = {}; // Track checked/unchecked assignees

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header and other UI elements

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Assignees",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel",
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // List of Assignees
                  Expanded(
                    child: ListView(
                      children: [
                        _buildAssigneeItem(
                            "Courtney Henry",
                            "deanna.curtis@example.com",
                            Colors.yellow,
                            selectedAssignees,
                            setState),
                        _buildAssigneeItem(
                            "Leslie Alexander",
                            "sara.cruz@example.com",
                            Colors.green,
                            selectedAssignees,
                            setState),
                        _buildAssigneeItem(
                            "Guy Hawkins",
                            "alma.lawson@example.com",
                            Colors.purple,
                            selectedAssignees,
                            setState),
                        _buildAssigneeItem(
                            "Wade Warren",
                            "nathan.roberts@example.com",
                            Colors.blue,
                            selectedAssignees,
                            setState),
                        _buildAssigneeItem(
                            "Esther Howard",
                            "bill.sanders@example.com",
                            Colors.orange,
                            selectedAssignees,
                            setState),
                        _buildAssigneeItem(
                            "Kristin Watson",
                            "willie.jennings@example.com",
                            Colors.grey,
                            selectedAssignees,
                            setState),
                        _buildAssigneeItem(
                            "John smith",
                            "john.smith@example.com",
                            Colors.red,
                            selectedAssignees,
                            setState),
                      ],
                    ),
                  ),

                  // Done Button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        onAssigneesSelected(
                            selectedAssignees); // Pass selected assignees back
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: const Text("Done"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAssigneeItem(String name, String email, Color avatarColor,
      Set<String> selectedAssignees, Function setState) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: Text(name[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(name),
      subtitle: Text(email),
      trailing: Checkbox(
        value: selectedAssignees.contains(name),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              selectedAssignees.add(name); // Add to selected assignees
            } else {
              selectedAssignees.remove(name); // Remove from selected assignees
            }
          });
        },
      ),
    );
  }

  final List<Map<String, String>> events = [
    {
      'title': 'Meeting with Client',
      'subtitle': 'Dec 21, 2024 | 9:00 AM',
      'duration': '1H',
    },
    {
      'title': 'Project Deadline',
      'subtitle': 'Dec 22, 2024 | 5:00 PM',
      'duration': '1D',
    },
    {
      'title': 'Team Outing',
      'subtitle': 'Dec 23, 2024 | 10:00 AM',
      'duration': 'All Day',
    },
  ];

@override
Widget build(BuildContext context) {
  // Sample list of events
  final List<Map<String, String>> events = [
    {
      'title': 'Daily Standup',
      'subtitle': 'Dec 20, 2024 | 9:00 AM',
      'duration': '1H',
    },
    {
      'title': 'Project Planning',
      'subtitle': 'Dec 21, 2024 | 11:00 AM',
      'duration': '2H',
    },
    {
      'title': 'Team Lunch',
      'subtitle': 'Dec 22, 2024 | 1:00 PM',
      'duration': '3H',
    },
  ];

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFFF72162),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white),
          ),
          PopupMenuButton<String>(
            color: Colors.white,
           popUpAnimationStyle: AnimationStyle(curve: Curves.easeInCirc, duration: Duration(milliseconds: 400)),
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value selected')),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Task',
                child: ListTile(
                  leading: Icon(Icons.check_box),
                  title: Text('Task'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskPage()),
                    );
                  },
                ),
              ),
              PopupMenuItem<String>(
                value: 'Project',
                child: ListTile(
                  leading: Icon(Icons.folder),
                  title: Text('Project'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddProjectPage()),
                    );
                  },
                ),
              ),
              PopupMenuItem<String>(
                value: 'Event',
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Event'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CalenderPage()),
                    );
                  },
                ),
              ),
              PopupMenuItem<String>(
                value: 'Invite Member',
                child: ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Invite Member'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AddInvitePage()),
                    );
                  },
                ),
              ),
            ],
            child: ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hello, User!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Dec 3, 2024 | You have 149 tasks in 2 projects',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusCard('New', '49', Colors.blue),
              _buildStatusCard('In Progress', '50', Colors.orange),
              _buildStatusCard('Review', '50', Colors.amber),
              _buildStatusCard('Completed', '-', Colors.green),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'My Tasks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TabBarSection(),
          const SizedBox(height: 20),
          const Text(
            'Upcoming Events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Dynamic list of events
          Column(
            children: events.map((event) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Colors.grey,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: ListTile(
                  title: Text(event['title']!),
                  subtitle: Text(event['subtitle']!),
                  trailing: CircleAvatar(
                    child: Text(event['duration']!),
                    backgroundColor: Colors.blue,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _showBottomSheet,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        "New Task",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF72162),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  );
}

  Widget _buildStatusCard(String status, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}

class TabBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Overdue'),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 250,
            child: TabBarView(
              children: [
                Center(child: Text('No tasks for today')),
                Center(child: Text('No upcoming tasks')),
                Center(child: Text('No overdue tasks')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
