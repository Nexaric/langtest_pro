import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:langtest_pro/repo/report_problem/i_report_problem_facade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:langtest_pro/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportProblemImpl implements IReportProblemFacade {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<AppExceptions, Unit>> reportProblem({
    required String title,
    required String description,
    File? image,
  }) async {
    final uid = await Utils.getString('userId');
    try {
      if (image == null) {
        await supabase.from('report').upsert({
          "uid": uid,
          "title": title,
          "discription": description,
          "imagePath": "No image added",
        });
      } else {
        await supabase.storage
            .from('report')
            .upload("$uid${DateTime.now()}", image)
            .then((value) async {
              await supabase.from('report').upsert({
                "uid": uid,
                "title": title,
                "discription": description,
                "imagePath": value,
              });
            });
      }

      return right(unit);
    } catch (e) {
      print(e.toString());
      return left(AppExceptions(e.toString()));
    }
  }
}
