import 'package:flutter/material.dart';

class AddInvitePage extends StatefulWidget {
  const AddInvitePage({super.key});

  @override
  State<AddInvitePage> createState() => _AddInvitePageState();
}

class _AddInvitePageState extends State<AddInvitePage> {
  final List<TextEditingController> emailControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  String? _selectedProject;
  final ScrollController _scrollController = ScrollController();

  void addEmailField() {
    setState(() {
      emailControllers.add(TextEditingController());
    });
    // Scroll to the last item
    Future.delayed(Duration(milliseconds: 150), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    });
  }

  void removeEmailField(int index) {
    setState(() {
      emailControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Invite Members",
          style: TextStyle(
              color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Attach the controller here
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedProject,
                decoration: InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                ),
                items: ['Project A', 'Project B', 'Project C']
                    .map((project) => DropdownMenuItem<String>(
                          value: project,
                          child: Text(project),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProject = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                "Add Email Address",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              ...emailControllers.asMap().entries.map((entry) {
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
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade500)),
                child: IconButton(
                  onPressed: addEmailField,
                  icon: Icon(Icons.add),
                  iconSize: 30.0,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
