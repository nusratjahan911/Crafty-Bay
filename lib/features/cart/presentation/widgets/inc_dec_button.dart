import 'package:crafty_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class IncDecButton extends StatefulWidget {
  const IncDecButton({super.key, required this.onChange,  this.maxvalue = 100, required this.quantity});

  final Function(int) onChange;
  final int maxvalue ;
  final int quantity;

  @override
  State<IncDecButton> createState() => _IncDecButtonState();
}

class _IncDecButtonState extends State<IncDecButton> {
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGestureDetector(
          onTap: () {
            if (currentValue > 1) {
              currentValue--;
              widget.onChange(currentValue);
              setState(() {});
            }
          },
          icon: Icons.remove,
        ),

        Text('${currentValue}', style: TextTheme.of(context).titleMedium),
        _buildGestureDetector(
          onTap: () {
            if (widget.maxvalue > currentValue) {
              currentValue++;
              widget.onChange(currentValue);
              setState(() {});
            }
          },
          icon: Icons.add,
        ),
      ],
    );
  }

  Widget _buildGestureDetector({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColours.themeColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
