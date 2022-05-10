import 'chromosome.dart';

class Algorithm {
  final int initialPopulationSize;
  final int generationCount;
  final double crossoverRate;
  final double mutationRate;
  final int _tournamentSize = 2;
  late List<Chromosome> population;

  Algorithm(this.initialPopulationSize, this.generationCount,
      this.crossoverRate, this.mutationRate);

  void run() {
    final stopwatch = Stopwatch()..start();
    _printOperationStart();
    population = _generatePopulation();
    _printPartialResults(0);

    for (var i = 1; i < generationCount; i++) {
      final selectedPopulation = _selectPopulation();
      final offspring = _crossPopulationOver(i, selectedPopulation);
      population = selectedPopulation;
      population.addAll(offspring);
      _printPartialResults(i);
    }
    stopwatch.stop();
    _printFinalResults(stopwatch.elapsedMilliseconds);
  }

  List<Chromosome> _generatePopulation() {
    var i = 0;
    // ignore: omit_local_variable_types
    final List<Chromosome> initialPopulation = [];

    while (i < initialPopulationSize) {
      initialPopulation.add(Chromosome.random(0));
      i++;
    }

    return initialPopulation;
  }

  List<Chromosome> _selectPopulation() {
    final shuffledPopulation = population..shuffle();
    // ignore: omit_local_variable_types
    final List<Chromosome> selectedPopulation = [];

    for (var i = 0; i < shuffledPopulation.length - 1; i += _tournamentSize) {
      selectedPopulation
          .add(_fight(shuffledPopulation[i], shuffledPopulation[i + 1]));
    }

    return selectedPopulation;
  }

  Chromosome _fight(Chromosome a, Chromosome b) {
    return a.fitness > b.fitness ? a : b;
  }

  List<Chromosome> _crossPopulationOver(
      int currentGeneration, List<Chromosome> population) {
    final reproducingPopulation = [];

    for (var i = 0; i < population.length * crossoverRate; i++) {
      reproducingPopulation.add(population[i]);
    }
    // ignore: omit_local_variable_types
    final List<Chromosome> allOffspring = [];

    for (var i = 0; i < reproducingPopulation.length - 1; i += 2) {
      final offspring = reproducingPopulation[i].crossover(
          currentGeneration, reproducingPopulation[i + 1], mutationRate);

      allOffspring.addAll([offspring.item1, offspring.item2]);
    }

    return allOffspring;
  }

  Chromosome _bestSolution() {
    if (population.length == 1) {
      return population.first;
    }
    population.sort((a, b) => b.fitness.compareTo(a.fitness));
    return population.first;
  }

  void _printOperationStart() {
    print('Iniciando execução...');
    print('População inicial: $initialPopulationSize');
    print('Gerações a serem produzidas: $generationCount');
    print('Taxa de crossover: ${crossoverRate * 100}%');
    print('Taxa de mutação: ${mutationRate * 100}%');
  }

  void _printPartialResults(int currentGeneration) {
    print('\n- - - - - - - - - - - ');
    print('\nGeração atual: $currentGeneration\n');
    print('Todas as soluções da geração atual: ');
    for (var i in population) {
      print(' - x = ${i.decimalValue}');
    }

    final best = _bestSolution();
    print('\nMelhor solução atual:\n');
    print(
        ' - Valor de x: ${best.decimalValue}\n - Valor para f(x) = x * x - 3x + 4: ${best.fitness}\n - Geração: ${best.generation}');
  }

  void _printFinalResults(int durationMilisseconds) {
    print('\n- - - - - - - - - - - ');
    print('\nProcesso finalizado.\n');
    print('Tempo gasto: ${durationMilisseconds}ms');
    print('Gerações produzidas: $generationCount');
    final best = _bestSolution();
    print('Melhor valor encontrado para x: ${best.decimalValue}');
    print('Valor maximizado de f(x) = x * x - 3x + 4: ${best.fitness}');
    print('\nFIM DA EXECUÇÃO\n');
  }
}
