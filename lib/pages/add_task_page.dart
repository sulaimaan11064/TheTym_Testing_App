import 'package:flutter/material.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:file_picker/file_picker.dart';
//  import 'package:flutter_quill/flutter_quill.dart' as quill;

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProject;
  String? _selectedAssignee;
  DateTime _dueDate = DateTime.now();
  String _priority = "Low";
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _uploadedFileName;
// final quill.QuillController _quillController = quill.QuillController.basic();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     setState(() {
  //       _uploadedFileName = result.files.single.name;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Task",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Task Name Field
                  //SizedBox(height: 50.0,),
                  TextFormField(
                    controller: _taskNameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),

                  // Project Dropdown
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

                  // Assignee Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedAssignee,
                    decoration: InputDecoration(
                      labelText: 'Assignee',
                      border: OutlineInputBorder(),
                    ),
                    items: ['User 1', 'User 2', 'User 3']
                        .map((assignee) => DropdownMenuItem<String>(
                              value: assignee,
                              child: Text(assignee),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAssignee = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),

                  // Due Date Picker
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        "${_dueDate.toLocal()}".split(' ')[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Priority Dropdown
                  DropdownButtonFormField<String>(
                    value: _priority,
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Low', 'Medium', 'High']
                        .map((priority) => DropdownMenuItem<String>(
                              value: priority,
                              child: Text(priority),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _priority = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),

                  const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(), // Removes the border
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 30.0,
                          color: Colors.black,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          _uploadedFileName ??
                              'Drop files here or click to upload',
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Rich Text Editor
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Description',
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //     SizedBox(height: 8.0),

                  //     // Toolbar
                  //     quill.QuillToolbar.simple(
                  //       controller: _quillController,
                  //       configurations: quill.QuillSimpleToolbarConfigurations(
                  //          showAlignmentButtons: true,
                  //       showHeaderStyle: true,
                  //       showBoldButton: true,
                  //       showItalicButton: true,
                  //       showUnderLineButton: true,
                  //       showListNumbers: true,
                  //       showListBullets: true,
                  //       )

                  //     ),
                  //     SizedBox(height: 8.0),

                  //     // Editor
                  //     Container(
                  //       height: 200.0,
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.grey),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //       child: quill.QuillEditor(
                  //         controller: _quillController,
                  //         scrollController: ScrollController(),
                  //         configurations: quill.QuillEditorConfigurations(
                  //            scrollable: true,
                  //             autoFocus: false,
                  //        // readOnly: false, // Make it editable
                  //         expands: true,
                  //         padding: EdgeInsets.all(8.0),
                  //         ),

                  //         focusNode: FocusNode(),

                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 16.0),

                  // Upload File Field
                  // Inside _AddTaskWidgetState class

                  // GestureDetector(
                  //   onTap: _pickFile, // Trigger the file picker when tapped
                  //   child: DottedBorder(
                  //     borderType: BorderType.RRect,
                  //     radius: Radius.circular(8.0),
                  //     dashPattern: [6, 3],
                  //     color: Colors.grey,
                  //     child: Container(
                  //       padding: EdgeInsets.all(10.0),
                  //       width: double.infinity,
                  //       alignment: Alignment.center,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Icon(
                  //             Icons.upload_file,
                  //             size: 30.0,
                  //             color: Colors.grey,
                  //           ),
                  //           SizedBox(height: 8.0),
                  //           Text(
                  //             _uploadedFileName ??
                  //                 'Drop files here or click to upload',
                  //             style: TextStyle(color: Colors.black54),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Handle task creation
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Color(0xFFF72162),
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0)),
                  ],
                ),
              ),
            )));
  }
}
