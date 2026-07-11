part of 'sidebar_cubit.dart';

@immutable
class SidebarState {
  final bool expanded;

  const SidebarState({required this.expanded});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SidebarState && other.expanded == expanded);

  @override
  int get hashCode => expanded.hashCode;
}