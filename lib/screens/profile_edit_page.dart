import 'dart:io';
import 'package:bike_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = true;
  String? _photoUrl;
  File? _newPhoto;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await _authService.getUserData();

    if (data != null) {
      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _cpfController.text = data['cpf'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _photoUrl = data['photoUrl'];
    }

    setState(() => _isLoading = false);
  }

  /// 📷 SELECIONAR FOTO
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() => _newPhoto = File(picked.path));
    }
  }

  /// 💾 SALVAR
  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    String? photoUrl = _photoUrl;

    if (_newPhoto != null) {
      photoUrl = await _profileService.uploadProfilePhoto(_newPhoto!);
    }

    await _profileService.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      photoUrl: photoUrl,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,

      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        title: Text(
          'byKeria',
          style: TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  /// AVATAR EDITÁVEL
                  GestureDetector(
                    onTap: _pickImage,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: _newPhoto != null
                              ? FileImage(_newPhoto!)
                              : (_photoUrl != null && _photoUrl!.isNotEmpty
                                    ? NetworkImage(_photoUrl!)
                                    : const AssetImage(
                                            'assets/images/profile.png',
                                          )
                                          as ImageProvider),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize:
                              MainAxisSize.min, // tamanho ajustado ao conteúdo
                          children: [
                            Text(
                              'Editar foto',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.yellow,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ), // pequeno espaço entre texto e ícone
                            Icon(
                              Icons.edit, // ícone de caneta
                              size:
                                  14, // tamanho pequeno para combinar com o texto
                              color: AppColors.yellow,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  _input('Nome', _nameController),
                  _input('E-mail', _emailController, enabled: false),
                  _input('CPF', _cpfController, enabled: false),
                  _input('Telefone', _phoneController, hint: '(00) 00000-0000'),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade600,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Salvar edição'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6), // espaçamento entre label e campo
          TextField(
            controller: controller,
            enabled: enabled,
            style: TextStyle(color: AppColors.darkTrue),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.gray),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: AppColors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: AppColors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
