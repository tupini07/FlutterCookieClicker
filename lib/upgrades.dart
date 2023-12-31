import 'package:flutter_clicker/buildings.dart';
import 'package:flutter_clicker/game_state.dart';

enum UpgradeType {
  // Cursor
  cursorReinforcedIndexFinger,
  cursorCarpalTunnelPreventionCream,
  cursorAmbidextrous,
  cursorThousandFingers,
  cursorMillionFingers,

  // Grandma
  grandmaForwardsFromGrandma,
  grandmaSteelPlatedRollingPins,
  // grandmaLubricatedDentures,
  // grandmaPruneJuice,
  // grandmaDoubleThickGlasses,
  // grandmaAgingAgents,
  // grandmaXtremeWalkers,
  // grandmaTheUnbridling,
  // grandmaReverseDementia,
  // grandmaTimeProofHairDye,
  // grandmaGoodManners,
  // grandmaGenerationDegeneration,
  // grandmaVisits,
  // grandmaKitchenCabinets,
  // grandmaFoamTippedCanes
}

class Upgrade {
  bool applied = false;

  String name;
  String description;
  String icon;
  BigInt cost;
  double cookiesPerSecondIncreaseMultiplier;

  Map<BuildingType, int> requiredBuildings;
  List<UpgradeType> requiredUpgrades;
  Function(GameState)? specialApply;

  Upgrade({
    required this.name,
    required this.description,
    required this.icon,
    required this.cost,
    required this.cookiesPerSecondIncreaseMultiplier,
    required this.requiredBuildings,
    required this.requiredUpgrades,
    this.specialApply,
  });

  bool canBuy(GameState state) {
    if (applied) return false;

    if (state.cookies < cost) return false;

    for (var entry in requiredBuildings.entries) {
      if (state.buildings[entry.key]! < entry.value) return false;
    }

    for (var upgrade in requiredUpgrades) {
      if (!upgradeTypeToUpgrades[upgrade]!.applied) return false;
    }

    return true;
  }

  void apply(GameState state) {
    if (!applied && canBuy(state)) {
      applied = true;

      state.cookies -= cost;

      final building = buildingTypeToBuilding[requiredBuildings]!;
      building.levelName = name;
      building.cookiesPerSecond *= cookiesPerSecondIncreaseMultiplier;
      building.appliedUpgrades.add(this);

      // if applies to cursor then apply to click value as well
      if ((requiredBuildings[BuildingType.cursor] ?? 0) > 0) {
        state.clickValue *= cookiesPerSecondIncreaseMultiplier;
      }

      if (specialApply != null) specialApply!(state);
    } else {
      throw Exception('Cannot apply upgrade $name');
    }
  }
}

// cursor
final cursorReinforcedIndexFinger = Upgrade(
  name: 'Reinforced index finger',
  description: 'The mouse and cursors are twice as efficient.',
  icon: 'assets/images/upgrade_click_value.png',
  cost: BigInt.from(100),
  cookiesPerSecondIncreaseMultiplier: 2,
  requiredBuildings: {BuildingType.cursor: 1},
  requiredUpgrades: [],
);

final cursorCarpalTunnelPreventionCream = Upgrade(
  name: 'Carpal tunnel prevention cream',
  description: 'The mouse and cursors are twice as efficient.',
  icon: 'assets/images/upgrade_click_value.png',
  cost: BigInt.from(500),
  cookiesPerSecondIncreaseMultiplier: 2,
  requiredBuildings: {BuildingType.cursor: 1},
  requiredUpgrades: [UpgradeType.cursorReinforcedIndexFinger],
);

final cursorAmbidextrous = Upgrade(
  name: 'Ambidextrous',
  description: 'The mouse and cursors are twice as efficient.',
  icon: 'assets/images/upgrade_click_value.png',
  cost: BigInt.from(10000),
  cookiesPerSecondIncreaseMultiplier: 2,
  requiredBuildings: {BuildingType.cursor: 10},
  requiredUpgrades: [UpgradeType.cursorCarpalTunnelPreventionCream],
);

