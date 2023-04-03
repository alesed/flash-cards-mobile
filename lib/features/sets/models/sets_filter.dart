import 'package:flashcards/features/sets/models/accessibility.dart';

class SetsFilter {
  final Accessibility? accessibility;
  final bool justOwn;

  const SetsFilter({this.accessibility, required this.justOwn});
}
