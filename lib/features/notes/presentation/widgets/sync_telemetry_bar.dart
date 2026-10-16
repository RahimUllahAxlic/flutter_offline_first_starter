import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/core_providers.dart';
import '../providers/sync_engine_notifier.dart';

class SyncTelemetryBar extends ConsumerWidget {
  const SyncTelemetryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryAsync = ref.watch(outboxTelemetryStreamProvider);
    final syncState = ref.watch(syncEngineProvider);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141923),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF262D3D)),
      ),
      child: Column(
        children: [
          telemetryAsync.when(
            data: (counts) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BadgeMetric(
                  label: 'SYNCED',
                  count: counts.syncedCount,
                  color: const Color(0xFF10B981),
                ),
                _BadgeMetric(
                  label: 'OUTBOX PENDING',
                  count: counts.pendingCount,
                  color: const Color(0xFFF59E0B),
                ),
                _BadgeMetric(
                  label: '409 CONFLICTS',
                  count: counts.conflictCount,
                  color: const Color(0xFFEF4444),
                ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(color: Color(0xFF262D3D), height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Simulate 409 Server Conflict on Next Push',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
              Switch(
                value: syncState.injectConflictOnNextSync,
                activeThumbColor: Colors.redAccent,
                onChanged: (v) => ref
                    .read(syncEngineProvider.notifier)
                    .toggleConflictInjection(v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeMetric extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _BadgeMetric({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 0.5,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
