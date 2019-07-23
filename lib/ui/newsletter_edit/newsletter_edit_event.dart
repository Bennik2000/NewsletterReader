import 'package:newsletter_reader/model/model.dart';

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

class DeleteNewsletterEvent extends NewsletterEditEvent {}
