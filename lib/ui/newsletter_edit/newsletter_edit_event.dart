import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/data/model/newsletter.dart';

class NewsletterEditEvent {}

class ChangeUpdateIntervalEvent extends NewsletterEditEvent {
  final UpdateInterval newUpdateInterval;
  ChangeUpdateIntervalEvent(this.newUpdateInterval);
}

class ChangeUpdateStrategyEvent extends NewsletterEditEvent {
  final UpdateStrategy newUpdateStrategy;
  ChangeUpdateStrategyEvent(this.newUpdateStrategy);
}

class FinishEditNewsletterEvent extends NewsletterEditEvent {
  final String name;
  final String url;

  FinishEditNewsletterEvent(this.name, this.url);
}
