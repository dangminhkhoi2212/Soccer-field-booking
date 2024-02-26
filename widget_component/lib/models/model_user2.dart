class UserModel2 {
  Id id;
  String name;
  String email;
  Avatar avatar;
  bool isPublic;
  Lock lock;
  String role;
  String refreshToken;
  String accessToken;
  AtedAt createdAt;
  AtedAt updatedAt;
  String phone;

  UserModel2({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.isPublic,
    required this.lock,
    required this.role,
    required this.refreshToken,
    required this.accessToken,
    required this.createdAt,
    required this.updatedAt,
    required this.phone,
  });
}

class Avatar {
  String url;

  Avatar({
    required this.url,
  });
}

class AtedAt {
  Date date;

  AtedAt({
    required this.date,
  });
}

class Date {
  String numberLong;

  Date({
    required this.numberLong,
  });
}

class Id {
  String oid;

  Id({
    required this.oid,
  });
}

class Lock {
  bool status;
  String content;

  Lock({
    required this.status,
    required this.content,
  });
}
