import 'package:bloc/bloc.dart';
import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/data/network/same_url_article_searcher.dart';
import 'package:newsletter_reader/data/repository/ArticleRepository.dart';

class LoadArticlesBloc extends Bloc<LoadArticlesEvent, LoadArticlesState> {
  final ArticleRepository _articlesRepository;
  final Newsletter _newsletter;

  LoadArticlesBloc(this._newsletter, this._articlesRepository);

  @override
  LoadArticlesState get initialState => new LoadArticlesState.initial();

  @override
  Stream<LoadArticlesState> mapEventToState(LoadArticlesEvent event) async* {
    if (event is DoLoadArticlesEvent) {
      yield new LoadArticlesState.loading();

      var articles = await _articlesRepository.queryArticlesOfNewsletter(_newsletter.id);

      yield new LoadArticlesState.loaded(articles);
    } else if (event is UpdateArticlesEvent) {
      yield new LoadArticlesState.updating();

      try {
        var articles = await new SameUrlArticleSearcher(_newsletter).fetchNewArticles();

        yield new LoadArticlesState.loaded(articles);
      } on Exception catch (e) {
        print(e);
        yield new LoadArticlesState.error();
      }
    }
  }
}

class LoadArticlesEvent {}

class DoLoadArticlesEvent extends LoadArticlesEvent {}

class UpdateArticlesEvent extends LoadArticlesEvent {}

class LoadArticlesState {
  final bool isLoading;
  final bool isUpdating;
  final bool isLoaded;
  final String error;
  final bool hasError;
  final List<Article> loadedArticles;

  LoadArticlesState.initial()
      : isLoaded = false,
        isLoading = false,
        isUpdating = false,
        hasError = false,
        error = null,
        loadedArticles = new List();

  LoadArticlesState.loading()
      : isLoading = true,
        isLoaded = false,
        isUpdating = false,
        hasError = false,
        error = null,
        loadedArticles = new List();

  LoadArticlesState.loaded(this.loadedArticles)
      : isLoaded = true,
        isUpdating = false,
        isLoading = false,
        hasError = false,
        error = null;

  LoadArticlesState.updating()
      : isLoaded = true,
        isUpdating = true,
        isLoading = false,
        hasError = false,
        error = null,
        loadedArticles = new List();

  LoadArticlesState.error()
      : isLoaded = false,
        isUpdating = false,
        isLoading = false,
        hasError = true,
        error = "Failed to fetch articles",
        loadedArticles = new List();
}
