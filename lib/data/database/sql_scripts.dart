import 'dart:core';

class SqlScripts {
  static final databaseMigrationScripts = [
    // Version 1 - init database
    ['''
CREATE TABLE IF NOT EXISTS Articles
(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  newsletterId INTEGER,
  releaseDate INTEGER,
  downloadDate INTEGER,
  sourceUrl TEXT,
  storagePath TEXT,
  originalFilename TEXT,
  isDownloaded BOOL,
  thumbnailPath TEXT
);
''',
      '''
CREATE TABLE IF NOT EXISTS Newsletters
(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  maxDiskSpaceUntilDelete INTEGER,
  deleteDownloadedBehavior INTEGER,
  durationUntilDelete INTEGER,
  updateInterval INTEGER,
  updateTime INTEGER,
  updateStrategy INTEGER,
  isAutoUpdateEnabled BOOL,
  isAutoDownloadEnabled BOOL,
  url INTEGER,
  lastUpdated INTEGER
);
'''],

    // Version 2
    ['''ALTER TABLE Articles ADD COLUMN etag TEXT default null;'''],
  ];
}

