import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/providers/app_config_provider.dart';
import 'package:frontend/core/widgets/custom_text_field.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/social_outline_button.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _termsAccepted = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister(AppConfigProvider config) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            config.tr('Please accept the Terms & Conditions', 'விதிமுறைகளை ஒப்புக்கொள்ளவும்'),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    context.go('/home');
  }

  void _showTermsDialog(BuildContext context, AppConfigProvider config) {
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
              Text(
                config.tr('Terms & Conditions', 'விதிமுறைகள் & நிபந்தனைகள்'),
                style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w600, color: config.primaryTextColor),
              ),
              const SizedBox(height: 12),
              Text(
                config.tr(
                  'By registering for Kanavu Illam, you agree to our platform terms, estimation algorithms, and data privacy policies. Structural designs are calculated as per standard IS codes.',
                  'கனவு இல்லத்தில் பதிவு செய்வதன் மூலம், எங்கள் தளத்தின் விதிமுறைகள், மதிப்பீட்டு முறைகள் மற்றும் தனியுரிமைக் கொள்கைகளை ஒப்புக்கொள்கிறீர்கள்.',
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
                  onPressed: () {
                    setState(() => _termsAccepted = true);
                    Navigator.pop(ctx);
                  },
                  child: Text(config.tr('I Agree', 'நான் ஒப்புக்கொள்கிறேன்'), style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>();
    final isDark = config.isDarkMode;
    final bgColor = config.bgColor;
    final cardColor = config.cardColor;
    final primaryTextColor = config.primaryTextColor;
    final secondaryTextColor = config.secondaryTextColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 48,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BRAND HEADER
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(56, 56),
                                painter: _SmallLogoPainter(color: primaryTextColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'KI',
                                  style: GoogleFonts.syne(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Kanavu Illam',
                          style: GoogleFonts.syne(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: primaryTextColor,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // MAIN ELEVATED WHITE CARD
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    padding: const EdgeInsets.all(22.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: config.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            config.tr('Create account', 'கணக்கை உருவாக்கவும்'),
                            style: GoogleFonts.syne(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                              letterSpacing: -0.22,
                              height: 1.1,
                            ),
                          ),
                        ),
                        
                        // Inputs
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Full Name
                              CustomTextField(
                                controller: _nameController,
                                hintText: config.tr('Full Name', 'முழுப் பெயர்'),
                                prefixIcon: Icons.badge_outlined,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return config.tr('Please enter your full name', 'முழுப் பெயரை உள்ளிடவும்');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              
                              // Email Address
                              CustomTextField(
                                controller: _emailController,
                                hintText: config.tr('Email address', 'மின்னஞ்சல் முகவரி'),
                                prefixIcon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return config.tr('Please enter email address', 'மின்னஞ்சல் முகவரியை உள்ளிடவும்');
                                  }
                                  if (!val.contains('@')) {
                                    return config.tr('Please enter a valid email address', 'சரியான மின்னஞ்சலை உள்ளிடவும்');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              
                              // Password
                              CustomTextField(
                                controller: _passwordController,
                                hintText: config.tr('Password', 'கடவுச்சொல்'),
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onToggleVisibility: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return config.tr('Please enter password', 'கடவுச்சொல்லை உள்ளிடவும்');
                                  }
                                  if (val.length < 6) {
                                    return config.tr('Password must be at least 6 characters', 'குறைந்தது 6 எழுத்துக்கள் இருக்க வேண்டும்');
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Terms Checkbox
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _termsAccepted = !_termsAccepted;
                                  });
                                },
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: _termsAccepted ? (isDark ? Colors.white : AppColors.primary) : Colors.transparent,
                                    border: Border.all(color: _termsAccepted ? (isDark ? Colors.white : AppColors.primary) : config.borderColor, width: 1.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: _termsAccepted
                                      ? Icon(Icons.check, size: 15, color: isDark ? Colors.black : Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => _showTermsDialog(context, config),
                                child: Text(
                                  config.tr('I agree to Terms & Conditions', 'விதிமுறைகளை ஒப்புக்கொள்கிறேன்'),
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: secondaryTextColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Register Primary Button
                        PrimaryButton(
                          text: config.tr('Register', 'பதிவு செய்'),
                          onTap: () => _handleRegister(config),
                        ),
                        
                        // Divider
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Divider(color: config.borderColor, thickness: 1, height: 1),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                color: cardColor,
                                child: Text(
                                  config.tr('or', 'அல்லது'),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Continue with Google Button
                        SocialOutlineButton(
                          text: config.tr('Continue with Google', 'Google மூலம் தொடரவும்'),
                          icon: Icons.g_mobiledata,
                          onTap: () {
                            context.go('/home');
                          },
                        ),
                      ],
                    ),
                  ),

                  // FOOTER
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          config.tr('Already have an account? ', 'ஏற்கனவே கணக்கு உள்ளதா? '),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.push('/login');
                          },
                          child: Text(
                            config.tr('Sign in', 'உள்நுழைக'),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
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

// Logo Painter
class _SmallLogoPainter extends CustomPainter {
  final Color color;
  _SmallLogoPainter({this.color = AppColors.primary});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(3, 10.5);
    path.lineTo(12, 3);
    path.lineTo(21, 10.5);
    path.lineTo(21, 21);
    path.lineTo(3, 21);
    path.close();

    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SmallLogoPainter oldDelegate) => oldDelegate.color != color;
}
