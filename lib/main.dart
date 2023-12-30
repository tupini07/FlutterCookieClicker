import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_clicker/buildings.dart';
import 'package:flutter_clicker/game_state.dart';
import 'package:flutter_clicker/upgrades.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

// A Counter example implemented with riverpod

void main() {
  checkBuildingEnum();
  checkUpgradesEnum();

  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FlutterClicker());
  }
}

/// Annotating a class by `@riverpod` defines a new shared state for your application,
/// accessible using the generated [counterProvider].
/// This class is both responsible for initializing the state (through the [build] method)
/// and exposing ways to modify it (cf [increment]).
@riverpod
class GameStateProvider extends _$GameStateProvider {
  final GameState _state = GameState();
  final StreamController<GameState> _streamController =
      StreamController<GameState>();

  @override
  Stream<GameState> build() {
    Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => _streamController.add(_state.updateState()),
    );

    return _streamController.stream;
  }

  void doClick() {
    _state.doClick();
    _streamController.add(_state);
  }

  buyBuilding(Building building) {
    _state.buyBuilding(building);
    _streamController.add(_state);
  }
}

class FlutterClicker extends ConsumerWidget {
  const FlutterClicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(gameStateProviderProvider).value;
    if (state == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookie Clicker'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double
                  .infinity, // This will expand the container horizontally
              child: InkWell(
                onTap: () =>
                    ref.read(gameStateProviderProvider.notifier).doClick(),
                hoverColor: Colors.transparent,
                child: const Icon(
                  Icons.cookie_rounded,
                  size: 200,
                  color: Colors.brown,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cookies: ${state.cookies}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Cookies per second: ${state.getCookiesPerSecond()}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              flex: 1,
              child: Store(),
            ),
          ],
        ),
      ),
    );
  }
}

class Store extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProviderProvider).value;

    if (state == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: buildingTypeToBuilding.length,
      itemBuilder: (context, index) {
        final buildingT = buildingTypeToBuilding.keys.toList()[index];
        final building = buildingTypeToBuilding[buildingT]!;

        if (!building.canSee(state)) {
          return const SizedBox
              .shrink(); // Return an empty widget if the building should not be visible
        }

        final canBuy = state.canBuyBuilding(building);

        return ListTile(
          leading: const Icon(Icons.home), // Replace with an appropriate icon
          title: Text(building.name),
          subtitle: Text(
              'Cost: ${building.getCost(state)} cookies\nOwned: ${state.buildings[building.type] ?? 0}'),
          trailing: ElevatedButton(
            onPressed: canBuy
                ? () => ref
                    .read(gameStateProviderProvider.notifier)
                    .buyBuilding(building)
                : null,
            child: const Text('Buy'),
          ),
        );
      },
    );
  }
}

class StatelessPrintState extends StatelessWidget {
  final GameState state;

  const StatelessPrintState(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    // Use the watch method to obtain the state.
    final stateStr = state.toString();

    // Use the state in your widget.
    return Column(children: [
      Text(stateStr),
      Text("Cookies: ${state.cookies}"),
      Text("Ticks: ${state.ticks}"),
    ]);
  }
}
