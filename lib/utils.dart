import 'package:collection/collection.dart';

Iterable<String> filterErrors<K>(Iterable<K> fields, Map<K, String> errors) =>
    errors.entries
        .where((entry) => fields.contains(entry.key))
        .map((entry) => entry.value);

IterableEquality fieldsComparator = const IterableEquality();
