import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';
import { Entry } from './entry';
import { Document } from './document';

@Injectable({
  providedIn: 'root'
})
export class DocumentService {

  constructor(private http: HttpClient) { }

  listDocuments(): Observable<Document[]> {
    return this.http.get<Document[]>(`${environment.server}/pdf_documents`);
  }

  getDocument(id: string): Observable<Document> {
    return this.http.get<Document>(`${environment.server}/pdf_documents/${id}`);
  }

  upload(file: File): Observable<Document> {
    const formData: FormData = new FormData();

    formData.append('pdf', file, file.name);

    return this.http.post<Document>(`${environment.server}/pdf_documents/new/upload`,
      formData);
  }

  update(document: Document): Observable<Document> {
    return this.http.put<Document>(`${environment.server}/pdf_documents/${document.id}`, document);
  }

  listEntries(documentId: string): Observable<Entry[]> {
    return this.http.get<Entry[]>(`${environment.server}/pdf_documents/${documentId}/entries`);
  }

  saveEntries(documentId: string, entryList: Entry[]): Observable<Entry> {
    return this.http.post<Entry>(`${environment.server}/pdf_documents/${documentId}/entries/new/batch_create`,
      { entries: entryList });
  }

}
