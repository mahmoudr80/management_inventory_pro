class DropdownItem<T> {
  final T id;
  final String label;

  const DropdownItem({
    required this.id,
    required this.label,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DropdownItem<T> &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}