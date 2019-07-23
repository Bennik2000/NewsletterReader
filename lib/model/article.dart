class Article {
  int id;
  int newsletterId;
  DateTime releaseDate;
  DateTime downloadDate;
  String sourceUrl;
  String storagePath;
  String originalFilename;
  String thumbnailPath;

  bool isDownloaded;

  Article({
    this.id,
    this.newsletterId,
    this.releaseDate,
    this.downloadDate,
    this.sourceUrl,
    this.storagePath,
    this.originalFilename,
    this.thumbnailPath,
    this.isDownloaded,
  });
}
