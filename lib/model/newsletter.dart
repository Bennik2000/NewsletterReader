import 'dart:convert';

class Newsletter {
  int id;
  String name;
  UpdateStrategy updateStrategy;
  String url;
  UpdateInterval updateInterval;
  DateTime updateTime;
  DateTime lastUpdated;

  DeleteDownloadedBehavior deleteDownloadedBehavior;
  int maxDiskSpaceUntilDelete;
  Duration durationUntilDelete;

  Newsletter({
    this.id,
    this.name,
    this.updateStrategy,
    this.updateInterval,
    this.updateTime,
    this.lastUpdated,
    this.deleteDownloadedBehavior,
    this.maxDiskSpaceUntilDelete,
    this.durationUntilDelete,
    this.url,
  });
}

enum DeleteDownloadedBehavior { DiskSpace, Time, Manual }

enum UpdateInterval { Hourly, Daily, Weekly, Monthly, Manual }

enum UpdateStrategy { SameUrl, PatternUrl }

class NewsletterJsonHelper {
  static String toJson(Newsletter newsletter) {
    var map = {
      "id": newsletter.id,
      "name": newsletter.name,
      "updateStrategy": newsletter.updateStrategy?.index,
      "url": newsletter.url,
      "updateInterval": newsletter.updateInterval?.index,
      "updateTime": newsletter.updateTime?.millisecondsSinceEpoch,
      "lastUpdated": newsletter.lastUpdated?.millisecondsSinceEpoch,
      "deleteDownloadedBehavior": newsletter.deleteDownloadedBehavior?.index,
      "maxDiskSpaceUntilDelete": newsletter.maxDiskSpaceUntilDelete,
      "durationUntilDelete": newsletter.durationUntilDelete?.inMilliseconds,
    };

    return jsonEncode(map);
  }

  static Newsletter fromJson(String json) {
    var map = jsonDecode(json);

    return new Newsletter(
      id: map["id"],
      name: map["name"],
      url: map["url"],
      maxDiskSpaceUntilDelete: map["maxDiskSpaceUntilDelete"],
      updateStrategy: map["updateStrategy"] != null ? UpdateStrategy.values[map["updateStrategy"]] : null,
      updateInterval: map["updateInterval"] != null ? UpdateInterval.values[map["updateInterval"]] : null,
      deleteDownloadedBehavior:
          map["deleteDownloadedBehavior"] != null ? DeleteDownloadedBehavior.values[map["deleteDownloadedBehavior"]] : null,
      updateTime: map["updateTime"] != null ? DateTime.fromMillisecondsSinceEpoch(map["updateTime"]) : null,
      lastUpdated: map["lastUpdated"] != null ? DateTime.fromMillisecondsSinceEpoch(map["lastUpdated"]) : null,
      durationUntilDelete: map["durationUntilDelete"] != null ? Duration(milliseconds: map["durationUntilDelete"]) : null,
    );
  }
}
