import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class EditChildProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialAge;
  final String? initialGrade;
  final bool initialNeurodivergent;
  final Function(String name, String age, String grade, bool neurodivergent)? onSave;

  const EditChildProfileScreen({
    super.key,
    this.initialName = 'Test',
    this.initialAge = '14',
    this.initialGrade = 'Grade 4',
    this.initialNeurodivergent = false,
    this.onSave,
  });

  @override
  State<EditChildProfileScreen> createState() => _EditChildProfileScreenState();
}

class _EditChildProfileScreenState extends State<EditChildProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late String _selectedGrade;
  late bool _isNeurodivergent;

  final List<String> _gradeOptions = const [
    'Pre-K',
    'Kindergarten',
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _ageController = TextEditingController(text: widget.initialAge);
    _selectedGrade = _gradeOptions.contains(widget.initialGrade)
        ? widget.initialGrade!
        : 'Grade 4';
    _isNeurodivergent = widget.initialNeurodivergent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();

    if (name.isEmpty || age.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (widget.onSave != null) {
      widget.onSave!(name, age, _selectedGrade, _isNeurodivergent);
    }

    Navigator.pop(context, {
      'name': name,
      'age': age,
      'grade': _selectedGrade,
      'neurodivergent': _isNeurodivergent,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBackground(
        backgroundImage: 'assets/images/src_assets_background_home_main.png',
        child: SafeArea(
          child: Stack(
            children: [
              // Top Left Back Button
              Positioned(
                top: 14,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Form Content
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title Header
                        Text(
                          "Edit child's profile",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Child's Nickname Field
                        _buildInputField(
                          label: "Child's Nickname",
                          controller: _nameController,
                        ),
                        const SizedBox(height: 14),

                        // Age Field
                        _buildInputField(
                          label: "Age",
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 14),

                        // Grade Dropdown Field
                        _buildGradeDropdown(),
                        const SizedBox(height: 12),

                        // Neurodivergent Toggle
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.85,
                              child: Switch(
                                value: _isNeurodivergent,
                                activeColor: const Color(0xFF3B82F6),
                                inactiveThumbColor: const Color(0xFFCBD5E1),
                                inactiveTrackColor: const Color(0xFFE2E8F0),
                                onChanged: (val) {
                                  setState(() {
                                    _isNeurodivergent = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Neurodivergent',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Update Button
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _handleUpdate,
                            child: Text(
                              'Update',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF94A3B8),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGrade,
          isDense: true,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF0F172A),
            size: 26,
          ),
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
          items: _gradeOptions.map((grade) {
            return DropdownMenuItem<String>(
              value: grade,
              child: Text(grade),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedGrade = val;
              });
            }
          },
        ),
      ),
    );
  }
}
