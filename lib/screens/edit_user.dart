import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_crud/models/student_model.dart';
import 'package:sqflite_crud/services/student_database.dart';

class EditStudentPage extends StatefulWidget {
  const EditStudentPage({super.key, required this.student});

  final Student student;

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _studentDb = StudentDatabase.instance;
  final _nameController = TextEditingController();
  final _nisnController = TextEditingController();
  final _birthDateController = TextEditingController();
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Data Siswa',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        _imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.purple,
                ),
                child: const Text(
                  'Pilih Gambar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function Untuk Proses Update Data User
  Future<void> _updateStudent() async {
    final student = Student(
      id: widget.student.id,
      name: _nameController.text,
      nisn: _nisnController.text,
      birthDate: _birthDateController.text,
      photoPath: _imageFile?.path,
    );

    await _studentDb.updateStudent(student);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Siswa Diperbarui!')),
    );

    Navigator.pop(context);
  }

  // Function Untuk Handle Image User
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Function Untuk Menghandle Date
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
