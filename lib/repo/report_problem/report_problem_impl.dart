import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
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
  required File image,
}) async {
  final uid = Utils.getString('uid');
  try {
    await supabase.storage.from('report').upload('images', image).then((value){
      print(value);
    });
    return right(unit);
  } catch (e) {
    print("error on supabase image addding");
    return left(AppExceptions(e.toString()));
  }
}

}
