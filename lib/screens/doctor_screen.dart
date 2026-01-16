import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital_app/models/doctor.dart';

import 'package:image_picker/image_picker.dart';

import '../services/doctor_service.dart';

class DoctorScreen extends StatefulWidget {
  final Doctor? doctor;

  const DoctorScreen({super.key, this.doctor});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _specializationController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();

  File? _image;
  String? _imageUrl;

  final DoctorService _doctorService = DoctorService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.doctor != null) {
      _nameController.text = widget.doctor!.name;
      _emailController.text = widget.doctor!.email;
      _passwordController.text = widget.doctor!.password;
      _specializationController.text = widget.doctor!.specialization;
      _qualificationController.text = widget.doctor!.qualification;
      _experienceController.text = widget.doctor!.experience.toString();
      _hospitalNameController.text = widget.doctor!.hospitalName;
      _phoneController.text = widget.doctor!.phone;
      _dateController.text = widget.doctor!.date;
      _imageUrl = widget.doctor!.image;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _hospitalNameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _saveDoctor() async {
    if (_formKey.currentState!.validate()) {
      final doctor = Doctor(
        id: widget.doctor?.id,
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        specialization: _specializationController.text,
        qualification: _qualificationController.text,
        experience: int.parse(_experienceController.text),
        hospitalName: _hospitalNameController.text,
        phone: _phoneController.text,
        date: _dateController.text,

        image: _imageUrl,
      );

      try {
        Doctor savedDoctor;
        if (widget.doctor == null) {
          savedDoctor = await _doctorService.saveDoctor(doctor);
        } else {
          savedDoctor = await _doctorService.updateDoctor(
            widget.doctor!.id!,
            doctor,
          );
        }

        if (_image != null) {
          final imageUrl = await _doctorService.uploadImage(
            savedDoctor.id!,
            _image!,
          );

          final updatedDoctor = Doctor(
            id: savedDoctor.id,
            name: savedDoctor.name,
            email: savedDoctor.email,
            password: savedDoctor.password,
            specialization: savedDoctor.specialization,
            qualification: savedDoctor.qualification,
            experience: savedDoctor.experience,
            hospitalName: savedDoctor.hospitalName,
            phone: savedDoctor.phone,
            date: savedDoctor.date,
            image: imageUrl,
          );
          await _doctorService.updateDoctor(savedDoctor.id!, updatedDoctor);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.doctor == null ? ' Doctor added' : 'Doctor updated',
            ),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor == null ? 'Add Doctor' : 'Edit Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Enter a name ' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter an email';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a Specialization ' : null,
                ),
                TextFormField(
                  controller: _qualificationController,
                  decoration: const InputDecoration(labelText: 'Qualification'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a Qualification ' : null,
                ),
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(labelText: 'Experience'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter an Experience';
                    if (int.tryParse(value) == null)
                      return 'Enter a valid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hospitalNameController,
                  decoration: const InputDecoration(labelText: 'HospitalName'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a HospitalName ' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a Phone ' : null,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth (yyyy-MM-dd)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter a date ';
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return 'Enter date as yyyy-MM-dd';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveDoctor,
                  child: Text(
                    widget.doctor == null ? 'Add Doctor' : 'Update Doctor',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
