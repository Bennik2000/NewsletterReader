class Article {
  int id;
  int newsletterId;
  DateTime releaseDate;
  DateTime downloadDate;
  String sourceUrl;
  String storagePath;
  String originalFilename;
  String thumbnailPath;
  String documentEtag;

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
    this.documentEtag
  });
}
