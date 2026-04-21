/// Server may send snake_case or camelCase for optional keys.
class NotificationDto {
  const NotificationDto({
    required this.id,
    required this.title,
    this.body,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? body;
  final bool read;
  final String createdAt;

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      read: (json['is_read'] ?? json['read'] ?? false) as bool,
      createdAt: (json['created_at'] ?? json['createdAt'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'is_read': read,
        'created_at': createdAt,
      };
}
