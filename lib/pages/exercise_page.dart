import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/notes_data.dart';
import '../models/music_note.dart';
import '../services/audio_service.dart';
import '../services/result_log_service.dart';
import '../widgets/staff_widget.dart';

class ExercisePage extends StatefulWidget {
  final String playerName;
  final int stageIndex;

  const ExercisePage({
    super.key,
    required this.playerName,
    required this.stageIndex,
  });

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  static const int _totalQuestions = 20;
  static const double _goodPercent = 75;
  static const double _excellentPercent = 85;

  static const List<_StageConfig> _stages = [
    _StageConfig(level: 'easy', duration: 4, phase: 1),
    _StageConfig(level: 'easy', duration: 4, phase: 2),
    _StageConfig(level: 'easy', duration: 4, phase: 3),
    _StageConfig(level: 'medium', duration: 2, phase: 1),
    _StageConfig(level: 'medium', duration: 2, phase: 2),
    _StageConfig(level: 'medium', duration: 2, phase: 3),
    _StageConfig(level: 'hard', duration: 1, phase: 1),
    _StageConfig(level: 'hard', duration: 1, phase: 2),
    _StageConfig(level: 'hard', duration: 1, phase: 3),
  ];

  _StageConfig get _stage => _stages[widget.stageIndex];

  int get _selectionSeconds => _stage.duration;

  final Random _random = Random();
  final AudioService _audioService = AudioService();

  late final List<MusicNote> _notes;
  MusicNote? _currentNote;
  Timer? _selectionTimer;

  int _currentQuestion = 1;
  int _score = 0;
  int _counter = 1;
  bool _isAnswered = false;
  String _feedback = '';
  bool _lastAnswerCorrect = false;

  final List<String> _options = const [
    'Dó',
    'Ré',
    'Mi',
    'Fá',
    'Sol',
    'Lá',
    'Si'
  ];

  @override
  void initState() {
    super.initState();
    _notes = NotesData.byPhase(phase: _stage.phase, duration: _stage.duration);
    _generateQuestion();
  }

  void _generateQuestion() {
    final previousNoteName = _currentNote?.displayName;
    var nextNote = _notes[_random.nextInt(_notes.length)];

    // Avoid repeating the same note name in consecutive questions.
    if (_notes.length > 1 && previousNoteName != null) {
      int guard = 0;
      while (nextNote.displayName == previousNoteName && guard < 20) {
        nextNote = _notes[_random.nextInt(_notes.length)];
        guard++;
      }
    }

    setState(() {
      _currentNote = nextNote;
      _isAnswered = false;
      _feedback = '';
      _counter = 1;
    });
    unawaited(_audioService.playCountdown());
    _startSelectionTimer();
  }

  void _startSelectionTimer() {
    _selectionTimer?.cancel();
    _selectionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isAnswered) {
        timer.cancel();
        return;
      }

      if (_counter >= _selectionSeconds) {
        timer.cancel();
        _handleTimeout();
        return;
      }

