import 'dart:math';

import 'package:flutter_clicker/game_state.dart';
import 'package:flutter_clicker/upgrades.dart';

enum BuildingType {
  cursor,
  grandma,
  farm,
  mine,
  factory,
  bank,
  temple,
  wizardTower,
  shipment,
  alchemyLab,
  portal,
  timeMachine,
  antimatterCondenser,
  prism,
  chancemaker,
  fractalEngine,
  javascriptConsole,
  idleverse,
}

class Building {
  BuildingType type;
  String name;
  String description;
  String levelName;
  String icon;
  double cookiesPerSecond;
  double baseCost;

  // requirements
  final BigInt requiredCookies;
  final Map<BuildingType, int> requiredBuildings;
  final List<Type> requiredUpgrades;
  final List<Type> requiredAchievements;

  final List<Upgrade> appliedUpgrades = [];

  // statistics for this building
  double cookiesMade = 0;

  Building({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.cookiesPerSecond,
    required this.baseCost,
    required this.requiredBuildings,
    required this.requiredUpgrades,
    required this.requiredAchievements,
    required this.requiredCookies,
    this.levelName = "Basic",
  });

  bool canSee(GameState currentState) {
    for (var entry in requiredBuildings.entries) {
      if (currentState.buildings[entry.key] == null ||
          currentState.buildings[entry.key]! < entry.value) {
        return false;
      }
    }

    // for (var upgrade in requiredUpgrades) {
    //   if (!currentState.upgrades.contains(upgrade)) {
    //     return false;
    //   }
    // }

    // for (var achievement in requiredAchievements) {
    //   if (!currentState.achievements.contains(achievement)) {
    //     return false;
    //   }
    // }

    return true;
  }

  /// `Price = {Base cost} * 1.15^{M-F}`
  /// - M = number of buildings of this type
  /// - F = number of free buildings of this type
  double getCost(GameState currentState) {
    var f = 0;
    var m = currentState.buildings[type] ?? 0;

    return baseCost * pow(1.15, m - f);
  }
}

