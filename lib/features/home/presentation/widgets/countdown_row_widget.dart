import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/custom_colors.dart';

class CountdownRow extends StatefulWidget {
  const CountdownRow({super.key});

  @override
  State<CountdownRow> createState() => _CountdownRowState();
}

class _CountdownRowState extends State<CountdownRow> {
  late Timer _timer;
  late Duration _timeLeft;
  
  // Bryllupsdato: 28. juni 2025 kl 13:00
  final DateTime _weddingDate = DateTime(2025, 6, 28, 13, 0, 0);

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    _timeLeft = _weddingDate.difference(now);
    if (_timeLeft.isNegative) {
      _timeLeft = const Duration();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _calculateTimeLeft();
      });
    });
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours.remainder(24);
    final minutes = _timeLeft.inMinutes.remainder(60);
    final seconds = _timeLeft.inSeconds.remainder(60);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCountdownUnit(context, '$days', 'DAGER'),
            _buildDivider(),
            _buildCountdownUnit(context, _twoDigits(hours), 'TIMER'),
            _buildDivider(),
            _buildCountdownUnit(context, _twoDigits(minutes), 'MINUTTER'),
            _buildDivider(),
            _buildCountdownUnit(context, _twoDigits(seconds), 'SEKUNDER'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '28. juni 2025 kl. 13:00',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: CustomColors.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildCountdownUnit(BuildContext context, String value, String label) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: CustomColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primary,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: CustomColors.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}