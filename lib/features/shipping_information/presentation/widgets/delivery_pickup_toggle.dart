import 'package:flutter/material.dart';

/// Custom widget for delivery/pickup toggle switch
class DeliveryPickupToggle extends StatelessWidget {
  final bool isDelivery;
  final ValueChanged<bool> onToggle;

  const DeliveryPickupToggle({
    super.key,
    required this.isDelivery,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDelivery
                      ? const Color(0xFF007FE3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'التوصيل',
                    style: TextStyle(
                      color: isDelivery
                          ? Colors.white
                          : const Color(0xFF007FE3),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: !isDelivery
                      ? const Color(0xFF007FE3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'الاستلام',
                    style: TextStyle(
                      color: !isDelivery
                          ? Colors.white
                          : const Color(0xFF007FE3),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
