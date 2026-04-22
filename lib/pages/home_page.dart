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
        builder: (_) => ExercisePage(
          playerName: _playerName,
          stageIndex: 0,
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
                                  'Escolha Inicial para comecar. Os demais niveis liberam conforme seu desempenho.',
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
                              subtitle: '2 tempos (bloqueado)',
                              accentColor: const Color(0xFF0A9396),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Comece pelo Inicial e alcance 85% para avancar automaticamente.',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _LevelCard(
                              title: 'Avancado',
                              subtitle: '1 tempo (bloqueado)',
                              accentColor: const Color(0xFF9B2226),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Conclua as fases anteriores com 85% para chegar ao Avancado.',
                                    ),
                                  ),
                                );
                              },
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