      setState(() {
        _counter++;
      });
      unawaited(_audioService.playCountdown());
    });
  }

  Future<void> _handleTimeout() async {
    if (_isAnswered || _currentNote == null) {
      return;
    }

    setState(() {
      _isAnswered = true;
      _lastAnswerCorrect = false;
      _feedback =
          'Tempo esgotado! Resposta correta: ${_currentNote!.displayName}';
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    await _moveToNextQuestion();
  }

  Future<void> _checkAnswer(String selected) async {
    if (_isAnswered || _currentNote == null) {
      return;
    }

    _selectionTimer?.cancel();

    setState(() {
      _isAnswered = true;
      _lastAnswerCorrect = selected == _currentNote!.displayName;
      if (_lastAnswerCorrect) {
        _score++;
        _feedback = 'Acertou!';
      } else {
        _feedback = 'Errou! Resposta correta: ${_currentNote!.displayName}';
      }
    });

    if (_lastAnswerCorrect) {
      await _audioService.playNote(_currentNote!.audioKey);
    } else {
      await _audioService.playError();
    }

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    await _moveToNextQuestion();
  }

  Future<void> _moveToNextQuestion() async {
    if (_currentQuestion >= _totalQuestions) {
      _selectionTimer?.cancel();
      await _showResultDialog();
      return;
    }

    setState(() {
      _currentQuestion++;
    });
    _generateQuestion();
  }

  void _restartLevel() {
    _selectionTimer?.cancel();
    setState(() {
      _currentQuestion = 1;
      _score = 0;
      _feedback = '';
      _isAnswered = false;
      _counter = 1;
    });
    _generateQuestion();
  }

  Future<void> _showResultDialog() async {
    final percent = (_score / _totalQuestions * 100);
    final isExcellent = percent >= _excellentPercent;
    final isGood = percent >= _goodPercent && percent < _excellentPercent;
    final isBelowRecommended = percent < _goodPercent;
    final isLastStage = widget.stageIndex >= _stages.length - 1;

    await ResultLogService.appendResult(
      playerName: widget.playerName,
      levelLabel: _stage.levelLabel,
      phase: _stage.phase,
      score: _score,
      total: _totalQuestions,
      percentage: percent,
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final percentLabel = percent.toStringAsFixed(1);
        final statusText = isBelowRecommended
            ? 'Recomendo voce continuar estudando.'
            : (isGood
                ? 'Muito bom! Voce pode tentar novamente ou prosseguir para o proximo exercicio.'
                : 'Parabens! Voce esta indo muito bem, pode prosseguir para o proximo nivel.');

        return AlertDialog(
          title: Text(
              isBelowRecommended ? 'Continue praticando' : 'Resultado da fase'),
          content: Text(
            'Aluno: ${widget.playerName}\n'
            '${_stage.levelLabel} - Fase ${_stage.phase}\n'
            'Acertos: $_score de $_totalQuestions\n'
            'Percentual de acerto: $percentLabel%\n\n'
            '$statusText',
          ),
          actions: [
            if (isGood)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restartLevel();
                },
                child: const Text('Tentar novamente'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();

                if (isBelowRecommended) {
                  _restartLevel();
                  return;
                }

                if (isLastStage) {
                  Navigator.of(context).pop();
                  return;
                }

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ExercisePage(
                      playerName: widget.playerName,
                      stageIndex: widget.stageIndex + 1,
                    ),
                  ),
                );
              },
              child: Text(
                isBelowRecommended
                    ? 'Jogar novamente'
                    : (isLastStage ? 'Finalizar' : 'Proximo exercicio'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _selectionTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final note = _currentNote;
    if (note == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _titleByLevel(_stage.level, _stage.phase),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Aluno: ${widget.playerName}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Exercicio $_currentQuestion de $_totalQuestions',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('Pontuacao: $_score'),
              const SizedBox(height: 4),
              Text(
                'Contador: $_counter/$_selectionSeconds',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF005F73),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                note.rhythmLabel,
                style: const TextStyle(
                  color: Color(0xFF33415C),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDEE2E6)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(height: 250, child: StaffWidget(note: note)),
              ),
              const SizedBox(height: 18),
              const Text(
                'Qual e a nota?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: _options
                    .map(
                      (name) => SizedBox(
                        width: 84,
                        child: ElevatedButton(
                          onPressed:
                              _isAnswered ? null : () => _checkAnswer(name),
                          child: Text(name),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              _FeedbackCard(
                feedback: _feedback,
                isCorrect: _lastAnswerCorrect,
                visible: _feedback.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _titleByLevel(String level, int phase) {
    final phaseLabel = 'Fase $phase';
    switch (level) {
      case 'easy':
        return 'Inicial - $phaseLabel';
      case 'medium':
        return 'Intermediario - $phaseLabel';
      default:
        return 'Avancado - $phaseLabel';
    }
  }
}

class _FeedbackCard extends StatelessWidget {
  final String feedback;
  final bool isCorrect;
  final bool visible;

  const _FeedbackCard({
    required this.feedback,
    required this.isCorrect,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox(height: 52);
    }

    final imagePath =
        isCorrect ? 'assets/images/correct.svg' : 'assets/images/wrong.svg';
    final color = isCorrect ? const Color(0xFF2D6A4F) : const Color(0xFF9B2226);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(
        children: [
          SvgPicture.asset(imagePath, width: 34, height: 34),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feedback,
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageConfig {
  final String level;
  final int duration;
  final int phase;

  const _StageConfig({
    required this.level,
    required this.duration,
    required this.phase,
  });

  String get levelLabel {
    switch (level) {
      case 'easy':
        return 'Inicial';
      case 'medium':
        return 'Intermediario';
      default:
        return 'Avancado';
    }
  }
}
