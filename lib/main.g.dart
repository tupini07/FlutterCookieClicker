// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameStateProviderHash() => r'914c0d83e202d20b031c9543991fe67c388b98ed';

/// Annotating a class by `@riverpod` defines a new shared state for your application,
/// accessible using the generated [counterProvider].
/// This class is both responsible for initializing the state (through the [build] method)
/// and exposing ways to modify it (cf [increment]).
///
/// Copied from [GameStateProvider].
@ProviderFor(GameStateProvider)
final gameStateProviderProvider =
    AutoDisposeStreamNotifierProvider<GameStateProvider, GameState>.internal(
  GameStateProvider.new,
  name: r'gameStateProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameStateProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameStateProvider = AutoDisposeStreamNotifier<GameState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
