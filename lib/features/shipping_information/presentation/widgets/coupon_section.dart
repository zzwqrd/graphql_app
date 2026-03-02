import 'package:flutter/material.dart';

/// Custom widget for coupon/promo section
class CouponSection extends StatelessWidget {
  final bool isApplied;
  final String? couponCode;
  final double? savedAmount;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const CouponSection({
    super.key,
    required this.isApplied,
    this.couponCode,
    this.savedAmount,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isApplied
                ? const Color(0xFF01BE5F)
                : const Color(0xFF006CC0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Coupon icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isApplied
                    ? const Color(0xFFD3FFE5)
                    : const Color(0xFFEAF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_offer_outlined,
                color: isApplied
                    ? const Color(0xFF01BE5F)
                    : const Color(0xFF007FE3),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isApplied
                        ? 'تم تطبيق الكوبون'
                        : 'قدم العرض الترويجي أو الكوبون أو القسيمة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isApplied
                          ? const Color(0xFF01BE5F)
                          : const Color(0xFF006CC0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isApplied
                        ? 'لقد وفرت ${savedAmount?.toStringAsFixed(2) ?? '0.00'} ر.س'
                        : 'احصل على خصم مع طلبك',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6E7191),
                    ),
                  ),
                ],
              ),
            ),

            // Action icon
            if (isApplied && onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF6E7191),
                  size: 20,
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF6E7191),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
