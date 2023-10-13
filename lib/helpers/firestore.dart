import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
// get collection note
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('users');

// create add new notes
  Future<void> addNotes(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});

  }
  // reaad notes from database
    Stream<QuerySnapshot> getNotesStream() {
      final notesStream =
          notes.orderBy('timestamp', descending: true).snapshots();
      return notesStream;
    }

  // update: update notes given a doc
  Future < void >updateNote ( String docId , String newNote) {
    return  notes.doc(docId).update({
      'note' : newNote,
      'timestamp': Timestamp.now(),
    });
}

    // delete

    Future<void> deleteNote(String docID) {
      return notes.doc(docID).delete();
    }
}