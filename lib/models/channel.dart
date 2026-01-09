class Channel {
  final String? streamId;
  final String? name;
  final String? streamIcon;
  final String? categoryId;
  final String? epgChannelId;
  final String? added;
  final String? customSid;
  final String? tvArchive;
  final String? directSource;
  final String? tvArchiveDuration;

  Channel({
    this.streamId,
    this.name,
    this.streamIcon,
    this.categoryId,
    this.epgChannelId,
    this.added,
    this.customSid,
    this.tvArchive,
    this.directSource,
    this.tvArchiveDuration,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      streamId: json['stream_id']?.toString(),
      name: json['name']?.toString(),
      streamIcon: json['stream_icon']?.toString(),
      categoryId: json['category_id']?.toString(),
      epgChannelId: json['epg_channel_id']?.toString(),
      added: json['added']?.toString(),
      customSid: json['custom_sid']?.toString(),
      tvArchive: json['tv_archive']?.toString(),
      directSource: json['direct_source']?.toString(),
      tvArchiveDuration: json['tv_archive_duration']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stream_id': streamId,
      'name': name,
      'stream_icon': streamIcon,
      'category_id': categoryId,
      'epg_channel_id': epgChannelId,
      'added': added,
      'custom_sid': customSid,
      'tv_archive': tvArchive,
      'direct_source': directSource,
      'tv_archive_duration': tvArchiveDuration,
    };
  }
}
