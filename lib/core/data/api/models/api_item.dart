class ApiItem {
  final String id;
  final String parentId;
  final String name;
  final int? order;

  ApiItem({
    required this.id,
    required this.parentId,
    required this.name,
    this.order,
  });

  factory ApiItem.fromMap(Map<String, dynamic> map) {
    return ApiItem(
      id: map['indicator_to_mo_id'].toString(),
      parentId: map['parent_id'].toString(),
      name: map['name'] ?? '',
      order: map['order'],
    );
  }
}
