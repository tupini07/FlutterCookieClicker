import 'dart:async';

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

  buyUpgrade(Upgrade upgrade) {
    _state.buyUpgrade(upgrade);
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
            const Expanded(
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
  const Store({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProviderProvider).value;

    if (state == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return const Column(children: [
      UpgradeStore(),
      BuildingStore(),
    ]);
  }
}

class UpgradeStore extends ConsumerWidget {
  const UpgradeStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProviderProvider).value!;

    return SizedBox(
      height: 200,
      width: double.infinity, // This provides a bounded width
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: upgradeTypeToUpgrades.length,
        itemBuilder: (context, index) {
          final upgradeT = upgradeTypeToUpgrades.keys.toList()[index];
          final upgrade = upgradeTypeToUpgrades[upgradeT]!;

          final canBuy = upgrade.canBuy(state);

          if (!upgrade.canSee(state)) {
            return const SizedBox
                .shrink(); // Don't show the list item if canBuy is false
          }

          return SizedBox(
            width: 200,
            child: ListTile(
              leading:
                  const Icon(Icons.upgrade), // Replace with an appropriate icon
              title: Text(upgrade.name),
              subtitle: Text('Cost: ${upgrade.cost} cookies'),
              trailing: ElevatedButton(
                onPressed: canBuy
                    ? () => ref
                        .read(gameStateProviderProvider.notifier)
                        .buyUpgrade(upgrade)
                    : null,
                child: const Text('Buy'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BuildingStore extends ConsumerWidget {
  const BuildingStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProviderProvider).value!;

    return Expanded(
      child: ListView.builder(
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
      ),
    );
  }
}
