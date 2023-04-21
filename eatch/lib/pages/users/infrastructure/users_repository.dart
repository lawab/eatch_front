import '../domain/user.dart';
import 'users_data.dart';

class EatchUsersRepository {
  EatchUsersRepository._();
  static EatchUsersRepository instance = EatchUsersRepository._();

  final List<EatchUser> _eatchUsers = eatchUsersData;

  List<EatchUser> getEatchUsersList() {
    return _eatchUsers;
  }
}

final eatchUsersList = EatchUsersRepository.instance.getEatchUsersList();
