import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_app/model/node_model.dart';
import 'package:shoes_app/providers/node_providers.dart';
import 'package:shoes_app/theme/const.dart';
import 'package:shoes_app/widgets/node_tile.dart';

class NodePage extends StatefulWidget {
  const NodePage({super.key});

  @override
  State<NodePage> createState() => _NodePageState();
}

class _NodePageState extends State<NodePage> {
  late NodeProvider nodeProvider;

  @override
  void initState() {
    super.initState();
    Provider.of<NodeProvider>(context, listen: false).setShouldPollVM(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Simpan referensi provider
    nodeProvider = Provider.of<NodeProvider>(context, listen: false);
    // Mulai polling VM
    nodeProvider.setShouldPollVM(true);
  }

  @override
  void dispose() {
    nodeProvider.setShouldPollVM(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'List Node',
          style: primaryTextStyle,
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      );
    }

    Widget content(BuildContext context, List<NodeModel> nodeList) {
      return Container(
        color: bg3Color,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          children: nodeList
              .map(
                (nodes) => NodeTile(nodes),
              )
              .toList(),
        ),
      );
    }

    return Builder(builder: (BuildContext builderContext) {
      return Scaffold(
        appBar: header(),
        body: StreamBuilder<List<NodeModel>>(
          stream: Provider.of<NodeProvider>(context, listen: false).vmStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<NodeModel> nodeList = snapshot.data!;
              return content(context, nodeList);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    });
  }
}
