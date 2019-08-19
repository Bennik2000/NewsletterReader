import 'package:newsletter_reader/data/database/entity/database_entity.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterEntity extends DatabaseEntity {
  Newsletter _newsletter;

  NewsletterEntity() {
    _newsletter = new Newsletter();
  }

  NewsletterEntity.fromModel(Newsletter newsletter) {
    _newsletter = newsletter;
  }

  NewsletterEntity.fromMap(dynamic map) {
    fromMap(map);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    var deleteDownloadedBehavior;
    if (map["deleteDownloadedBehavior"] != null) {
      deleteDownloadedBehavior = DeleteDownloadedBehavior.values[map["deleteDownloadedBehavior"]];
    }

    var durationUntilDelete;
    if (map["durationUntilDelete"] != null) {
      durationUntilDelete = new Duration(milliseconds: map["durationUntilDelete"]);
    }

    var updateInterval;
    if (map["updateInterval"] != null) {
      updateInterval = UpdateInterval.values[map["updateInterval"]];
    }

    var updateStrategy;
    if (map["updateStrategy"] != null) {
      updateStrategy = UpdateStrategy.values[map["updateStrategy"]];
    }

    var updateTime;
    if (map["updateTime"] != null) {
      updateTime = new DateTime.fromMillisecondsSinceEpoch(map["updateTime"]);
    }

    var lastUpdated;
    if (map["lastUpdated"] != null) {
      lastUpdated = new DateTime.fromMillisecondsSinceEpoch(map["lastUpdated"]);
    }

    _newsletter = new Newsletter(
      id: map["id"],
      name: map["name"],
      url: map["url"],
      maxDiskSpaceUntilDelete: map["maxDiskSpaceUntilDelete"],
      isAutoDownloadEnabled: map["isAutoDownloadEnabled"] == 1,
      isAutoUpdateEnabled: map["isAutoUpdateEnabled"] == 1,
      deleteDownloadedBehavior: deleteDownloadedBehavior,
      durationUntilDelete: durationUntilDelete,
      updateInterval: updateInterval,
      updateTime: updateTime,
      updateStrategy: updateStrategy,
      lastUpdated: lastUpdated,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _newsletter.id,
      "name": _newsletter.name,
      "maxDiskSpaceUntilDelete": _newsletter.maxDiskSpaceUntilDelete,
      "isAutoDownloadEnabled": _newsletter.isAutoDownloadEnabled,
      "isAutoUpdateEnabled": _newsletter.isAutoUpdateEnabled,
      "deleteDownloadedBehavior": _newsletter.deleteDownloadedBehavior?.index,
      "durationUntilDelete": _newsletter.durationUntilDelete?.inMilliseconds,
      "updateInterval": _newsletter.updateInterval?.index,
      "updateTime": _newsletter.updateTime?.millisecondsSinceEpoch,
      "lastUpdated": _newsletter.lastUpdated?.millisecondsSinceEpoch,
      "updateStrategy": _newsletter.updateStrategy?.index,
      "url": _newsletter.url,
    };
  }

  Newsletter asNewsletter() => _newsletter;

  static String createStatement() {
    return "CREATE TABLE IF NOT EXISTS " +
        tableName() +
        " ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "name TEXT,"
            "maxDiskSpaceUntilDelete INTEGER,"
            "deleteDownloadedBehavior INTEGER,"
            "durationUntilDelete INTEGER,"
            "updateInterval INTEGER,"
            "updateTime INTEGER,"
            "updateStrategy INTEGER,"
            "isAutoUpdateEnabled BOOL,"
            "isAutoDownloadEnabled BOOL,"
            "url INTEGER,"
            "lastUpdated INTEGER"
            ")";
  }

  static String tableName() {
    return "Newsletters";
  }
}
