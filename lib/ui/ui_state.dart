import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';

class UiState {
  static final projectShowArchived = StateProvider<bool>((ref) => false);
  static final boardShowArchived = StateProvider<bool>((ref) => false);
  // static final boardShowArchivedStreamCtller = StreamController.broadcast(sync: true);
  // static final boardRefresh = StateProvider<bool>((ref) => false);
  static final boardEditing = StateProvider<bool>((ref) => false);
  static final boardActiveText = StateProvider<String>((ref) => "");
  static final boardActiveIdx = StateProvider<int>((ref) => 0);
  static final boardActiveState = StateProvider<GlobalKey<EditableState>?>((ref) => null);
  static final boardActions = StateProvider<Iterable<int>>((ref) => []);
}