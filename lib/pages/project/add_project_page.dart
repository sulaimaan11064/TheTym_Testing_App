import 'package:flutter/material.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final List<Map<String, dynamic>> members = [
    {'name': 'Sulaimaan', 'email': 'sulaimaan@thetym.com', "status": true},
    {'name': 'Sabarish Somasundaram', 'email': 'sabarish@thetym.com', "status": true},
    {'name': 'Selvam Rajendran', 'email': 'selvam@thetym.com', "status": false},
    {'name': 'Thamotharan Saravanan', 'email': 'thamotharan@thetym.com', "status": false},
    {'name': 'Thetym Test Mail', 'email': 'test@thetym.com', "status": false},
    {'name': 'Vishnu K', 'email': 'vishnu@thetym.com', "status": false},
    {'name': 'Karthikeyan', 'email': 'karthik@thetym.com', "status": false},
  ];

  final List<TextEditingController> emailControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Project",
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Project Name *',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type your description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Invite Members',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // TabBar section wrapped inside an Expanded widget to take remaining space
            Expanded(
              child: TabBarSection(
                members: members,
                emailControllers: emailControllers,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Project Created')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF72162),
            minimumSize: Size(double.infinity, 40),
          ),
          child: Text(
            'Create',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class TabBarSection extends StatefulWidget {
  final List<Map<String, dynamic>> members;
  final List<TextEditingController> emailControllers;

  const TabBarSection({
    Key? key,
    required this.members,
    required this.emailControllers,
  }) : super(key: key);

  @override
  State<TabBarSection> createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredMembers = [];
  ScrollController scrollController = ScrollController();  // Add a ScrollController

  @override
  void initState() {
    super.initState();
    filteredMembers = widget.members; // Initially, show all members
    searchController.addListener(_filterMembers); // Listen to search changes
  }

  void _filterMembers() {
    setState(() {
      filteredMembers = widget.members
          .where((member) => member['name']
              .toLowerCase()
              .contains(searchController.text.toLowerCase())) // Filter based on search
          .toList();
    });
  }

  void addEmailField() {
    setState(() {
      widget.emailControllers.add(TextEditingController());
    });

    // Scroll to the last email field after adding a new one
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void removeEmailField(int index) {
    setState(() {
      widget.emailControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(text: 'Members'),
              Tab(text: 'Add new'),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                // Members tab with search and filtered list
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Members',
                          hintText: 'Enter search query...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0), // Rounded corners
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    // The list of CheckboxListTile will be scrollable
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...filteredMembers.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> member = entry.value;

                              return CheckboxListTile(
                                title: Text(member['name']!),
                                subtitle: Text(member['email']!),
                                value: member['status'],
                                onChanged: (bool? value) {
                                  setState(() {
                                    widget.members[index]['status'] = value;
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Add new members tab with email fields
                SingleChildScrollView(
                  controller: scrollController,  // Attach ScrollController here
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      ...widget.emailControllers.asMap().entries.map((entry) {
                        int index = entry.key;
                        TextEditingController controller = entry.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  suffixIcon: index >= 3
                                      ? IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => removeEmailField(index),
                                        )
                                      : null,
                                  labelText: 'name@email.com',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 10.0),
                      InkWell(
                        onTap: addEmailField,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500)),
                          child: Icon(Icons.add, color: Colors.blue, size: 30.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

