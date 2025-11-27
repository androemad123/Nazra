import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:nazra/peresentation/resources/styles_manager.dart';
import 'package:nazra/peresentation/resources/color_manager.dart';

import '../../app/bloc/community/community_bloc.dart';
import '../../app/bloc/community/community_event.dart';
import '../../app/bloc/community/community_state.dart';
import '../../app/bloc/issue/issue_bloc.dart';
import '../../app/bloc/issue/issue_event.dart';
import '../../app/bloc/issue/issue_state.dart';
import '../../app/models/community.dart';
import '../../app/repositories/community_repository.dart';
import '../../app/repositories/issue_repository.dart';
import '../widgets/app_text_btn.dart';
import '../widgets/issue_card.dart';
import 'add_issue_screen.dart';
import 'issue_details_screen.dart';
import 'join_request_screen.dart';
import 'community_members_screen.dart';

class CommunityDetailsScreen extends StatelessWidget {
  final String communityId;
  const CommunityDetailsScreen({super.key, required this.communityId});

  @override
  Widget build(BuildContext context) {
    final communityRepo = CommunityRepository();
    final issueRepo = IssueRepository();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CommunityBloc(repo: communityRepo),
        ),
        BlocProvider(
          create: (_) => IssueBloc(repo: issueRepo)..add(LoadCommunityIssues(communityId)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CommunityBloc, CommunityState>(
            listener: (context, state) {
              if (state.status == CommunityStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );
              }
            },
          ),
          BlocListener<IssueBloc, IssueState>(
            listener: (context, state) {
              if (state.status == IssueStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading issues: ${state.error}')),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(title: const Text('Community')),
          floatingActionButton: BlocBuilder<CommunityBloc, CommunityState>(
            builder: (context, state) {
              // We need to check membership to show FAB
              // Since we are using StreamBuilder for community data, we might need to access it differently
              // or just rely on the fact that non-members can't add issues anyway (backend rule)
              // But for UI UX, let's try to show it only if member.
              // However, the StreamBuilder is inside the body.
              // Let's use a nested Builder or move StreamBuilder up if possible,
              // or just show it and let the user handle the "not member" case or check inside onPressed.
              // For now, let's show it.
              return FloatingActionButton(
                onPressed: () {
                  if (currentUserId.isEmpty) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login to add an issue')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<IssueBloc>(),
                        child: AddIssueScreen(communityId: communityId),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              );
            }
          ),
          body: StreamBuilder<Community?>(
            stream: communityRepo.watchCommunity(communityId),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final community = snap.data!;
              final isOwner = community.ownerId == currentUserId;
              final isMember = community.members.contains(currentUserId);

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  community.name,
                                  style: semiBoldStyle(
                                    fontSize: 28,
                                    color: ColorManager.darkBrown,
                                  ),
                                ),
                              ),
                              if (isOwner)
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => JoinRequestsScreen(
                                            communityId: community.id),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.people_alt_rounded),
                                  color: ColorManager.brown,
                                  tooltip: 'Manage join requests',
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            community.description,
                            style: regularStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManager.lighterBeige,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CommunityMembersScreen(
                                            communityId: community.id),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.group,
                                        size: 18,
                                        color: ColorManager.brown,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${community.members.length} members',
                                        style: semiBoldStyle(
                                          fontSize: 14,
                                          color: ColorManager.brown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (!isMember)
                                ElevatedButton(
                                  onPressed: () {
                                    if (currentUserId.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Please login to join')),
                                      );
                                      return;
                                    }
                                    context.read<CommunityBloc>().add(
                                          RequestJoinCommunity(
                                              community.id, currentUserId),
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Request sent')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorManager.brown,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(
                                    'Request to join',
                                    style: semiBoldStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Text(
                        "Community Issues",
                        style: semiBoldStyle(
                          fontSize: 20,
                          color: ColorManager.darkBrown,
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<IssueBloc, IssueState>(
                    builder: (context, state) {
                      if (state.status == IssueStatus.loading) {
                        return const SliverToBoxAdapter(
                          child: Center(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          )),
                        );
                      }

                      if (state.issues.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 64,
                                    color: ColorManager.lightGray,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No issues yet',
                                    style: semiBoldStyle(fontSize: 18, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Be the first to report an issue',
                                    style: regularStyle(
                                      fontSize: 14,
                                      color: ColorManager.lightGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final issue = state.issues[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                              child: IssueCard(
                                issue: issue,
                                hasUserVoted: issue.hasUserVoted(currentUserId),
                                onVote: () {
                                  if (issue.hasUserVoted(currentUserId)) {
                                    context.read<IssueBloc>().add(UnvoteIssueRequested(issue.id));
                                  } else {
                                    context.read<IssueBloc>().add(VoteIssueRequested(issue.id));
                                  }
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => IssueDetailsScreen(issueId: issue.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          childCount: state.issues.length,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
