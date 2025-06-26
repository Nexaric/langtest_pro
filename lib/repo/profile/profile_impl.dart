import 'package:langtest_pro/model/userData_model.dart';
import 'package:langtest_pro/repo/profile/i_profilefacade.dart';
import 'package:langtest_pro/utils/app_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';

class ProfileImpl implements IProfilefacade {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<AppExceptions, UserData>> getProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return left(AppExceptions("User not logged in"));
      }

      final response = await supabase
          .from('users')
          .select()
          .eq('uid', user.id)
          .single();

      final data = response;

      return right(UserData.fromJson(data));
    } catch (e) {
      return left(AppExceptions(e.toString()));
    }
  }
  
  @override
  Future<Either<AppExceptions, Unit>> updateProfile({required UserData userData}) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return left(AppExceptions("User not logged in"));
      }

      final updateData = {
        'first_name': userData.firstName,
        'last_name': userData.lastName,
        'dob': userData.dob,
        'gender': userData.gender,
        'email': userData.email,
        'role': userData.role,
        'isCompleted': userData.isCompleted,
        // don't update uid or created_at
      };

      await supabase
          .from('users')
          .update(updateData)
          .eq('uid', user.id);

      return right(unit);
    } catch (e) {
      return left(AppExceptions(e.toString()));
    }
  }
}
