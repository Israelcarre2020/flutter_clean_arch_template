import 'package:flutter/material.dart';
import 'package:gist/core/l10n/app_localizations.dart';
import 'package:gist/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';

/// Detail screen to show joke details
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, this.joke});
  final String? joke;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailScreen),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flutter Image with Hero animation
              Hero(
                tag: 'flutter_logo',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Assets.images.flutterImage.image(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.jokeDetails,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    joke ?? l10n.noJokeProvided,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.goBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
