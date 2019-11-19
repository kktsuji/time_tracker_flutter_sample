import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
import 'package:flutter/services.dart';

class JobsPage extends StatelessWidget {
//  HomePage({@required this.auth});
//  HomePage({@required this.auth, @required this.onSignOut});
//  final VoidCallback onSignOut;
//  final AuthBase auth;

  Future<void> _signOut(BuildContext context) async {
    try {
//      final auth = AuthProvider.of(context);
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
//      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

//
//  Future<void> _createJob(BuildContext context) async {
//    try {
//      final database = Provider.of<Database>(context);
//      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Operation failed',
//        exception: e,
//      ).show(context);
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    // TODO: tmp
//    final database = Provider.of<Database>(context);
//    database.readStream();
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                )),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditJobPage.show(context),
        //onPressed: () => _createJob(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) =>JobListTile(
            job: job,
            onTap: () => EditJobPage.show(context, job: job),
          ),
        );
//        if (snapshot.hasData) {
//          final jobs = snapshot.data;
//          if (jobs.isNotEmpty) {
////          final children = jobs.map((job) => Text(job.name)).toList();
//            final children = jobs
//                .map((job) =>
//                JobListTile(
//                  job: job,
//                  onTap: () => EditJobPage.show(context, job: job),
//                ))
//                .toList();
//            return ListView(children: children);
//          }
//          return EmptyContent();
//        }
//        if (snapshot.hasError) {
//          return Center(child: Text('some error occurred'));
//        }
//        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
