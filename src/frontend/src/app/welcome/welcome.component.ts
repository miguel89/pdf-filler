import { Component, OnInit } from '@angular/core';
import { DocumentService } from '../document.service';
import { Document } from '../document';

@Component({
  selector: 'app-welcome',
  templateUrl: './welcome.component.html',
  styleUrls: ['./welcome.component.scss']
})
export class WelcomeComponent implements OnInit {

  public loadingDocs: boolean;
  public docsList: Document[];

  constructor(private documentService: DocumentService) {
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

}
