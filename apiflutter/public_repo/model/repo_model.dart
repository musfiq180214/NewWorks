// class Repo {
//   final int id;
//   final String name;
//   final String owner;
//   final String avatarUrl;

//   Repo({
//     required this.id,
//     required this.name,
//     required this.owner,
//     required this.avatarUrl,
//   });

//   factory Repo.fromJson(Map<String, dynamic> json) {
//     return Repo(
//       id: json['id'] as int,
//       name: json['name'] ?? 'Unknown',
//       owner: json['owner']?['login'] ?? 'Unknown',
//       avatarUrl:
//           json['owner']?['avatar_url'] ??
//           'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
//     );
//   }
// }
