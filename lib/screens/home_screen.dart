import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animations.dart';
import '../widgets/avatar.dart';
import '../widgets/chat_tile.dart';
import 'chat_screen.dart';
import 'new_chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Chat> _chats = [];
  bool _loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(
        const Duration(seconds: 4), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    final me = AuthService.currentUser;
    if (me == null) return;
    try {
      final chats = await ApiService.getChats(me.id);
      if (mounted) setState(() {
            _chats = chats;
            _loading = false;
          });
    } catch (_) {
      if (mounted && !silent) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final me = AuthService.currentUser;
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 4,
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const NewChatScreen()));
          _load();
        },
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text('ChatWave',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration:
                    const BoxDecoration(gradient: AppColors.primaryGradient),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (v) {
                  if (v == 'logout') _logout();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(children: [
                      GradientAvatar(
                          initials: me?.initials ?? '?',
                          seed: me?.id ?? 0,
                          size: 34),
                      const SizedBox(width: 10),
                      Flexible(child: Text(me?.name ?? '')),
                    ]),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ],
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary))
            : _chats.isEmpty
                ? _emptyState()
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _load,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 6, bottom: 90),
                      itemCount: _chats.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(left: 84),
                        child: Divider(
                            height: 1,
                            color: Colors.grey.withOpacity(0.15)),
                      ),
                      itemBuilder: (context, i) {
                        final chat = _chats[i];
                        return FadeSlideIn(
                          delayMs: i * 60,
                          child: ChatTile(
                            chat: chat,
                            onTap: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ChatScreen(peerId: chat.id, peerName: chat.name)));
                              _load();
                            },
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_bubble_outline_rounded,
                  size: 56, color: AppColors.primary),
            ),
            const SizedBox(height: 22),
            const Text('Abhi koi chat nahi',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text('Neeche wale button se nayi chat shuru karein',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}
