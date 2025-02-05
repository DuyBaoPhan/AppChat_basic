import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tweet_app/src/features/tweet/models/tweet_request_model.dart';
import 'package:tweet_app/src/features/tweet/models/user_request_model.dart';
import 'package:tweet_app/src/features/tweet/services/get_like_information_service.dart';
import 'package:tweet_app/src/features/tweet/store/profile_store.dart';
import 'package:tweet_app/src/features/tweet/ui/components/mini_tweet_widget.dart';
import 'package:tweet_app/src/features/tweet/ui/components/profile_banner.dart';

class ProfileScreen extends StatefulWidget {
  final String uidOwnerProfile;
  final String uidVisitor;
  const ProfileScreen(
      {super.key, required this.uidOwnerProfile, required this.uidVisitor});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileStore profileStore;

  @override
  void initState() {
    profileStore = Modular.get<ProfileStore>();
    profileStore.loadInformation(
        uidProfileOwner: widget.uidOwnerProfile, uidVisitor: widget.uidVisitor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Modular.to.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => profileStore.loadInformation(
            uidProfileOwner: widget.uidOwnerProfile,
            uidVisitor: widget.uidVisitor),
        child: Observer(
          builder: (_) {
            switch (profileStore.profileScreenState) {
              case ProfileScreenState.error:
                return Center(
                  child: Text(profileStore.errorMessage!),
                );
              case ProfileScreenState.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ProfileScreenState.loaded:
                UserRequestModel profileOwner = profileStore.profileOwner;
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ProfileBanner(
                        imageBanner: Image.network(profileOwner.bannerPhoto),
                        imageAvatar: Image.network(profileOwner.iconPhoto),
                        identifier: profileOwner.identifier,
                        followingQuantity: profileStore.followingAmount,
                        followersQuantity: profileStore.followersAmount,
                        isFollowing: profileStore.isFollowing,
                        followButtonFunction: () => profileStore
                            .buttonFollowAction(uid: widget.uidVisitor),
                      ),
                    ),
                    SliverList.builder(
                      itemCount: profileStore.tweetList.length,
                      itemBuilder: (context, index) {
                        TweetRequestModel currentTweet =
                            profileStore.tweetList.elementAt(index);
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                              child: MiniTweetWidget(
                                identifier: profileOwner.identifier,
                                text: currentTweet.text,
                                isAlreadyLiked: GetLikeInformationService()
                                    .isTweetLikedByAUser(
                                        userUidListWhoLiked:
                                            currentTweet.likesUidUsers,
                                        uidAuth: widget.uidVisitor),
                                commentsQuantity:
                                    currentTweet.commentDocNames.length,
                                likesQuantity: currentTweet.likesValue,
                                profileImageUrl: profileOwner.iconPhoto,
                                idTweet: currentTweet.docName,
                                uidLikeOwner: widget.uidVisitor,
                                uidTweetOwner: profileOwner.uidAuth,
                                imagesUrls: currentTweet.images,
                              ),
                            ),
                            const Divider(
                              thickness: 1.5,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
