import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital_app/models/doctor.dart';
import 'package:hospital_app/services/bed_service.dart';
import 'package:hospital_app/services/doctor_service.dart';

import '../models/admit_patient.dart';
import '../models/bed.dart';
import '../services/admit_patient_service.dart';

class AdmitPatientFormScreen extends StatefulWidget {
  final AdmitPatient? patient;

  const AdmitPatientFormScreen({super.key, this.patient});

  @override
  State<AdmitPatientFormScreen> createState() => _AdmitPatientFormScreenState();
}

class _AdmitPatientFormScreenState extends State<AdmitPatientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Doctor> _doctors = [];
  List<Bed> _beds = [];

  Doctor? _selectedDoctor;
  Bed? _selectedBed;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _advanceAmountController = TextEditingController();

  final AdmitPatientService _admitPatientService = AdmitPatientService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();

    if (widget.patient != null) {
      _nameController.text = widget.patient!.name;
      _emailController.text = widget.patient!.email;
      _addressController.text = widget.patient!.address;
      _phoneController.text = widget.patient!.phone;
      _genderController.text = widget.patient!.gender;
      _dobController.text = widget.patient!.dob.toIso8601String().split('T')[0];
      _advanceAmountController.text = widget.patient!.advanceAmount.toString();
    }
  }

  Future<void> _fetchData() async {
    try {
      final doctors = await DoctorService().getAllDoctors();
      final beds = await BedService().getAllBeds();

      setState(() {
        _doctors = doctors;
        _beds = beds;

        if (widget.patient != null) {
          _selectedDoctor = _doctors.firstWhere(
                  (doc) => doc.id == widget.patient!.doctorId,
              orElse: () => _doctors.first);
          _selectedBed = _beds.firstWhere(
                  (bed) => bed.id == widget.patient!.bedId,
              orElse: () => _beds.first);
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _advanceAmountController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate()) {
      try {
        final patient = AdmitPatient(
          id: widget.patient?.id,
          bedId: _selectedBed!.id,
          doctorId: _selectedDoctor!.id,
          name: _nameController.text,
          email: _emailController.text,
          address: _addressController.text,
          phone: _phoneController.text,
          gender: _genderController.text,
          dob: DateTime.parse(_dobController.text),
          advanceAmount: double.parse(_advanceAmountController.text),
        );

        if (widget.patient == null) {
          await _admitPatientService.savePatient(patient);
        } else {
          await _admitPatientService.updatePatient(widget.patient!.id!, patient);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.patient == null
                ? 'Patient added successfully'
                : 'Patient updated successfully'),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient == null ? 'Add Patient' : 'Edit Patient'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Doctor>(
                  decoration: const InputDecoration(labelText: 'Select Doctor'),
                  value: _selectedDoctor,
                  items: _doctors.map((doctor) {
                    return DropdownMenuItem<Doctor>(
                      value: doctor,
                      child: Text(doctor.name),
                    );
                  }).toList(),
                  onChanged: (doctor) {
                    setState(() => _selectedDoctor = doctor);
                  },
                  validator: (value) =>
                  value == null ? 'Please select a doctor' : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<Bed>(
                  decoration: const InputDecoration(labelText: 'Select Bed'),
                  value: _selectedBed,
                  items: _beds.map((bed) {
                    return DropdownMenuItem<Bed>(
                      value: bed,
                      child: Text('${bed.ward} - ${bed.bedNumber}'),
                    );
                  }).toList(),
                  onChanged: (bed) {
                    setState(() => _selectedBed = bed);
                  },
                  validator: (value) =>
                  value == null ? 'Please select a bed' : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(_nameController, 'Name'),
                _buildTextField(_emailController, 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter email';
                      final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!regex.hasMatch(value)) return 'Invalid email format';
                      return null;
                    }),
                _buildTextField(_phoneController, 'Phone'),
                _buildTextField(_genderController, 'Gender'),
                _buildTextField(_addressController, 'Address'),
                _buildTextField(
                  _dobController,
                  'Date of Birth (yyyy-MM-dd)',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter DOB';
                    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    if (!regex.hasMatch(value)) return 'Format must be yyyy-MM-dd';
                    return null;
                  },
                ),
                _buildTextField(_advanceAmountController, 'Advance Amount',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter amount';
                      if (double.tryParse(value) == null) return 'Enter valid number';
                      return null;
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _savePatient,
                  child: Text(widget.patient == null ? 'Add Patient' : 'Update Patient'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: validator ??
                (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }
}
