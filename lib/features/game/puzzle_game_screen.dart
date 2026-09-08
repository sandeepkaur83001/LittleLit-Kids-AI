import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/features/game/widgets/game_background.dart';

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  int _gridSize = 2; // 2 (2x2 = 4 pieces) or 3 (3x3 = 9 pieces)
  late List<int?> _placedSlots;
  late List<int> _availablePieces;

  bool _isEyePeekActive = false;
  int _currentPuzzleIndex = 0;

  final List<Map<String, dynamic>> _puzzles = [
    {
      'title': 'Magic Cat Wizard',
      'image': 'assets/images/coloring_arts.png',
    },
    {
      'title': 'Crafty Chameleon',
      'image': 'assets/images/chameleon.png',
    },
    {
      'title': 'Litto the Dragon',
      'image': 'assets/images/litto.png',
    },
    {
      'title': 'Singing Duck',
      'image': 'assets/images/duck_singer.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startPuzzle();
  }

  void _startPuzzle() {
    setState(() {
      final total = _gridSize * _gridSize;
      _placedSlots = List<int?>.filled(total, null);
      _availablePieces = List<int>.generate(total, (i) => i)..shuffle();
      _isEyePeekActive = false;
    });
  }

  void _toggleDifficulty() {
    setState(() {
      _gridSize = _gridSize == 2 ? 3 : 2;
      _startPuzzle();
    });
  }

  void _onPiecePlaced(int pieceIndex, int targetSlotIndex) {
    if (pieceIndex == targetSlotIndex) {
      setState(() {
        _placedSlots[targetSlotIndex] = pieceIndex;
        _availablePieces.remove(pieceIndex);
      });

      // Check win condition
      if (_placedSlots.every((slot) => slot != null)) {
        _showWinDialog();
      }
    } else {
      // Wrong slot feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Try another slot! 🧩',
            style: GoogleFonts.comicNeue(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(milliseconds: 600),
          backgroundColor: const Color(0xFFEF5350),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/src_assets_images_great_job.png',
                height: 90,
                errorBuilder: (_, __, ___) => const Icon(Icons.star_rounded, size: 80, color: Color(0xFFFFB800)),
              ),
              const SizedBox(height: 12),
              Text(
                'Puzzle Completed!',
                style: GoogleFonts.comicNeue(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'You solved the ${_puzzles[_currentPuzzleIndex]['title']} puzzle perfectly!',
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _startPuzzle();
                    },
                    child: Text('Replay', style: GoogleFonts.comicNeue(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E78C7),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _currentPuzzleIndex = (_currentPuzzleIndex + 1) % _puzzles.length;
                        _startPuzzle();
                      });
                    },
                    child: Text('Next Puzzle', style: GoogleFonts.comicNeue(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPuzzle = _puzzles[_currentPuzzleIndex];

    return GameBackground(
      backgroundImage: 'assets/images/landscape_background_clean.png',
      child: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  children: [
                    // Left Target Preview & Eye Inspection Tool
                    _buildInspectionPanel(currentPuzzle),
                    const SizedBox(width: 16),

                    // Center Puzzle Snap Grid
                    Expanded(
                      flex: 5,
                      child: _buildPuzzleGrid(currentPuzzle),
                    ),
                    const SizedBox(width: 16),

                    // Right Pieces Bank
                    Expanded(
                      flex: 4,
                      child: _buildPiecesBank(currentPuzzle),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/images/src_assets_icons_btn_back.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E78C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
            ),
          ),
          Text(
            _puzzles[_currentPuzzleIndex]['title'],
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          Row(
            children: [
              // Difficulty Switcher
              GestureDetector(
                onTap: _toggleDifficulty,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE68A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
                  ),
                  child: Text(
                    _gridSize == 2 ? 'Easy (2x2)' : 'Hard (3x3)',
                    style: GoogleFonts.comicNeue(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _startPuzzle,
                child: Image.asset(
                  'assets/images/src_assets_icons_btn_reload.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.refresh_rounded, color: Color(0xFF1E293B), size: 22),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionPanel(Map<String, dynamic> puzzle) {
    return Container(
      width: 165,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Target Image Preview
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                puzzle['image'],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Green/Grey Eye Inspection Toggle Tool
          GestureDetector(
            onTap: () {
              setState(() {
                _isEyePeekActive = !_isEyePeekActive;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isEyePeekActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isEyePeekActive ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    _isEyePeekActive
                        ? 'assets/images/src_assets_images_puzzle_green_eye.png'
                        : 'assets/images/src_assets_images_puzzle_grey_eye.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (_, __, ___) => Icon(
                      _isEyePeekActive ? Icons.visibility : Icons.visibility_off,
                      color: _isEyePeekActive ? Colors.green : Colors.grey,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isEyePeekActive ? 'Peek On' : 'Hint Eye',
                    style: GoogleFonts.comicNeue(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _isEyePeekActive ? const Color(0xFF16A34A) : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleGrid(Map<String, dynamic> puzzle) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 4)),
            ],
          ),
          child: Stack(
            children: [
              // Ghost Hint Overlay if Eye Peek Active
              if (_isEyePeekActive)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(puzzle['image'], fit: BoxFit.contain),
                    ),
                  ),
                ),

              // Grid Slots
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridSize,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _gridSize * _gridSize,
                itemBuilder: (context, slotIndex) {
                  final placedPiece = _placedSlots[slotIndex];

                  return DragTarget<int>(
                    onWillAcceptWithDetails: (details) => true,
                    onAcceptWithDetails: (details) {
                      _onPiecePlaced(details.data, slotIndex);
                    },
                    builder: (context, candidateData, rejectedData) {
                      final bool isHovered = candidateData.isNotEmpty;

                      if (placedPiece != null) {
                        return _buildPieceTile(puzzle, placedPiece, isDragging: false);
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: isHovered
                              ? const Color(0xFFE1F5FE)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isHovered ? const Color(0xFF2E78C7) : const Color(0xFFCBD5E1),
                            width: isHovered ? 2.5 : 1.2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.grey.shade400,
                            size: 26,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPiecesBank(Map<String, dynamic> puzzle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pieces (${_availablePieces.length} left)',
            style: GoogleFonts.comicNeue(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _availablePieces.isEmpty
                ? Center(
                    child: Text(
                      'All pieces placed! 🎉',
                      style: GoogleFonts.comicNeue(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF2E78C7)),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize == 2 ? 2 : 3,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: _availablePieces.length,
                    itemBuilder: (context, index) {
                      final pieceIndex = _availablePieces[index];

                      return Draggable<int>(
                        data: pieceIndex,
                        feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: _buildPieceTile(puzzle, pieceIndex, isDragging: true),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.25,
                          child: _buildPieceTile(puzzle, pieceIndex, isDragging: false),
                        ),
                        child: _buildPieceTile(puzzle, pieceIndex, isDragging: false),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieceTile(Map<String, dynamic> puzzle, int pieceIndex, {required bool isDragging}) {
    final row = pieceIndex ~/ _gridSize;
    final col = pieceIndex % _gridSize;

    final double alignX = _gridSize > 1 ? (col / (_gridSize - 1)) * 2 - 1 : 0.0;
    final double alignY = _gridSize > 1 ? (row / (_gridSize - 1)) * 2 - 1 : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDragging ? const Color(0xFF3B82F6) : Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDragging ? 0.25 : 0.08),
            blurRadius: isDragging ? 12 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FractionallySizedBox(
          widthFactor: _gridSize.toDouble(),
          heightFactor: _gridSize.toDouble(),
          alignment: Alignment(alignX, alignY),
          child: Image.asset(
            puzzle['image'],
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.blue.shade100,
              child: const Icon(Icons.extension_rounded, color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
