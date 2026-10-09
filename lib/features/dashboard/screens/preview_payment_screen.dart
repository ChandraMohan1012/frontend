import 'package:go_router/go_router.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PreviewPaymentScreen extends StatefulWidget {
  final Map<String, String>? fileData;
  const PreviewPaymentScreen({super.key, this.fileData});

  @override
  State<PreviewPaymentScreen> createState() => _PreviewPaymentScreenState();
}

class _PreviewPaymentScreenState extends State<PreviewPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (context.mounted) {
      context.replace('/processing', extra: widget.fileData);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: ${response.message}')),
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('External Wallet Selected: ${response.walletName}')),
      );
    }
  }

  void _startPayment() {
    // Razorpay flutter package doesn't fully support Web out of the box.
    // If we are on web, simulate a successful payment to continue the flow.
    if (kIsWeb) {
      if (context.mounted) {
        context.replace('/processing', extra: widget.fileData);
      }
      return;
    }

    var options = {
      'key': 'rzp_test_dummykey12345',
      'amount': 50000, // in paise
      'name': 'Kanavu Illam',
      'description': 'AI Floor Plan Analysis',
      'prefill': {
        'contact': '9876543210',
        'email': 'test@example.com'
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
      // Fallback in case of MissingPluginException on other unsupported platforms
      if (context.mounted) {
        context.replace('/processing', extra: widget.fileData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read the passed file name from arguments
    final fileName = widget.fileData?['name'] ?? 'house_plan.pdf';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Header
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview & Payment',
                        style: GoogleFonts.syne(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          letterSpacing: -0.22,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Verify details and complete order',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceTertiary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. PLAN CARD
                    Container(
                      height: 98,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida/AEtjO1WmYPORWUmPF2hMljEMbeMPF4IMzM_J9dNu5NpH2SL_6P1OH-1JFI6-NAj9PRtD3q_l7kT-MsRXiD2J8KAA-TU2zX3adjy4a2jWkOZZ7Cc24qKrxZu1OQzTGMLhC0wnG2048wCut8hwq7_Jla9M7qNmKG0bVuKQCjqmu-clm0lYLF3vhniJVBf-QUjFEV61M8zN6PXZK1Of2BU4eJhvTke7Bof3xP0fdIc_XTJB54bN2g',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => const Icon(Icons.image, color: AppColors.border),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        fileName,
                                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      'Change',
                                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary, decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('Ground Floor • 1,600 sq ft', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                      child: const Icon(Icons.check, size: 12, color: Colors.white),
                                    ),
                                    const SizedBox(width: 6),
                                    Text('Quality check passed', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    // 2. SECTION HEADING
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'What you will get',
                        style: GoogleFonts.syne(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.primary),
                      ),
                    ),

                    // 3. REPORT LIST
                    Column(
                      children: [
                        _buildReportItem(Icons.view_in_ar, '3D Model'),
                        const SizedBox(height: 8),
                        _buildReportItem(Icons.explore, 'Vastu Analysis'),
                        const SizedBox(height: 8),
                        _buildReportItem(Icons.calculate, 'Cost Breakdown / BOQ'),
                        const SizedBox(height: 8),
                        _buildReportItem(Icons.domain, 'Structural Check'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 4. BOTTOM PAYMENT PANEL
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -6)),
                ],
              ),
              padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: MediaQuery.of(context).padding.bottom + 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('All 4 reports', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
                      const SizedBox(height: 2),
                      Text('₹500', style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.primary, letterSpacing: -0.24)),
                    ],
                  ),
                  InkWell(
                    onTap: _startPayment,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Pay ₹500', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                          const SizedBox(width: 12),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(IconData icon, String title) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.surfaceTertiary, shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
              ),
            ],
          ),
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
