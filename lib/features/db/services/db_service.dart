import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/features/db/models/collection.dart';

class DbService {
  final db = FirebaseFirestore.instance;

  Future<void> add(
      Collection collection, String id, Map<String, dynamic> data) {
    return db.collection(collection.name).doc(id).set(data);
  }

  Stream<List<Map<String, dynamic>>> getCollectionStream(
      Collection collection) {
    //TODO: some filter?
    return db
        .collection(collection.name)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<Map<String, dynamic>?> getDocument(
      Collection collection, String docId) async {
    final docSnapshot = await db.collection(collection.name).doc(docId).get();
    return docSnapshot.data();
  }
}
