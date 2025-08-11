import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:langtest_pro/repo/report_problem/i_report_problem_facade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportProblemImpl implements IReportProblemFacade {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<AppExceptions, Unit>> reportProblem({
    required String title,
    required String description,
    File? image,
  }) async {
    final uid = supabase.auth.currentUser?.id;
    debugPrint("hwllo");
    debugPrint(uid);
    try {
      if (uid != null) {
        if (image == null) {
          await supabase.from('report').upsert({
            "uid": uid,
            "title": title,
            "description": description,
            "imagepath": "No image added",
          });
        } else {
          await supabase.storage
              .from('report')
              .upload("$uid${DateTime.now()}", image)
              .then((value) async {
                await supabase.from('report').upsert({
                  "uid": uid,
                  "title": title,
                  "description": description,
                  "imagepath": value,
                });
              });
        }

        return right(unit);
      }
      else{
        return left(NoUserFound());
      }
    } catch (e) {
      debugPrint(e.toString());
      return left(AppExceptions(e.toString()));
    }
  }
}
