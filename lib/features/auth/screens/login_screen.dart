import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/providers/app_config_provider.dart';
import 'package:frontend/core/widgets/custom_text_field.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/social_outline_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      context.go('/home');
    }
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
                  // Top Brand Emblem Section
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.5,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
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
                  
                  // Main Elevated Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 24.0),
                    padding: const EdgeInsets.all(24.0),
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
                        // Title
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            config.tr('Welcome back', 'மீண்டும் வருக'),
                            style: GoogleFonts.syne(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                              letterSpacing: -0.24,
                              height: 1.1,
                            ),
                          ),
                        ),
                        
                        // Form Group
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email Input
                              CustomTextField(
                                controller: _emailController,
                                hintText: config.tr('Email or Phone', 'மின்னஞ்சல் அல்லது தொலைபேசி'),
                                prefixIcon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return config.tr('Please enter email or phone', 'மின்னஞ்சல் அல்லது தொலைபேசியை உள்ளிடவும்');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              
                              // Password Input
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
                        
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 18.0),
                            child: Text(
                              config.tr('Forgot Password?', 'கடவுச்சொல் மறந்துவிட்டதா?'),
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                        
                        // Sign In Button
                        PrimaryButton(
                          text: config.tr('Sign in', 'உள்நுழைக'),
                          onTap: _handleSignIn,
                        ),
                        
                        // Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
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

                  // Footer
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          config.tr('New here? ', 'புதியவரா? '),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.push('/create_account');
                          },
                          child: Text(
                            config.tr('Sign up', 'பதிவு செய்க'),
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
      ..strokeWidth = 1.75
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
