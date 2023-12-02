import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  User({this.name});
  int id = 0;
  String? name;
}
