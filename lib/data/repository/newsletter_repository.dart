import 'package:newsletter_reader/data/database/database_access.dart';
import 'package:newsletter_reader/data/database/entity/newsletter_entity.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterRepository {
  final DatabaseAccess _database;

  NewsletterRepository(this._database);

  Future<List<Newsletter>> queryNewsletters() async {
    var rows = await _database.queryAllRows(NewsletterEntity.tableName());
    var newsletters = new List<Newsletter>();

    for (var row in rows) {
      newsletters.add(new NewsletterEntity.fromMap(row).asNewsletter());
    }

    return newsletters;
  }

  Future saveNewsletter(Newsletter newsletter) async {
    var row = new NewsletterEntity.fromModel(newsletter).toMap();

    if (newsletter.id == null) {
      var id = await _database.insert(NewsletterEntity.tableName(), row);
      newsletter.id = id;
    } else {
      await _database.update(NewsletterEntity.tableName(), row);
    }
  }

  Future deleteNewsletter(Newsletter newsletter) async {
    await _database.delete(NewsletterEntity.tableName(), newsletter.id);
  }
}
