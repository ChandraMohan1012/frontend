import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/providers/app_config_provider.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/auth/screens/welcome_screen.dart';
import 'package:frontend/features/dashboard/screens/home_screen.dart';
import 'package:frontend/features/dashboard/screens/history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentNavTab = 2; // Profile is active
  bool _isSettingsOpen = false;

  // Editable user information
  String _name = 'Thomas';
  String _phone = '+91 98765 XXXXX';
  String _email = 'thomas@gmail.com';
  String _city = 'Erode, Tamil Nadu';

  // Active inline editing field: null, 'name', 'phone', 'email', 'city'
  String? _editingField;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _name);
    _phoneController = TextEditingController(text: _phone);
    _emailController = TextEditingController(text: _email);
    _cityController = TextEditingController(text: _city);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read global configuration from AppConfigProvider
    final config = context.watch<AppConfigProvider>();
    final isDarkMode = config.isDarkMode;
    final isTamil = config.isTamil;

    final bgColor = config.bgColor;
    final cardColor = config.cardColor;
    final primaryTextColor = config.primaryTextColor;
    final secondaryTextColor = config.secondaryTextColor;
    final surfacePillColor = config.surfacePillColor;
    final borderColor = config.borderColor;
    final splashColor = config.splashColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 92.0),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    // 1. HEADER
                    SizedBox(
                      height: 44,
                      child: Center(
                        child: Text(
                          config.tr('Profile', 'சுயவிவரம்'),
                          style: GoogleFonts.syne(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: primaryTextColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 2. AVATAR BLOCK & INLINE EDITABLE NAME
                    Column(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: borderColor),
                                  color: cardColor,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBQE79hf27BQqM1IUioTymtLWxiJrvh3OKuBJMNqbxYRhThrzWLQeImUCh_o0tcrjBod22h4Tc3T7QB0cgDBZDnt5ycVZpVE8gXHkUsrYBSbID77mGSSSzVPS1G-szF_Tk6VsCvTn04Bi399VkfZigP3uHk6z0DDLSpSDuW3omg7PE4f-wq8ioXi64oFnXjSUcVceOl2OjCjKA2bCbUIvrcBcYJsCQF3sH4vEdKXlN6Mm1uC7SSXh65oQ',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Icon(Icons.person, size: 40, color: secondaryTextColor),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: bgColor, width: 2),
                                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                                  ),
                                  child: Material(
                                    color: isDarkMode ? Colors.white : AppColors.primary,
                                    shape: const CircleBorder(),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () => _showEditAvatarSheet(context, config),
                                      child: Icon(Icons.edit, size: 13, color: isDarkMode ? Colors.black : Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Inline Editable Name
                        if (_editingField == 'name')
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 32,
                                child: TextField(
                                  controller: _nameController,
                                  autofocus: true,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.syne(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: primaryTextColor,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: isDarkMode ? Colors.white70 : AppColors.primary, width: 1.5),
                                    ),
                                  ),
                                  onSubmitted: (val) {
                                    if (val.trim().isNotEmpty) {
                                      setState(() => _name = val.trim());
                                    }
                                    setState(() => _editingField = null);
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  if (_nameController.text.trim().isNotEmpty) {
                                    setState(() => _name = _nameController.text.trim());
                                  }
                                  setState(() => _editingField = null);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? Colors.white : AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check, size: 12, color: isDarkMode ? Colors.black : Colors.white),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  _nameController.text = _name;
                                  setState(() => _editingField = null);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: surfacePillColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close, size: 12, color: secondaryTextColor),
                                ),
                              ),
                            ],
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              _nameController.text = _name;
                              setState(() => _editingField = 'name');
                            },
                            child: Text(
                              _name,
                              style: GoogleFonts.syne(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 3. COMBINED PROFILE ACTIONS CARD (MEGA CONTAINER)
                    Material(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(28),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          // --- INFO SECTION (INLINE EDITABLE) ---
                          Column(
                            children: [
                              _buildInlineInfoRow(
                                fieldKey: 'phone',
                                icon: Icons.call, 
                                label: config.tr('PHONE', 'தொலைபேசி'), 
                                value: _phone,
                                controller: _phoneController,
                                primaryTextColor: primaryTextColor,
                                secondaryTextColor: secondaryTextColor,
                                surfacePillColor: surfacePillColor,
                                splashColor: splashColor,
                                isDarkMode: isDarkMode,
                                onSave: (v) => setState(() => _phone = v),
                              ),
                              Divider(color: borderColor, height: 1, thickness: 1, indent: 16, endIndent: 16),
                              _buildInlineInfoRow(
                                fieldKey: 'email',
                                icon: Icons.mail, 
                                label: config.tr('EMAIL', 'மின்னஞ்சல்'), 
                                value: _email,
                                controller: _emailController,
                                primaryTextColor: primaryTextColor,
                                secondaryTextColor: secondaryTextColor,
                                surfacePillColor: surfacePillColor,
                                splashColor: splashColor,
                                isDarkMode: isDarkMode,
                                onSave: (v) => setState(() => _email = v),
                              ),
                              Divider(color: borderColor, height: 1, thickness: 1, indent: 16, endIndent: 16),
                              _buildInlineInfoRow(
                                fieldKey: 'city',
                                icon: Icons.location_on, 
                                label: config.tr('CITY', 'இருப்பிடம்'), 
                                value: _city,
                                controller: _cityController,
                                primaryTextColor: primaryTextColor,
                                secondaryTextColor: secondaryTextColor,
                                surfacePillColor: surfacePillColor,
                                splashColor: splashColor,
                                isDarkMode: isDarkMode,
                                onSave: (v) => setState(() => _city = v),
                              ),
                            ],
                          ),
                          
                          Divider(color: borderColor, height: 1, thickness: 1),
                          
                          // --- SETTINGS SECTION ---
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: splashColor,
                              onTap: () {
                                setState(() {
                                  _isSettingsOpen = !_isSettingsOpen;
                                });
                              },
                              child: Container(
                                height: 52,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(color: surfacePillColor, shape: BoxShape.circle),
                                          child: Icon(Icons.settings, size: 17, color: primaryTextColor),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          config.tr('Settings', 'அமைப்புகள்'), 
                                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor),
                                        ),
                                      ],
                                    ),
                                    AnimatedRotation(
                                      turns: _isSettingsOpen ? 0.5 : 0.0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(Icons.keyboard_arrow_down, size: 20, color: secondaryTextColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (_isSettingsOpen)
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
                              child: Column(
                                children: [
                                  _buildSettingToggle(
                                    icon: Icons.dark_mode, 
                                    label: config.tr('Theme', 'தோற்றம்'), 
                                    opt1: config.tr('Light', 'ஒளிரும்'), 
                                    opt2: config.tr('Dark', 'இருண்ட'), 
                                    isOpt2Selected: isDarkMode, 
                                    onToggle: () => config.toggleTheme(),
                                    primaryTextColor: primaryTextColor,
                                    surfacePillColor: surfacePillColor,
                                    secondaryTextColor: secondaryTextColor,
                                    isDarkMode: isDarkMode,
                                  ),
                                  const SizedBox(height: 14),
                                  _buildSettingToggle(
                                    icon: Icons.language, 
                                    label: config.tr('Language', 'மொழி'), 
                                    opt1: 'English', 
                                    opt2: 'தமிழ்', 
                                    isOpt2Selected: isTamil, 
                                    onToggle: () => config.toggleLanguage(),
                                    primaryTextColor: primaryTextColor,
                                    surfacePillColor: surfacePillColor,
                                    secondaryTextColor: secondaryTextColor,
                                    isDarkMode: isDarkMode,
                                  ),
                                ],
                              ),
                            ),
                            
                          Divider(color: borderColor, height: 1, thickness: 1),
                          
                          // --- HELP AND LEGAL SECTION ---
                          SizedBox(
                            height: 68,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildHelpAction(
                                    icon: Icons.help_center, 
                                    label: config.tr('Help & Support', 'உதவி மையம்'),
                                    primaryTextColor: primaryTextColor,
                                    surfacePillColor: surfacePillColor,
                                    splashColor: splashColor,
                                    onTap: () => _showHelpSupportSheet(context, config),
                                  ),
                                ),
                                Container(width: 1, color: borderColor),
                                Expanded(
                                  child: _buildHelpAction(
                                    icon: Icons.shield, 
                                    label: config.tr('Terms & Privacy', 'விதிமுறைகள்'),
                                    primaryTextColor: primaryTextColor,
                                    surfacePillColor: surfacePillColor,
                                    splashColor: splashColor,
                                    onTap: () => _showTermsPrivacySheet(context, config),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),
                    
                    // 7. ACTIONS ROW & FOOTER
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(100),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                splashColor: splashColor,
                                onTap: () => _showLogoutDialog(context, config),
                                child: Container(
                                  height: 52,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: borderColor),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout, size: 19, color: primaryTextColor),
                                      const SizedBox(width: 8),
                                      Text(
                                        config.tr('Log out', 'வெளியேறு'), 
                                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: primaryTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                splashColor: const Color(0xFFB3261E).withValues(alpha: 0.1),
                                onTap: () => _showDeleteAccountDialog(context, config),
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    config.tr('Delete account', 'கணக்கை நீக்கு'), 
                                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFB3261E)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          config.tr('Version 1.0.0', 'பதிப்பு 1.0.0'), 
                          style: GoogleFonts.inter(fontSize: 12, color: secondaryTextColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 8. FLOATING BOTTOM NAV
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 280,
        height: 64,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.35 : 0.08), 
              blurRadius: 32, 
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavTab(0, Icons.home_outlined, config.tr('Home', 'முகப்பு'), primaryTextColor, secondaryTextColor, surfacePillColor),
            _buildNavTab(1, Icons.history, config.tr('History', 'வரலாறு'), primaryTextColor, secondaryTextColor, surfacePillColor),
            _buildNavTab(2, Icons.person, config.tr('Profile', 'சுயவிவரம்'), primaryTextColor, secondaryTextColor, surfacePillColor),
          ],
        ),
      ),
    );
  }

  // --- INLINE EDITABLE INFO ROW (CLEAN, NO CHEVRONS, NO BOTTOM SHEET) ---
  Widget _buildInlineInfoRow({
    required String fieldKey,
    required IconData icon, 
    required String label, 
    required String value,
    required TextEditingController controller,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color surfacePillColor,
    required Color splashColor,
    required bool isDarkMode,
    required Function(String) onSave,
  }) {
    final bool isEditing = _editingField == fieldKey;

    if (isEditing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isDarkMode ? const Color(0xFF242A34) : const Color(0xFFF7F8FA),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: surfacePillColor, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: primaryTextColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label, 
                    style: GoogleFonts.inter(
                      fontSize: 10, 
                      fontWeight: FontWeight.w600, 
                      color: secondaryTextColor, 
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    style: GoogleFonts.inter(
                      fontSize: 14, 
                      fontWeight: FontWeight.w600, 
                      color: primaryTextColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDarkMode ? Colors.white70 : AppColors.primary, width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: isDarkMode ? Colors.white : AppColors.primary, width: 2),
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        onSave(val.trim());
                      }
                      setState(() => _editingField = null);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Inline Save button (✓)
            GestureDetector(
              onTap: () {
                if (controller.text.trim().isNotEmpty) {
                  onSave(controller.text.trim());
                }
                setState(() => _editingField = null);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 14, color: isDarkMode ? Colors.black : Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            // Inline Cancel button (✕)
            GestureDetector(
              onTap: () {
                controller.text = value; // Reset
                setState(() => _editingField = null);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: surfacePillColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 14, color: secondaryTextColor),
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: splashColor,
        onTap: () {
          controller.text = value;
          setState(() => _editingField = fieldKey);
        },
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: surfacePillColor, shape: BoxShape.circle),
                child: Icon(icon, size: 17, color: primaryTextColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: secondaryTextColor, letterSpacing: 0.5)),
                  Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: primaryTextColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingToggle({
    required IconData icon, 
    required String label, 
    required String opt1, 
    required String opt2, 
    required bool isOpt2Selected, 
    required VoidCallback onToggle,
    required Color primaryTextColor,
    required Color surfacePillColor,
    required Color secondaryTextColor,
    required bool isDarkMode,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: surfacePillColor, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: primaryTextColor),
            ),
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: primaryTextColor)),
          ],
        ),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: surfacePillColor, borderRadius: BorderRadius.circular(100)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isOpt2Selected) onToggle();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: !isOpt2Selected ? primaryTextColor : Colors.transparent, 
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      opt1, 
                      style: GoogleFonts.inter(
                        fontSize: 12, 
                        fontWeight: !isOpt2Selected ? FontWeight.w600 : FontWeight.w500, 
                        color: !isOpt2Selected 
                            ? (isDarkMode ? Colors.black : Colors.white) 
                            : secondaryTextColor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!isOpt2Selected) onToggle();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpt2Selected ? primaryTextColor : Colors.transparent, 
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      opt2, 
                      style: GoogleFonts.inter(
                        fontSize: 12, 
                        fontWeight: isOpt2Selected ? FontWeight.w600 : FontWeight.w500, 
                        color: isOpt2Selected 
                            ? (isDarkMode ? Colors.black : Colors.white) 
                            : secondaryTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpAction({
    required IconData icon, 
    required String label,
    required Color primaryTextColor,
    required Color surfacePillColor,
    required Color splashColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: splashColor,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: surfacePillColor, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: primaryTextColor),
            ),
            const SizedBox(height: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: primaryTextColor, letterSpacing: -0.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab(
    int index, 
    IconData icon, 
    String label, 
    Color primaryTextColor, 
    Color secondaryTextColor,
    Color surfacePillColor,
  ) {
    bool isActive = _currentNavTab == index;
    return GestureDetector(
      onTap: () {
        if (_currentNavTab == index) return;
        Widget page;
        if (index == 0) {
          page = const HomeScreen();
        } else if (index == 1) {
          page = const HistoryScreen();
        } else {
          page = const ProfileScreen();
        }
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, _, _) => page,
            transitionDuration: Duration.zero,
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isActive
            ? BoxDecoration(
                color: surfacePillColor,
                borderRadius: BorderRadius.circular(100),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? primaryTextColor : secondaryTextColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? primaryTextColor : secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DIALOGS & ACTION SHEETS ---

  void _showEditAvatarSheet(BuildContext context, AppConfigProvider config) {
    showModalBottomSheet(
      context: context,
      backgroundColor: config.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera_outlined, color: config.primaryTextColor),
                title: Text(config.tr('Take photo', 'புகைப்படம் எடு'), style: GoogleFonts.inter(color: config.primaryTextColor)),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: config.primaryTextColor),
                title: Text(config.tr('Choose from gallery', 'கேலரியில் தேர்ந்தெடுக்கவும்'), style: GoogleFonts.inter(color: config.primaryTextColor)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpSupportSheet(BuildContext context, AppConfigProvider config) {
    showModalBottomSheet(
      context: context,
      backgroundColor: config.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(config.tr('Help & Support', 'உதவி மையம்'), style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w600, color: config.primaryTextColor)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.phone, color: Color(0xFF2E7D32))),
                title: Text('+91 98765 43210', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: config.primaryTextColor)),
                subtitle: Text('Mon - Sat (9 AM - 6 PM)', style: GoogleFonts.inter(fontSize: 12, color: config.secondaryTextColor)),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(backgroundColor: Color(0xFFE3F2FD), child: Icon(Icons.email, color: Color(0xFF1565C0))),
                title: Text('support@kanavuillam.in', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: config.primaryTextColor)),
                subtitle: Text('24/7 Email assistance', style: GoogleFonts.inter(fontSize: 12, color: config.secondaryTextColor)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTermsPrivacySheet(BuildContext context, AppConfigProvider config) {
    showModalBottomSheet(
      context: context,
      backgroundColor: config.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(config.tr('Terms & Privacy Policy', 'விதிமுறைகள் & தனியுரிமை'), style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w600, color: config.primaryTextColor)),
              const SizedBox(height: 12),
              Text(
                config.tr(
                  'By using Kanavu Illam, you agree to our structural design verification and estimation terms. All estimates are powered by standard IS codes.',
                  'கனவு இல்லத்தைப் பயன்படுத்துவதன் மூலம், எங்களின் கட்டமைப்பு வடிவமைப்பு சரிபார்ப்பு மற்றும் மதிப்பீட்டு விதிமுறைகளை ஏற்றுக்கொள்கிறீர்கள். அனைத்து மதிப்பீடுகளும் இந்தியத் தரநிலைகள் (IS Codes) அடிப்படையிலானவை.',
                ),
                style: GoogleFonts.inter(fontSize: 13, height: 1.5, color: config.secondaryTextColor),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.isDarkMode ? Colors.white : AppColors.primary,
                    foregroundColor: config.isDarkMode ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(config.tr('Close', 'மூடு'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppConfigProvider config) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: config.cardColor,
        title: Text(config.tr('Log out?', 'வெளியேறவா?'), style: GoogleFonts.syne(fontWeight: FontWeight.w600, color: config.primaryTextColor)),
        content: Text(
          config.tr('Are you sure you want to log out of Kanavu Illam?', 'உங்கள் கணக்கிலிருந்து வெளியேற விரும்புகிறீர்களா?'), 
          style: GoogleFonts.inter(color: config.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(config.tr('Cancel', 'ரத்து'), style: GoogleFonts.inter(color: config.isDarkMode ? Colors.white70 : Colors.black87)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: Text(config.tr('Log out', 'வெளியேறு'), style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFFB3261E))),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AppConfigProvider config) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: config.cardColor,
        title: Text(config.tr('Delete Account?', 'கணக்கை நீக்கவா?'), style: GoogleFonts.syne(fontWeight: FontWeight.w600, color: const Color(0xFFB3261E))),
        content: Text(
          config.tr(
            'This action is permanent and cannot be undone. All project estimates and saved plans will be lost.',
            'இந்த நடவடிக்கை நிரந்தரமானது. உங்கள் அனைத்து திட்ட மதிப்பீடுகளும் நீக்கப்படும்.',
          ), 
          style: GoogleFonts.inter(color: config.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(config.tr('Cancel', 'ரத்து'), style: GoogleFonts.inter(color: config.isDarkMode ? Colors.white70 : Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB3261E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: Text(config.tr('Delete Permanently', 'நிரந்தரமாக நீக்கு'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
