import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies/Models/moviesdetailsModel.dart';

class FirebaseFunctions {
  static CollectionReference<MoviesdetailsModel> getMovieCollection() {
    return FirebaseFirestore.instance.collection("Movies")
        .withConverter<MoviesdetailsModel>(
        fromFirestore: (snapshot, options) {
          return MoviesdetailsModel.fromJson(snapshot.data()!);
        },
        toFirestore: (movie, options) {
          return movie.toJson();
        }
    );
  }

  static Future<void> addMovieToWishlist(MoviesdetailsModel movie) {
    var collection = getMovieCollection();
    var docRef = collection.doc(movie.id.toString());
    return docRef.set(movie);
  }


  static Stream<QuerySnapshot<MoviesdetailsModel>> getMovies() {
    var collection = getMovieCollection();
    return collection.snapshots();
  }

  static Future<void> deleteMovieFromWishlist(String id) {
    return getMovieCollection().doc(id).delete();
  }

  static Future<void> updateMovieInWishlist(MoviesdetailsModel movie) {
    return getMovieCollection().doc(movie.id.toString()).update(movie.toJson());
  }
  static Future<bool> isMovieInWishlist(String id) async {
    var doc = await getMovieCollection().doc(id).get();
    return doc.exists;
  }


}
