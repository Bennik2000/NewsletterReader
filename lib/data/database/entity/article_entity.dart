import 'package:newsletter_reader/data/database/entity/database_entity.dart';
import 'package:newsletter_reader/model/model.dart';

class ArticleEntity extends DatabaseEntity {
  Article _article;

  ArticleEntity() {
    _article = new Article();
  }

  ArticleEntity.fromModel(Article article) {
    _article = article;
  }

  ArticleEntity.fromMap(Map<String, dynamic> map) {
    fromMap(map);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    var releaseDate;
    if (map["releaseDate"] != null) {
      releaseDate = DateTime.fromMillisecondsSinceEpoch(map["releaseDate"]);
    }

    var downloadDate;
    if (map["downloadDate"] != null) {
      downloadDate = DateTime.fromMillisecondsSinceEpoch(map["downloadDate"]);
    }

    _article = new Article(
      id: map["id"],
      newsletterId: map["newsletterId"],
      downloadDate: downloadDate,
      isDownloaded: map["isDownloaded"] == 1,
      originalFilename: map["originalFilename"],
      releaseDate: releaseDate,
      sourceUrl: map["sourceUrl"],
      storagePath: map["storagePath"],
      thumbnailPath: map["thumbnailPath"],
      documentEtag: map["etag"]
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": _article.id,
      "newsletterId": _article.newsletterId,
      "releaseDate": _article.releaseDate?.millisecondsSinceEpoch,
      "downloadDate": _article.downloadDate?.millisecondsSinceEpoch,
      "sourceUrl": _article.sourceUrl,
      "storagePath": _article.storagePath,
      "originalFilename": _article.originalFilename,
      "isDownloaded": _article.isDownloaded,
      "thumbnailPath": _article.thumbnailPath,
      "etag": _article.documentEtag
    };
  }

  Article asArticle() => _article;

  static String tableName() => "Articles";
}
