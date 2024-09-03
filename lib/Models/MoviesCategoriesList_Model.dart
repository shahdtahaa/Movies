class MoviesCategoriesListModel {
  MoviesCategoriesListModel({
      List<Genres>? genres,}){
    _genres = genres;
}

  MoviesCategoriesListModel.fromJson(dynamic json) {
    if (json['genres'] != null) {
      _genres = [];
      json['genres'].forEach((v) {
        _genres?.add(Genres.fromJson(v));
      });
    }
  }
  List<Genres>? _genres;

  List<Genres>? get genres => _genres;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_genres != null) {
      map['genres'] = _genres?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Genres {
  Genres({
      int? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Genres.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  int? _id;
  String? _name;

  int? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}