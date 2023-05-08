import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards/features/db/models/collection.dart';

class DbService {
  final db = FirebaseFirestore.instance;

  Future<void> add(
      Collection collection, String id, Map<String, dynamic> data) {
    return db.collection(collection.name).doc(id).set(data);
  }

  Future<void> update(
      Collection collection, String id, Map<String, dynamic> data) {
    return db.collection(collection.name).doc(id).update(data);
  }

  Stream<List<Map<String, dynamic>>> getCollectionStream(
      Collection collection) {
    return db
        .collection(collection.name)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<void> deleteDocument(Collection collection, String docId) {
    return db.collection(collection.name).doc(docId).delete();
  }

  Future<Map<String, dynamic>> getDocument(
      Collection collection, String docId) async {
    try {
      final docSnapshot = await db.collection(collection.name).doc(docId).get();
      if (docSnapshot.data() == null) {
        return Future.error("No data in db query.");
      }
      return docSnapshot.data()!;
    } catch (e) {
      return Future.error(e);
    }
  }
}
