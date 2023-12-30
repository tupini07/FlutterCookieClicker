import 'package:flutter_clicker/buildings.dart';

class GameState {
  double ticks = 0;

  double clickValue = 1;

  BigInt cookies = BigInt.from(0);
  Map<BuildingType, int> buildings = {for (var v in BuildingType.values) v: 0};

  GameState updateState() {
    ticks += 1;

    _runBuildings();

    return this;
  }

  void doClick() {
    cookies += BigInt.from(clickValue);
  }

  _runBuildings() {
    for (var entry in buildings.entries) {
      if (entry.value > 0) {
        var building = buildingTypeToBuilding[entry.key];
        cookies += BigInt.from(building!.cookiesPerSecond);

        building.cookiesMade += building.cookiesPerSecond;
      }
    }
  }

  double getCookiesPerSecond() {
    double cookiesPerSecond = 0;
    for (var entry in buildings.entries) {
      if (entry.value > 0) {
        var building = buildingTypeToBuilding[entry.key];
        cookiesPerSecond += building!.cookiesPerSecond * entry.value;
      }
    }
    return cookiesPerSecond;
  }

  bool canBuyBuilding(Building building) {
    return cookies >= BigInt.from(building.getCost(this));
  }

  void buyBuilding(Building building) {
    final buildingCost = building.getCost(this);
    if (cookies >= BigInt.from(buildingCost)) {
      cookies -= BigInt.from(buildingCost);
      buildings[building.type] = buildings[building.type]! + 1;
    }
  }
}
