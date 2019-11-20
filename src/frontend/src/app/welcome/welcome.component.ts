import { Component, OnInit } from '@angular/core';
import { DocumentService } from '../document.service';
import { Document } from '../document';
import { Router } from '@angular/router';

@Component({
  selector: 'app-welcome',
  templateUrl: './welcome.component.html',
  styleUrls: ['./welcome.component.scss']
})
export class WelcomeComponent implements OnInit {

  public loadingDocs: boolean;
  public docsList: Document[];
  public uploading: boolean;

  constructor(private documentService: DocumentService, private router: Router) {
    this.docsList = [];
  }

  ngOnInit() {
    this.loadingDocs = true;
    this.documentService.listDocuments().subscribe(resp => {
      this.docsList = resp;
      this.loadingDocs = false;
    }, err => {
      console.error(err);
      this.loadingDocs = false;
    });
  }

  openDocument(docId: string): void {
    this.router.navigate([`/document/${docId}`]);
  }

  handleFileInput(files: FileList) {
    const file = files.item(0);

    this.uploading = true;
    this.documentService.upload(file).subscribe(resp => this.openDocument(resp.id),
      err => {
        console.error(err);
        this.uploading = false;
      }, () => this.uploading = false);

  }

}