final cursor = Building(
  type: BuildingType.cursor,
  name: 'Cursor',
  description: 'Autoclicks once every 10 seconds.',
  icon: 'assets/buildings/cursor.png',
  baseCost: 15,
  cookiesPerSecond: 0.1,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final grandma = Building(
  type: BuildingType.grandma,
  name: 'Grandma',
  description: 'A nice grandma to bake more cookies.',
  icon: 'assets/buildings/grandma.png',
  baseCost: 100,
  cookiesPerSecond: 1,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final farm = Building(
  type: BuildingType.farm,
  name: 'Farm',
  description: 'Grows cookie plants from cookie seeds.',
  icon: 'assets/buildings/farm.png',
  baseCost: 1100,
  cookiesPerSecond: 8,
  requiredBuildings: {
    BuildingType.cursor: 1,
  },
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final mine = Building(
  type: BuildingType.mine,
  name: 'Mine',
  description: 'Mines out cookie dough and chocolate chips.',
  icon: 'assets/buildings/mine.png',
  baseCost: 12000,
  cookiesPerSecond: 47,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final factory = Building(
  type: BuildingType.factory,
  name: 'Factory',
  description: 'Produces large quantities of cookies.',
  icon: 'assets/buildings/factory.png',
  baseCost: 130000,
  cookiesPerSecond: 260,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final bank = Building(
  type: BuildingType.bank,
  name: 'Bank',
  description: 'Generates cookies from interest.',
  icon: 'assets/buildings/bank.png',
  baseCost: 1400000,
  cookiesPerSecond: 1400,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final temple = Building(
  type: BuildingType.temple,
  name: 'Temple',
  description: 'Full of precious, ancient chocolate.',
  icon: 'assets/buildings/temple.png',
  baseCost: 20000000,
  cookiesPerSecond: 7800,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final wizardTower = Building(
  type: BuildingType.wizardTower,
  name: 'Wizard Tower',
  description: 'Summons cookies with magic spells.',
  icon: 'assets/buildings/wizard_tower.png',
  baseCost: 330000000,
  cookiesPerSecond: 44000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final shipment = Building(
  type: BuildingType.shipment,
  name: 'Shipment',
  description: 'Brings in fresh cookies from overseas.',
  icon: 'assets/buildings/shipment.png',
  baseCost: 1100,
  cookiesPerSecond: 8,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final alchemyLab = Building(
  type: BuildingType.alchemyLab,
  name: 'Alchemy Lab',
  description: 'Turns gold into cookies!',
  icon: 'assets/buildings/alchemy_lab.png',
  baseCost: 75000000000,
  cookiesPerSecond: 1600000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final portal = Building(
  type: BuildingType.portal,
  name: 'Portal',
  description: 'Opens a door to the Cookieverse.',
  icon: 'assets/buildings/portal.png',
  baseCost: 1000000000000,
  cookiesPerSecond: 10000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final timeMachine = Building(
  type: BuildingType.timeMachine,
  name: 'Time Machine',
  description: 'Brings cookies from the past, before they were even eaten.',
  icon: 'assets/buildings/time_machine.png',
  baseCost: 14000000000000,
  cookiesPerSecond: 65000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final antimatterCondenser = Building(
  type: BuildingType.antimatterCondenser,
  name: 'Antimatter Condenser',
  description: 'Condenses the antimatter in the universe into cookies.',
  icon: 'assets/buildings/antimatter_condenser.png',
  baseCost: 170000000000000,
  cookiesPerSecond: 430000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final prism = Building(
  type: BuildingType.prism,
  name: 'Prism',
  description: 'Converts light itself into cookies.',
  icon: 'assets/buildings/prism.png',
  baseCost: 2100000000000000,
  cookiesPerSecond: 2900000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final chancemaker = Building(
  type: BuildingType.chancemaker,
  name: 'Chancemaker',
  description: 'Generates cookies out of thin air through sheer luck.',
  icon: 'assets/buildings/chancemaker.png',
  baseCost: 26000000000000000,
  cookiesPerSecond: 21000000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final fractalEngine = Building(
  type: BuildingType.fractalEngine,
  name: 'Fractal Engine',
  description: 'Harness the power of the infinite.',
  icon: 'assets/buildings/fractal_engine.png',
  baseCost: 310000000000000000,
  cookiesPerSecond: 150000000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final javascriptConsole = Building(
  type: BuildingType.javascriptConsole,
  name: 'Javascript Console',
  description: 'Hey, I heard you like Javascript...',
  icon: 'assets/buildings/javascript_console.png',
  baseCost: 7100000000000000000,
  cookiesPerSecond: 1100000000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final idleverse = Building(
  type: BuildingType.idleverse,
  name: 'Idleverse',
  description: 'This is never going to end, is it?',
  icon: 'assets/buildings/idleverse.png',
  baseCost: 120000000000000000000,
  cookiesPerSecond: 7800000000000,
  requiredBuildings: {},
  requiredUpgrades: [],
  requiredAchievements: [],
  requiredCookies: BigInt.from(0),
);

final buildingTypeToBuilding = {
  BuildingType.cursor: cursor,
  BuildingType.grandma: grandma,
  BuildingType.farm: farm,
  BuildingType.mine: mine,
  BuildingType.factory: factory,
  BuildingType.bank: bank,
  BuildingType.temple: temple,
  BuildingType.wizardTower: wizardTower,
  BuildingType.shipment: shipment,
  BuildingType.alchemyLab: alchemyLab,
  BuildingType.portal: portal,
  BuildingType.timeMachine: timeMachine,
  BuildingType.antimatterCondenser: antimatterCondenser,
  BuildingType.prism: prism,
  BuildingType.chancemaker: chancemaker,
  BuildingType.fractalEngine: fractalEngine,
  BuildingType.javascriptConsole: javascriptConsole,
  BuildingType.idleverse: idleverse,
};

// check that all possible enum values have a building
void checkBuildingEnum() {
  for (var value in BuildingType.values) {
    if (!buildingTypeToBuilding.containsKey(value)) {
      throw Exception('BuildingType $value has no building in map');
    }
  }
}



// abstract class Building {
//   abstract String name;
//   abstract String description;
//   abstract String icon;
//   abstract double cookiesPerSecond;
//   abstract double baseCost;

//   // requirements
//   abstract List<Type> requiredBuildings;
//   abstract List<Type> requiredUpgrades;
//   abstract List<Type> requiredAchievements;
//   abstract double requiredCookies;

//   /// `Price = {Base cost} * 1.15^{M-F}`
//   /// - M = number of buildings of this type
//   /// - F = number of free buildings of this type
//   double getCost(GameState currentState) {
//     var m = 0;
//     var f = 0;
//     for (var building in currentState.buildings) {
//       if (building.runtimeType == runtimeType) {
//         m++;
//       }

//       // TODO: count free buildings
//     }
//     return baseCost * pow(1.15, m - f);
//   }
// }

// class Cursor extends Building {
//   @override
//   String name = 'Cursor';

//   @override
//   String description = 'Autoclicks once every 10 seconds.';

//   @override
//   String icon = 'assets/buildings/cursor.png';

//   @override
//   double baseCost = 15;

//   @override
//   double cookiesPerSecond = 0.1;

//   @override
//   List<Type> requiredBuildings = [];

//   @override
//   List<Type> requiredUpgrades = [];

//   @override
//   List<Type> requiredAchievements = [];

//   @override
//   double requiredCookies = 0;
// }

// class Grandma extends Building {
//   @override
//   String name = 'Grandma';

//   @override
//   String description = 'A nice grandma to bake more cookies.';

//   @override
//   String icon = 'assets/buildings/grandma.png';

//   @override
//   double baseCost = 100;

//   @override
//   double cookiesPerSecond = 1;

//   @override
//   List<Type> requiredBuildings = [];

//   @override
//   List<Type> requiredUpgrades = [];

//   @override
//   List<Type> requiredAchievements = [];

//   @override
//   double requiredCookies = 0;
// }

// class Farm extends Building {
//   @override
//   String name = 'Farm';

//   @override
//   String description = 'Grows cookie plants from cookie seeds.';

//   @override
//   String icon = 'assets/buildings/farm.png';

//   @override
//   double baseCost = 1100;

//   @override
//   double cookiesPerSecond = 8;

//   @override
//   List<Type> requiredBuildings = [];

//   @override
//   List<Type> requiredUpgrades = [];

//   @override
//   List<Type> requiredAchievements = [];

//   @override
//   double requiredCookies = 0;
// }

// class Mine extends Building {
//   @override
//   String name = 'Mine';

//   @override
//   String description = 'Mines out cookie dough and chocolate chips.';

//   @override
//   String icon = 'assets/buildings/mine.png';

//   @override
//   double baseCost = 12000;

//   @override
//   double cookiesPerSecond = 47;
// }

// class Factory extends Building {
//   @override
//   String name = 'Factory';

//   @override
//   String description = 'Produces large quantities of cookies.';

//   @override
//   String icon = 'assets/buildings/factory.png';

//   @override
//   double baseCost = 130000;

//   @override
//   double cookiesPerSecond = 260;
// }

// class Bank extends Building {
//   @override
//   String name = 'Bank';

//   @override
//   String description = 'Generates cookies from interest.';

//   @override
//   String icon = 'assets/buildings/bank.png';

//   @override
//   double baseCost = 1400000;

//   @override
//   double cookiesPerSecond = 1400;
// }

// class Temple extends Building {
//   @override
//   String name = 'Temple';

//   @override
//   String description = 'Full of precious, ancient chocolate.';

//   @override
//   String icon = 'assets/buildings/temple.png';

//   @override
//   double baseCost = 20000000;

//   @override
//   double cookiesPerSecond = 7800;
// }

// class WizardTower extends Building {
//   @override
//   String name = 'Wizard Tower';

//   @override
//   String description = 'Summons cookies with magic spells.';

//   @override
//   String icon = 'assets/buildings/wizard_tower.png';

//   @override
//   double baseCost = 330000000;

//   @override
//   double cookiesPerSecond = 44000;
// }

// class Shipment extends Building {
//   @override
//   String name = 'Shipment';

//   @override
//   String description = 'Brings in fresh cookies from overseas.';

//   @override
//   String icon = 'assets/buildings/shipment.png';

//   @override
//   double baseCost = 1100;

//   @override
//   double cookiesPerSecond = 8;
// }

// class AlchemyLab extends Building {
//   @override
//   double baseCost = 75000000000;

//   @override
//   double cookiesPerSecond = 1600000;
// }

// class Portal extends Building {
//   @override
//   double baseCost = 1000000000000;

//   @override
//   double cookiesPerSecond = 10000000;
// }

// class TimeMachine extends Building {
//   @override
//   double baseCost = 14000000000000;

//   @override
//   double cookiesPerSecond = 65000000;
// }

// class AntimatterCondenser extends Building {
//   @override
//   double baseCost = 170000000000000;

//   @override
//   double cookiesPerSecond = 430000000;
// }

// class Prism extends Building {
//   @override
//   double baseCost = 2100000000000000;

//   @override
//   double cookiesPerSecond = 2900000000;
// }
