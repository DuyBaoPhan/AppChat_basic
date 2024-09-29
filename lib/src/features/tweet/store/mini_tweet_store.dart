import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:tweet_app/src/features/tweet/services/tweet_repository_firestore.dart';

part 'mini_tweet_store.g.dart';

class MiniTweetStore = _MiniTweetStore with _$MiniTweetStore;

abstract class _MiniTweetStore with Store {
  final String docNameTweet;
  final String uidTweetOwner;
  final String uidLikeOwner;
  final TweetRepositoryFirestore tweetRepositoryFirestore;

  _MiniTweetStore({
    required this.uidLikeOwner,
    required this.uidTweetOwner,
    required this.docNameTweet,
    required this.isLiked,
    required this.tweetRepositoryFirestore,
    required this.likesQuantity,
  })  : iconLikeColor = isLiked ? Colors.red : null,
        icon = isLiked ? Icons.favorite : Icons.favorite_border;

  @observable
  int likesQuantity;

  @observable
  bool isLiked;

  @observable
  Color? iconLikeColor;

  @observable
  IconData icon;

  @action
  tapLikeAction() {
    tweetRepositoryFirestore
        .alterLikesValueTweet(
        docNameTweet: docNameTweet,
        uidTweetOwner: uidTweetOwner,
        uidLikeOwner: uidLikeOwner,
        isIncrement: !isLiked)
        .then((value) {
      if (!isLiked) {
        likesQuantity++;
        iconLikeColor = Colors.red;
        icon = Icons.favorite;
      } else {
        likesQuantity--;
        iconLikeColor = null;
        icon = Icons.favorite_border;
      }
      isLiked = !isLiked;
    });
  }
}
