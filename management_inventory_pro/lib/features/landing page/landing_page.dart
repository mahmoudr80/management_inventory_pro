import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/dependency_injection/service_locator.dart';
import '../../core/storage/storage_service.dart';
import '../home/cubit/home_cubit.dart';
import '../home/home_screen.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _pickedImage;
  bool _isSaving = false;
  String? _error;

  final StorageService _storageService = getIt<StorageService>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: false,
    );
    if (result == null || result.files.single.path == null) return;

    setState(() {
      _pickedImage = File(result.files.single.path!);
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImage == null) {
      setState(() => _error = 'Please choose an image.');
      return;
    }

    final name = _nameController.text.trim();

    if (_storageService.isUserRegistered(name)) {
      setState(() => _error = 'A user named "$name" is already registered.');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await _storageService.saveUser(name: name, imageFile: _pickedImage!);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => BlocProvider(
          create: (context) => HomeCubit(),
          child: HomeScreen(),),
      ));
    } catch (e) {
      setState(() => _error = 'Could not save profile: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create your profile',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isSaving ? null : _pickImage,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : null,
                      child: _pickedImage == null
                          ? const Icon(Icons.add_a_photo_outlined, size: 32)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _isSaving ? null : _pickImage,
                    child: Text(
                      _pickedImage == null ? 'Choose image' : 'Change image',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name.';
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isSaving ? null : _submit,
                      child: _isSaving
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Save & continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
