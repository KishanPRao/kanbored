import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/app_theme.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/project_model.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProjectModel> projects = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var projects = await Api.getmyProjects();
    setState(() {
      this.projects = projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: context.theme.appColors.primary,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, routeSettings).then((value) {
                if (value is bool && value) {
                  Navigator.pushNamed(context, routeLogin);
                }
              });
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: projects
            .map((project) => Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                      splashColor:
                          context.theme.appColors.primary.withAlpha(30),
                      onTap: () {},
                      child: SizedBox(
                        child: Center(child: Text(project.name)),
                      )),
                ))
            .toList(),
      ),
    );
  }
}
