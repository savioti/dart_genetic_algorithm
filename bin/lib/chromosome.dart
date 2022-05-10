import 'dart:math';
import 'package:tuple/tuple.dart';

class Chromosome {
  late List<int> genes;
  late int decimalValue;
  final int generation;
  final int _geneCount = 5;
  final _random = Random();

  Chromosome(this.generation, this.genes) {
    _capGenesValue();
    decimalValue = _convertedGenesValue();
  }

  Chromosome.random(this.generation) {
    genes = [];

    var i = 0;

    while (i < _geneCount) {
      genes.add(_random.nextInt(2));
      i++;
    }

    _capGenesValue();
    decimalValue = _convertedGenesValue();
  }

  Tuple2<Chromosome, Chromosome> crossover(
      int currentGeneration, Chromosome otherParent, double mutationRate) {
    final crossoverIndex = _random.nextInt(_geneCount - 2) + 1;

    // ignore: omit_local_variable_types
    List<int> offspring1Genes = [];
    // ignore: omit_local_variable_types
    List<int> offspring2Genes = [];

    for (var i = 0; i < _geneCount; i++) {
      if (i < crossoverIndex) {
        offspring1Genes.add(genes[i]);
        offspring2Genes.add(otherParent.genes[i]);
      } else {
        offspring1Genes.add(otherParent.genes[i]);
        offspring2Genes.add(genes[i]);
      }
    }

    final offspring1 = Chromosome(
        currentGeneration, _mutateGenes(offspring1Genes, mutationRate));
    final offspring2 = Chromosome(
        currentGeneration, _mutateGenes(offspring2Genes, mutationRate));

    return Tuple2<Chromosome, Chromosome>(offspring1, offspring2);
  }

  int get fitness {
    return (pow(decimalValue, 2) as int) - 3 * decimalValue + 4;
  }

  int _convertedGenesValue() {
    if (genes.length != _geneCount) {
      throw RangeError(
          'Expected a gene count of $_geneCount, found ${genes.length}');
    }

    var value = 0;

    for (var i = 1; i < _geneCount; i++) {
      if (genes[i] == 1) {
        value += pow(2, i) as int;
      }
    }

    final sign = genes.first == 0 ? -1 : 1;
    return value * sign;
  }

  List<int> _mutateGenes(List<int> offspringGenes, double mutationRate) {
    if (_random.nextDouble() > mutationRate) {
      return offspringGenes;
    }

    final randomIndex = _random.nextInt(_geneCount);
    offspringGenes[randomIndex] = _reverseValue(offspringGenes[randomIndex]);
    return offspringGenes;
  }

  int _reverseValue(int i) {
    return i == 0 ? 1 : 0;
  }

  void _capGenesValue() {
    if ((_convertedGenesValue() >= -10) && (_convertedGenesValue() <= 10)) {
      return;
    }

    if (genes[2] == 1) {
      genes[2] = 0;
    }

    if (genes[4] == 1) {
      genes[4] = 0;
    }
  }
}
