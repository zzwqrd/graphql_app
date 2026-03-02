import 'package:flutter/material.dart';

/// Custom widget for order summary section
class OrderSummarySection extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shippingCharge;
  final double discount;
  final double total;
  final VoidCallback onCheckout;
  final String? warningMessage;

  const OrderSummarySection({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shippingCharge,
    required this.discount,
    required this.total,
    required this.onCheckout,
    this.warningMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الطلب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F39),
            ),
          ),
          const SizedBox(height: 20),

          // Subtotal
          _buildSummaryRow(
            'المجموع الفرعي',
            '\$${subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),

          // Tax
          _buildSummaryRow('الضريبة', '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 12),

          // Shipping
          _buildSummaryRow(
            'رسوم التوصيل',
            '\$${shippingCharge.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 12),

          // Discount
          if (discount > 0) ...[
            _buildSummaryRow(
              'الخصم',
              '-\$${discount.toStringAsFixed(2)}',
              valueColor: const Color(0xFF01BE5F),
            ),
            const SizedBox(height: 12),
          ],

          const Divider(height: 24, color: Color(0xFFEFF0F6)),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F39),
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F39),
                ),
              ),
            ],
          ),

          // Warning message
          if (warningMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFF6A609),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warningMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1F1F39),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: warningMessage != null ? null : onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01BE5F),
                disabledBackgroundColor: const Color(
                  0xFF01BE5F,
                ).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'حفظ والدفع',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6E7191),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1F1F39),
          ),
        ),
      ],
    );
  }
}