var _addedByCursorThousandFingers = 0.0;
final cursorThousandFingers = Upgrade(
  name: 'Thousand fingers',
  description:
      'The mouse and cursors gain +0.1 cookies for each non-cursor object owned.',
  icon: 'assets/images/upgrade_click_value.png',
  cost: BigInt.from(100000),
  cookiesPerSecondIncreaseMultiplier: 1,
  requiredBuildings: {BuildingType.cursor: 25},
  requiredUpgrades: [UpgradeType.cursorAmbidextrous],
  specialApply: (GameState state) {
    var howManyNonCursorBuildings = 0;
    for (var entry in state.buildings.entries) {
      if (entry.key != BuildingType.cursor) {
        howManyNonCursorBuildings += entry.value;
      }
    }

    final howMuchToAdd = howManyNonCursorBuildings * 0.1;
    _addedByCursorThousandFingers = howMuchToAdd;

    buildingTypeToBuilding[BuildingType.cursor]!.cookiesPerSecond +=
        howMuchToAdd;

    state.clickValue += howMuchToAdd;
  },
);

final cursorMillionFingers = Upgrade(
  name: 'Million fingers',
  description: 'Multiplies the gain from Thousand fingers by 5.',
  icon: 'assets/images/upgrade_click_value.png',
  cost: BigInt.from(10000000),
  cookiesPerSecondIncreaseMultiplier: 1,
  requiredBuildings: {BuildingType.cursor: 50},
  requiredUpgrades: [UpgradeType.cursorThousandFingers],
  specialApply: (GameState state) {
    state.clickValue -= _addedByCursorThousandFingers;
    state.clickValue += _addedByCursorThousandFingers * 5;

    buildingTypeToBuilding[BuildingType.cursor]!.cookiesPerSecond -=
        _addedByCursorThousandFingers;

    buildingTypeToBuilding[BuildingType.cursor]!.cookiesPerSecond +=
        _addedByCursorThousandFingers * 5;
  },
);

// grandma
final grandmaForwardsFromGrandma = Upgrade(
  name: 'Forwards from grandma',
  description: 'Grandmas are twice as efficient.',
  icon: 'assets/images/upgrade_grandma.png',
  cost: BigInt.from(1000),
  cookiesPerSecondIncreaseMultiplier: 2,
  requiredBuildings: {BuildingType.grandma: 1},
  requiredUpgrades: [],
);
final grandmaSteelPlatedRollingPins = Upgrade(
  name: 'Steel-plated rolling pins',
  description: 'Grandmas are twice as efficient.',
  icon: 'assets/images/upgrade_grandma.png',
  cost: BigInt.from(5000),
  cookiesPerSecondIncreaseMultiplier: 2,
  requiredBuildings: {BuildingType.grandma: 5},
  requiredUpgrades: [UpgradeType.grandmaForwardsFromGrandma],
);

final upgradeTypeToUpgrades = {
  // cursor
  UpgradeType.cursorReinforcedIndexFinger: cursorReinforcedIndexFinger,
  UpgradeType.cursorCarpalTunnelPreventionCream:
      cursorCarpalTunnelPreventionCream,
  UpgradeType.cursorAmbidextrous: cursorAmbidextrous,
  UpgradeType.cursorThousandFingers: cursorThousandFingers,
  UpgradeType.cursorMillionFingers: cursorMillionFingers,

  // grandma
  UpgradeType.grandmaForwardsFromGrandma: grandmaForwardsFromGrandma,
  UpgradeType.grandmaSteelPlatedRollingPins: grandmaSteelPlatedRollingPins,
};

void checkUpgradesEnum() {
  for (var value in UpgradeType.values) {
    if (!upgradeTypeToUpgrades.containsKey(value)) {
      throw Exception('UpgradeType $value has no upgrade in map');
    }
  }
}

