/*
 * Copyright (c) 2020 Robert Hjortsholm Moeller
 */

import 'package:h_utils/control_flow/conditions.dart';
import 'package:h_utils/control_flow/method.dart';
import 'package:h_utils/control_flow/optional.dart';
import 'package:h_utils/control_flow/predicate.dart';

class Switcher<I, O> {
  final Map<Predicate<I>, Method<I, O>> cases;
  final I value;

  Switcher.of(this.value) : cases = Map();

  Switcher<I, O> predicate(final Predicate<I> predicate, final Method<I, O> value) {
    return this..cases.putIfAbsent(predicate, () => value);
  }

  Switcher<I, O> key(final I key, final Method<I, O> value) {
    return this.predicate((value) => value == key, value);
  }

  Optional<O> consume() {
    MapEntry result = cases.entries.firstWhere((entry) => entry.key(value), orElse: () => null);
    return Optional.condition(notNull(result), result).map((entry) => entry.value(value));
  }

  O orElse(final O value) {
    return consume().orElseGet(value);
  }
}