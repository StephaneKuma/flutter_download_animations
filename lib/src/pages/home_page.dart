import 'package:flutter/material.dart';

import '../contracts/download_controller.dart';
import '../services/simulated_download_controller.dart';
import '../widgets/app_icon.dart';
import '../widgets/download_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<DownloadController> _downloadControllers;

  @override
  void initState() {
    super.initState();

    _downloadControllers = List<DownloadController>.generate(
      20,
      (index) => SimulatedDownloadController(
        onOpenDownload: () {
          _openDownload(index);
        },
      ),
    );
  }

  void _openDownload(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open App ${index + 1}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Apps'),
        ),
        body: ListView.separated(
          itemBuilder: _buildItemList,
          separatorBuilder: (_, __) => const Divider(),
          itemCount: _downloadControllers.length,
        ),
      );

  Widget _buildItemList(BuildContext context, int index) {
    final theme = Theme.of(context);
    final downloadController = _downloadControllers[index];

    return ListTile(
      leading: const AppIcon(),
      title: Text(
        'App ${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.headline6,
      ),
      subtitle: Text(
        'Lorem ipsum dolor #${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.caption,
      ),
      trailing: SizedBox(
        width: 96,
        child: AnimatedBuilder(
          animation: downloadController,
          builder: (context, child) {
            return DownloadButton(
              status: downloadController.downloadStatus,
              downloadProgress: downloadController.progress,
              onDownload: downloadController.startDownload,
              onCancel: downloadController.stopDownload,
              onOpen: downloadController.openDownload,
            );
          },
        ),
      ),
    );
  }
}
