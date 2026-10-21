import 'package:flutter_test/flutter_test.dart';
import 'package:qavexspidercardspremium/game/logic.dart';

SolitaireEngine fresh({int seed = 42}) {
  final e = SolitaireEngine(gameConfig());
  e.newGame(seed: seed);
  return e;
}

SolitaireEngine rigged() {
  final e = SolitaireEngine(gameConfig());
  e.tableau = List.generate(gameConfig().piles, (_) => <SolCard>[]);
  e.foundation = List.generate(gameConfig().foundations, (_) => <SolCard>[]);
  e.stock = <SolCard>[];
  e.waste = <SolCard>[];
  e.reserve = List<SolCard?>.filled(gameConfig().reserves, null);
  e.reservePile = <SolCard>[];
  return e;
}
void main() {
  test('spider deal: 10 piles, 54 tableau cards, 50 in stock', () {
    final e = fresh();
    expect(e.tableau.length, 10);
    const want = [6, 6, 6, 6, 5, 5, 5, 5, 5, 5];
    int total = 0;
    for (int i = 0; i < 10; i++) {
      expect(e.tableau[i].length, want[i]);
      expect(e.tableau[i].last.faceUp, isTrue);
      total += e.tableau[i].length;
    }
    expect(total, 54);
    expect(e.stock.length, 50);
    expect(e.waste, isEmpty);
    expect(e.isWon, isFalse);
  });

  test('descending build is accepted in any suit', () {
    final e = rigged();
    e.tableau[0].add(SolCard(0, 6, faceUp: true)); // 6S
    e.tableau[1].add(SolCard(1, 5, faceUp: true)); // 5H
    expect(e.moveTableauToTableau(1, 0, 0), isTrue);
    expect(e.tableau[0].length, 2);
    expect(e.tableau[1], isEmpty);
  });

  test('non-descending build is rejected', () {
    final e = rigged();
    e.tableau[0].add(SolCard(0, 6, faceUp: true)); // 6S
    e.tableau[1].add(SolCard(1, 6, faceUp: true)); // 6H same rank
    expect(e.moveTableauToTableau(1, 0, 0), isFalse);
    expect(e.tableau[1].length, 1);
  });

  test('deal row adds one card to every column and undo restores', () {
    final e = fresh();
    expect(e.drawFromStock(), isTrue);
    expect(e.stock.length, 40);
    for (int i = 0; i < 10; i++) {
      expect(e.tableau[i].last.faceUp, isTrue);
    }
    expect(e.canUndo, isTrue);
    e.undo();
    expect(e.stock.length, 50);
  });

  test('a complete same-suit K..A run is removed', () {
    final e = rigged();
    for (int r = 13; r >= 1; r--) {
      e.tableau[0].add(SolCard(0, r, faceUp: true));
    }
    e.tableau[1].add(SolCard(0, 13, faceUp: true)); // KS
    e.tableau[2].add(SolCard(0, 12, faceUp: true)); // QS
    expect(e.moveTableauToTableau(2, 0, 1), isTrue);
    expect(e.tableau[0], isEmpty);
    expect(e.seqRemoved, 1);
    expect(e.foundation[0].length, 13);
  });

  test('hint suggests the king for the empty column', () {
    final e = rigged();
    e.tableau[0].add(SolCard(0, 7)); // face down
    e.tableau[0].add(SolCard(0, 13, faceUp: true)); // KS
    expect(e.hint(), isNotEmpty);
  });
}
