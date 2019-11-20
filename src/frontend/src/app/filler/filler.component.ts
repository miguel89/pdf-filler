import { Component, Input, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { DocumentService } from '../document.service';
import { Document } from '../document';
import { switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-filler',
  templateUrl: './filler.component.html',
  styleUrls: ['./filler.component.scss']
})
export class FillerComponent implements OnInit {

  public document: Document;
  public loading: boolean;

  constructor(private route: ActivatedRoute,
              private router: Router,
              private documentService: DocumentService) {
  }

  ngOnInit() {
    this.route.paramMap.pipe(
      switchMap((params: ParamMap) => {
        this.loading = true;
        return this.documentService.getDocument(params.get('id'));
      })
    ).subscribe(
      resp => this.document = resp,
      err => {
        console.error(err);
        this.loading = false;
      },
      () => this.loading = false);
  }

}
