import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/error_view.dart';
import '../../groups/data/group_providers.dart';
import '../../groups/data/models/group_dto.dart';
import '../../groups/data/models/member_dto.dart';
import '../data/models/bill_dto.dart';
import 'bill_view_model.dart';
import 'roulette_wheel_painter.dart';

class RouletteScreen extends ConsumerStatefulWidget {
  const RouletteScreen({super.key, required this.billId});

  final String billId;

  @override
  ConsumerState<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends ConsumerState<RouletteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
  );
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  Animation<double>? _activeSpin;
  double _rotation = 0;
  int? _pendingWinnerIndex;
  bool _playedExistingWinnerConfetti = false;

  @override
  void initState() {
    super.initState();
    _spin.addListener(_onSpinTick);
  }

  void _onSpinTick() {
    final a = _activeSpin;
    if (a != null) setState(() => _rotation = a.value);
  }

  @override
  void dispose() {
    _spin.removeListener(_onSpinTick);
    _spin.dispose();
    _confetti.dispose();
    super.dispose();
  }

  void _playConfetti() {
    _confetti.stop();
    _confetti.play();
  }

  MemberDto? _memberById(GroupDto group, String? id) {
    if (id == null) return null;
    for (final m in group.members) {
      if (m.userId == id) return m;
    }
    return null;
  }

  int _indexOfUserId(List<MemberDto> members, String userId) {
    for (var i = 0; i < members.length; i++) {
      if (members[i].userId == userId) return i;
    }
    return 0;
  }

  double _wheelRotation(BillDto bill, List<MemberDto> members) {
    if (_spin.isAnimating || _pendingWinnerIndex != null) {
      return _rotation;
    }
    final sid = bill.spunWinnerId;
    if (sid != null && members.length >= 2) {
      return rotationAligningWinner(_indexOfUserId(members, sid), members.length);
    }
    return _rotation;
  }

  Future<void> _onSpin(List<MemberDto> members) async {
    if (members.length < 2 || _spin.isAnimating) return;
    final w = math.Random().nextInt(members.length);
    _pendingWinnerIndex = w;
    final end = computeSpinEndRotation(
      current: _rotation,
      winnerIndex: w,
      sectorCount: members.length,
    );
    _activeSpin = Tween<double>(begin: _rotation, end: end).animate(
      CurvedAnimation(parent: _spin, curve: Curves.easeOutCubic),
    );
    await _spin.forward(from: 0);
    _activeSpin = null;
    _rotation = end;

    if (!mounted) return;
    final winner = members[w];
    try {
      await ref.read(billViewModelProvider(widget.billId).notifier).setRouletteWinner(
            winner.userId,
          );
      if (!mounted) return;
      setState(() {
        _rotation = rotationAligningWinner(w, members.length);
      });
      _playConfetti();
      Snackbars.showSuccess(context, context.l10n.roulettePaysMessage(winner.name));
    } catch (e) {
      if (!mounted) return;
      Snackbars.showError(context, e);
    } finally {
      _pendingWinnerIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final billState = ref.watch(billViewModelProvider(widget.billId));
    final l10n = context.l10n;

    ref.listen(billViewModelProvider(widget.billId), (prev, next) {
      final err = next.error;
      if (err != null) Snackbars.showError(context, err);
    });

    return billState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.rouletteTitle)),
        body: ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(billViewModelProvider(widget.billId)),
        ),
      ),
      data: (BillDto bill) {
        final groupAsync = ref.watch(groupDetailProvider(bill.groupId));
        return groupAsync.when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            appBar: AppBar(title: Text(l10n.rouletteTitle)),
            body: ErrorView(
              message: e.toString(),
              onRetry: () => ref.invalidate(groupDetailProvider(bill.groupId)),
            ),
          ),
          data: (GroupDto group) {
            final members = List<MemberDto>.from(group.members);
            final scheme = Theme.of(context).colorScheme;
            final existing = bill.spunWinnerId;
            final existingMember = _memberById(group, existing);

            if (existing != null && existingMember != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted || _playedExistingWinnerConfetti) return;
                _playedExistingWinnerConfetti = true;
                _playConfetti();
              });
            }

            final wheelAngle = _wheelRotation(bill, members);

            return Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    title: Text(l10n.whoPaysTitle),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.billResultPath(widget.billId));
                        }
                      },
                    ),
                  ),
                  body: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      SizedBox(
                        height: 280,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Center(
                              child: Transform.rotate(
                                angle: wheelAngle,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CustomPaint(
                                    painter: RouletteWheelPainter(
                                      members: members,
                                      colorScheme: scheme,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 0,
                              child: Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (existingMember != null) ...[
                        Text(
                          l10n.winnerLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Text(
                              existingMember.name.isNotEmpty
                                  ? existingMember.name[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(
                            existingMember.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      Text(
                        l10n.participantsLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...members.map(
                        (m) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Text(
                              m.name.isNotEmpty ? m.name[0].toUpperCase() : '?',
                            ),
                          ),
                          title: Text(m.name),
                        ),
                      ),
                      if (members.length < 2)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: Text(
                            l10n.rouletteMinMembersMessage,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: scheme.error,
                                ),
                          ),
                        ),
                      if (existing == null && members.length >= 2) ...[
                        const SizedBox(height: AppSpacing.lg),
                        AppButton(
                          label: _spin.isAnimating
                              ? l10n.spinningButton
                              : l10n.spinButton,
                          onPressed: _spin.isAnimating || _pendingWinnerIndex != null
                              ? null
                              : () => _onSpin(members),
                        ),
                      ],
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confetti,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.06,
                    numberOfParticles: 18,
                    maxBlastForce: 28,
                    minBlastForce: 12,
                    gravity: 0.35,
                    shouldLoop: false,
                    colors: [
                      scheme.primary,
                      scheme.secondary,
                      scheme.tertiary,
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
