import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visivallet/core/form_validator.dart';
import 'package:visivallet/core/widgets/loading_overlay.dart';
import 'package:visivallet/core/widgets/success_snackbar.dart';
import 'package:visivallet/theme/screen_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visivallet/main.dart'; // Import to access the themeModeProvider

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final PhoneController _phoneController = PhoneController(initialValue: const PhoneNumber(isoCode: IsoCode.FR, nsn: ""));

  Uint8List? _profileImage;

  bool _isEditing = false;
  String? _errorMessage;

  Future<void> _loadProfile() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    _firstNameController.text = preferences.getString('firstName') ?? '';
    _lastNameController.text = preferences.getString('lastName') ?? '';
    _emailController.text = preferences.getString('email') ?? '';
    _phoneController.value = PhoneNumber(isoCode: IsoCode.FR, nsn: preferences.getString('phone') ?? '');
    _profileImage = _profileImage ?? (preferences.getString('profileImage') != null ? base64Decode(preferences.getString('profileImage')!) : null);
  }

  Future<void> _changeTheme(ThemeMode themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeValue;

    switch (themeMode) {
      case ThemeMode.dark:
        themeValue = 'dark';
        break;
      case ThemeMode.light:
        themeValue = 'light';
        break;
      default:
        themeValue = 'system';
    }

    await prefs.setString('themeMode', themeValue);

    // Update the provider to make the change immediate
    ref.read(themeModeProvider.notifier).state = themeMode;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _profileImage = imageBytes;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Impossible de charger l'image: $e";
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      _errorMessage = null;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    LoadingOverlay.of(context).show();
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString('firstName', _firstNameController.text);
    await preferences.setString('lastName', _lastNameController.text);
    await preferences.setString('email', _emailController.text);
    await preferences.setString('phone', _phoneController.value.international);
    if (_profileImage != null) {
      await preferences.setString('profileImage', base64Encode(_profileImage!));
    }

    setState(() {
      _isEditing = false;
      _errorMessage = null;
      LoadingOverlay.of(context).hide();
      SuccessSnackbar.show(context, "Profil enregistré avec succès");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveProfile : _toggleEditMode,
            tooltip: _isEditing ? "Enregistrer" : "Modifier",
          ),
        ],
      ),
      body: FutureBuilder(
          future: _loadProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenHelper.instance.horizontalPadding,
                    vertical: 8,
                  ),
                  child: Text("Une erreur est survenue : ${snapshot.error}"),
                ),
              );
            }

            return _isEditing ? _buildEditingView() : _buildProfileView();
          }),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero image section with profile photo
          Container(
            width: double.infinity,
            height: 200,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 4,
                  ),
                  image: _profileImage != null
                      ? DecorationImage(
                          image: MemoryImage(_profileImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profileImage == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
            ),
          ),

          // Name section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${_firstNameController.text} ${_lastNameController.text}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          // Info cards
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenHelper.instance.horizontalPadding,
              vertical: 8,
            ),
            child: Column(
              children: [
                _buildInfoTile(Icons.email, "Email", _emailController.text),
                _buildInfoTile(Icons.phone, "Téléphone", _phoneController.value.international),
                _buildThemeTile(),
              ],
            ),
          ),

          // Edit button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: FilledButton.icon(
              onPressed: _toggleEditMode,
              icon: const Icon(Icons.edit),
              label: const Text("Modifier mon profil"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeTile() {
    // Read the current theme from the provider
    final currentThemeMode = ref.watch(themeModeProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.brightness_6, color: Theme.of(context).colorScheme.primary),
            title: Text(
              "Thème",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            subtitle: Text(
              _getThemeModeName(currentThemeMode),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildThemeOption(
                  icon: Icons.brightness_auto,
                  label: "Auto",
                  themeMode: ThemeMode.system,
                  isSelected: currentThemeMode == ThemeMode.system,
                ),
                _buildThemeOption(
                  icon: Icons.light_mode,
                  label: "Clair",
                  themeMode: ThemeMode.light,
                  isSelected: currentThemeMode == ThemeMode.light,
                ),
                _buildThemeOption(
                  icon: Icons.dark_mode,
                  label: "Sombre",
                  themeMode: ThemeMode.dark,
                  isSelected: currentThemeMode == ThemeMode.dark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required ThemeMode themeMode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => _changeTheme(themeMode),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: Icon(
                icon,
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'Mode sombre';
      case ThemeMode.light:
        return 'Mode clair';
      default:
        return 'Automatique (système)';
    }
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildEditingView() {
    // Keep your existing edit mode UI
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenHelper.instance.horizontalPadding,
          vertical: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfileImage(),
                      const SizedBox(height: 24),
                      _buildInfoForm(),
                    ],
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: _toggleEditMode,
                    icon: const Icon(Icons.cancel),
                    label: const Text("Annuler"),
                  ),
                  FilledButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save),
                    label: const Text("Enregistrer"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surfaceVariant,
            image: _profileImage != null
                ? DecorationImage(
                    image: MemoryImage(_profileImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _profileImage == null
              ? Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
              : null,
        ),
        if (_isEditing)
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                readOnly: !_isEditing,
                decoration: const InputDecoration(
                  labelText: "Prénom",
                  hintText: "Votre prénom",
                ),
                validator: FormValidator.requiredValidator,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                readOnly: !_isEditing,
                decoration: const InputDecoration(
                  labelText: "Nom",
                  hintText: "Votre nom",
                ),
                validator: FormValidator.requiredValidator,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          readOnly: !_isEditing,
          decoration: const InputDecoration(
            labelText: "Email",
            hintText: "Votre adresse email",
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => FormValidator.emailValidator(value, isRequired: true),
        ),
        const SizedBox(height: 16),
        PhoneFormField(
          controller: _phoneController,
          enabled: _isEditing,
          decoration: const InputDecoration(
            labelText: "Téléphone",
            hintText: "06 12 34 56 78",
            prefixIcon: Icon(Icons.phone),
          ),
          validator: (value) => FormValidator.phoneValidator(value, isRequired: true),
        ),
        const SizedBox(height: 24),
        // Additional info fields could be added here
      ],
    );
  }
}
