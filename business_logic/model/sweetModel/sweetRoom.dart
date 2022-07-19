class sweetRoom {
  sweetRoom({
    required this.id,
    required this.user1,
    required this.live1,
    required this.count,
    required this.audienceCount,
    required this.avatarUrl,
  });
  late final String? id;
  late final String? name;
  late final String? explain;
  late final String? user1;
  late final String? live1;
  late final String? avatarUrl;

  late final int count;
  late final int audienceCount;

  sweetRoom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    explain = json['explain'];
    user1 = json['user1'];
    live1 = json['live1'];
    count = json['count'];
    audienceCount = json['audienceCount'];
    avatarUrl = json['avatarUrl'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['explain'] = explain;
    _data['id'] = id;
    _data['user1'] = user1;
    _data['live1'] = live1;
    _data['count'] = count;
    _data['audienceCount'] = audienceCount;
    _data['avatarUrl'] = avatarUrl;

    return _data;
  }
}
