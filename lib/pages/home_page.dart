import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'exercise_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  String _playerName = '';
  bool _showOptions = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startTraining() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite seu nome para comecar.')),
      );
      return;
    }

    setState(() {
      _playerName = name;
      _showOptions = true;
    });
  }

  void _openInitialStage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LevelPhasesPage(
          playerName: _playerName,
          levelTitle: 'Inicial',
          durationLabel: '4 tempos',
          accentColor: const Color(0xFF005F73),
          phaseDescriptions: const [
            'Notas de Do a Sol (4 tempos)',
            'Notas de Do a Do (4 tempos)',
            'Do a Sol da segunda oitava (4 tempos)',
            'Do da primeira oitava ate Sol da segunda oitava (4 tempos)',
          ],
          stageStartIndex: 0,
        ),
      ),
    );
  }

  void _openIntermediateStages() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LevelPhasesPage(
          playerName: _playerName,
          levelTitle: 'Intermediario',
          durationLabel: '2 tempos',
          accentColor: const Color(0xFF0A9396),
          phaseDescriptions: const [
            'Notas de Do a Sol (2 tempos)',
            'Notas de Do a Do (2 tempos)',
            'Do a Sol da segunda oitava (2 tempos)',
            'Do da primeira oitava ate Sol da segunda oitava (2 tempos)',
          ],
          stageStartIndex: 4,
        ),
      ),
    );
  }

  void _openAdvancedStages() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LevelPhasesPage(
          playerName: _playerName,
          levelTitle: 'Avancado',
          durationLabel: '1 tempo',
          accentColor: const Color(0xFF9B2226),
          phaseDescriptions: const [
            'Notas de Do a Sol (1 tempo)',
            'Notas de Do a Do (1 tempo)',
            'Do a Sol da segunda oitava (1 tempo)',
            'Do da primeira oitava ate Sol da segunda oitava (1 tempo)',
          ],
          stageStartIndex: 8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/home_background.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Treino de Teoria Musical',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0D1B2A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Informe seu nome e comece pelo nivel Inicial',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1B263B),
                            ),
                          ),
                          const SizedBox(height: 22),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Seu nome',
                              hintText: 'Digite aqui',
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.86),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (!_showOptions)
                            _InfoCard(
                              title: 'Ordem das fases',
                              subtitle:
                                  'Inicial (4 tempos) -> Intermediario (2 tempos) -> Avancado (1 tempo)',
                            ),
                          const SizedBox(height: 12),
                          if (!_showOptions)
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: _startTraining,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF005F73),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Comecar treino',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          if (_showOptions) ...[
                            _InfoCard(
                              title: 'Aluno: $_playerName',
                              subtitle:
                                  'Escolha qualquer nivel para testar as fases.',
                            ),
                            const SizedBox(height: 12),
                            _LevelCard(
                              title: 'Inicial',
                              subtitle: '4 tempos',
                              accentColor: const Color(0xFF005F73),
                              onTap: _openInitialStage,
                            ),
                            const SizedBox(height: 12),
                            _LevelCard(
                              title: 'Intermediario',
                              subtitle: '2 tempos',
                              accentColor: const Color(0xFF0A9396),
                              onTap: _openIntermediateStages,
                            ),
                            const SizedBox(height: 12),
                            _LevelCard(
                              title: 'Avancado',
                              subtitle: '1 tempo',
                              accentColor: const Color(0xFF9B2226),
                              onTap: _openAdvancedStages,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Objetivo: identificar a nota no pentagrama e reforcar ritmo',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF33415C)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _LevelCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: accentColor.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelPhasesPage extends StatelessWidget {
  final String playerName;
  final String levelTitle;
  final String durationLabel;
  final Color accentColor;
  final List<String> phaseDescriptions;
  final int stageStartIndex;

  const _LevelPhasesPage({
    required this.playerName,
    required this.levelTitle,
    required this.durationLabel,
    required this.accentColor,
    required this.phaseDescriptions,
    required this.stageStartIndex,
  });

  void _openPhase(BuildContext context, int stageIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExercisePage(
          playerName: playerName,
          stageIndex: stageIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/home_background.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          '$levelTitle - Escolha a fase',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0D1B2A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aluno: $playerName | $durationLabel',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF1B263B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _LevelCard(
                    title: 'Fase 1',
                    subtitle: phaseDescriptions[0],
                    accentColor: accentColor,
                    onTap: () => _openPhase(context, stageStartIndex),
                  ),
                  const SizedBox(height: 12),
                  _LevelCard(
                    title: 'Fase 2',
                    subtitle: phaseDescriptions[1],
                    accentColor: accentColor,
                    onTap: () => _openPhase(context, stageStartIndex + 1),
                  ),
                  const SizedBox(height: 12),
                  _LevelCard(
                    title: 'Fase 3',
                    subtitle: phaseDescriptions[2],
                    accentColor: accentColor,
                    onTap: () => _openPhase(context, stageStartIndex + 2),
                  ),
                  const SizedBox(height: 12),
                  _LevelCard(
                    title: 'Fase 4',
                    subtitle: phaseDescriptions[3],
                    accentColor: accentColor,
                    onTap: () => _openPhase(context, stageStartIndex + 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
