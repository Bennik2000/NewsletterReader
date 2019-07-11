import 'package:bloc/bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletter_delete.dart';
import 'package:newsletter_reader/data/model/newsletter.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_event.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_state.dart';

class NewsletterEditBloc extends Bloc<NewsletterEditEvent, NewsletterEditState> {
  final Newsletter newsletter;
  final NewsletterRepository _newsletterRepository = kiwi.Container().resolve();
  final ArticleRepository _articleRepository = kiwi.Container().resolve();

  NewsletterEditErrorState errorState = new NewsletterEditErrorState();

  NewsletterEditBloc(this.newsletter);

  @override
  get initialState => NewsletterEditState(newsletter: newsletter, errorState: errorState);

  NewsletterEditState buildState() {
    return new NewsletterEditState(newsletter: newsletter, errorState: errorState);
  }

  @override
  Stream<NewsletterEditState> mapEventToState(NewsletterEditEvent event) async* {
    if (event is ChangeUpdateIntervalEvent) {
      yield* handleChangeUpdateIntervalEvent(event);
    }

    if (event is ChangeUpdateStrategyEvent) {
      yield* handleChangeUpdateStrategyEvent(event);
    }

    if (event is FinishEditNewsletterEvent) {
      yield* handleFinishEditEvent(event);
    }

    if (event is DeleteNewsletterEvent) {
      yield* handleDeleteEvent(event);
    }
  }

  Stream<NewsletterEditState> handleFinishEditEvent(FinishEditNewsletterEvent event) async* {
    errorState = validateForm(event);

    if (!errorState.hasError) {
      await _newsletterRepository.saveNewsletter(newsletter);

      yield new NewsletterEditFinishedState(newsletter: newsletter, errorState: errorState);
    } else {
      yield buildState();
    }
  }

  NewsletterEditErrorState validateForm(FinishEditNewsletterEvent event) {
    var error = new NewsletterEditErrorState();

    newsletter.name = event.name;
    if (newsletter.name?.trim()?.isEmpty ?? true) {
      error.nameError = "Der Name muss ausgefüllt sein!";
    }

    newsletter.url = event.url;
    if (newsletter.url?.trim()?.isEmpty ?? true) {
      error.urlError = "Die URL muss ausgefüllt sein!";
    }

    if (newsletter.updateStrategy == null) {
      error.updateStrategyError = "Es muss eine Update Strategie ausgewählt werden!";
    }

    if (newsletter.updateInterval == null) {
      error.updateIntervalError = "Es muss ein Update Interval ausgewählt werden!";
    }

    return error;
  }

  Stream<NewsletterEditState> handleChangeUpdateStrategyEvent(ChangeUpdateStrategyEvent event) async* {
    newsletter.updateStrategy = event.newUpdateStrategy;
    yield buildState();
  }

  Stream<NewsletterEditState> handleChangeUpdateIntervalEvent(ChangeUpdateIntervalEvent event) async* {
    newsletter.updateInterval = event.newUpdateInterval;
    yield buildState();
  }

  Stream<NewsletterEditState> handleDeleteEvent(DeleteNewsletterEvent event) async* {
    await new NewsletterDelete(newsletter, _newsletterRepository, _articleRepository).deleteNewsletter();

    yield new NewsletterEditFinishedState(newsletter: newsletter, errorState: errorState);
  }
}
