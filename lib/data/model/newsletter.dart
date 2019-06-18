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
