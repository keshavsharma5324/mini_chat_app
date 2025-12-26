// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_meaning_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordMeaningNotifierHash() =>
    r'57c372b7e56926fa9f8d478c6f59169011bf791b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$WordMeaningNotifier
    extends BuildlessAutoDisposeAsyncNotifier<WordMeaningEntity?> {
  late final String word;

  FutureOr<WordMeaningEntity?> build(String word);
}

/// See also [WordMeaningNotifier].
@ProviderFor(WordMeaningNotifier)
const wordMeaningNotifierProvider = WordMeaningNotifierFamily();

/// See also [WordMeaningNotifier].
class WordMeaningNotifierFamily extends Family<AsyncValue<WordMeaningEntity?>> {
  /// See also [WordMeaningNotifier].
  const WordMeaningNotifierFamily();

  /// See also [WordMeaningNotifier].
  WordMeaningNotifierProvider call(String word) {
    return WordMeaningNotifierProvider(word);
  }

  @override
  WordMeaningNotifierProvider getProviderOverride(
    covariant WordMeaningNotifierProvider provider,
  ) {
    return call(provider.word);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'wordMeaningNotifierProvider';
}

/// See also [WordMeaningNotifier].
class WordMeaningNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          WordMeaningNotifier,
          WordMeaningEntity?
        > {
  /// See also [WordMeaningNotifier].
  WordMeaningNotifierProvider(String word)
    : this._internal(
        () => WordMeaningNotifier()..word = word,
        from: wordMeaningNotifierProvider,
        name: r'wordMeaningNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wordMeaningNotifierHash,
        dependencies: WordMeaningNotifierFamily._dependencies,
        allTransitiveDependencies:
            WordMeaningNotifierFamily._allTransitiveDependencies,
        word: word,
      );

  WordMeaningNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.word,
  }) : super.internal();

  final String word;

  @override
  FutureOr<WordMeaningEntity?> runNotifierBuild(
    covariant WordMeaningNotifier notifier,
  ) {
    return notifier.build(word);
  }

  @override
  Override overrideWith(WordMeaningNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WordMeaningNotifierProvider._internal(
        () => create()..word = word,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        word: word,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    WordMeaningNotifier,
    WordMeaningEntity?
  >
  createElement() {
    return _WordMeaningNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WordMeaningNotifierProvider && other.word == word;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, word.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WordMeaningNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<WordMeaningEntity?> {
  /// The parameter `word` of this provider.
  String get word;
}

class _WordMeaningNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          WordMeaningNotifier,
          WordMeaningEntity?
        >
    with WordMeaningNotifierRef {
  _WordMeaningNotifierProviderElement(super.provider);

  @override
  String get word => (origin as WordMeaningNotifierProvider).word;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