// final upgradeTypeToUpgrades = {
//   UpgradeType.clickValue: Upgrade(
//     name: 'Reinforced index finger',
//     description: 'The mouse and cursors are twice as efficient.',
//     icon: 'assets/images/upgrade_click_value.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: {BuildingType.cursor: 0000000},
//     requiredUpgrades: [],
//   ),
//   UpgradeType.cursor: Upgrade(
//     name: 'Reinforced index finger',
//     description: 'The mouse and cursors are twice as efficient.',
//     icon: 'assets/images/upgrade_cursor.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: {BuildingType.cursor: 0000000},
//     requiredUpgrades: [],
//   ),
//   UpgradeType.grandma: Upgrade(
//     name: 'Forwards from grandma',
//     description: 'Grandmas are twice as efficient.',
//     icon: 'assets/images/upgrade_grandma.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.grandma,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.farm: Upgrade(
//     name: 'Cheap hoes',
//     description: 'Farms are twice as efficient.',
//     icon: 'assets/images/upgrade_farm.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.farm,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.mine: Upgrade(
//     name: 'Sugar gas',
//     description: 'Mines are twice as efficient.',
//     icon: 'assets/images/upgrade_mine.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.mine,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.factory: Upgrade(
//     name: 'Sturdier conveyor belts',
//     description: 'Factories are twice as efficient.',
//     icon: 'assets/images/upgrade_factory.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.factory,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.bank: Upgrade(
//     name: 'Printing presses',
//     description: 'Banks are twice as efficient.',
//     icon: 'assets/images/upgrade_bank.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.bank,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.temple: Upgrade(
//     name: 'Golden idols',
//     description: 'Temples are twice as efficient.',
//     icon: 'assets/images/upgrade_temple.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.temple,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.wizardTower: Upgrade(
//     name: 'Pointier hats',
//     description: 'Wizard towers are twice as efficient.',
//     icon: 'assets/images/upgrade_wizard_tower.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.wizardTower,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.shipment: Upgrade(
//     name: 'Vanilla nebulae',
//     description: 'Shipments are twice as efficient.',
//     icon: 'assets/images/upgrade_shipment.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.shipment,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.alchemyLab: Upgrade(
//     name: 'Antimony',
//     description: 'Alchemy labs are twice as efficient.',
//     icon: 'assets/images/upgrade_alchemy_lab.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.alchemyLab,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.portal: Upgrade(
//     name: 'Ancient tablet',
//     description: 'Portals are twice as efficient.',
//     icon: 'assets/images/upgrade_portal.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.portal,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.timeMachine: Upgrade(
//     name: 'Flux capacitors',
//     description: 'Time machines are twice as efficient.',
//     icon: 'assets/images/upgrade_time_machine.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.timeMachine,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.antimatterCondenser: Upgrade(
//     name: 'Sugar bosons',
//     description: 'Antimatter condensers are twice as efficient.',
//     icon: 'assets/images/upgrade_antimatter_condenser.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.antimatterCondenser,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.prism: Upgrade(
//     name: 'Gem polish',
//     description: 'Prisms are twice as efficient.',
//     icon: 'assets/images/upgrade_prism.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.prism,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.chancemaker: Upgrade(
//     name: 'Your lucky cookie',
//     description: 'Chancemakers are twice as efficient.',
//     icon: 'assets/images/upgrade_chancemaker.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.chancemaker,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.fractalEngine: Upgrade(
//     name: 'Quantum electronics',
//     description: 'Fractal engines are twice as efficient.',
//     icon: 'assets/images/upgrade_fractal_engine.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.fractalEngine,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.javascriptConsole: Upgrade(
//     name: 'Javascript consoles',
//     description: 'Javascript consoles are twice as efficient.',
//     icon: 'assets/images/upgrade_javascript_console.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.javascriptConsole,
//     requiredUpgrades: [],
//   ),
//   UpgradeType.idleverse: Upgrade(
//     name: 'Idleverse',
//     description: 'Idleverses are twice as efficient.',
//     icon: 'assets/images/upgrade_idleverse.png',
//     cost: BigInt.from(100),
//     cookiesPerSecondIncrease: 0,
//     requiredBuilding: BuildingType.idleverse,
//     requiredUpgrades: [],
//   ),
// };
