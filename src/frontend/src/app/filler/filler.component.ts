import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { DocumentService } from '../document.service';
import { Document } from '../document';
import { PDFDocumentProxy, PDFPageProxy } from 'ng2-pdf-viewer';
import { switchMap } from 'rxjs/operators';
import { environment } from '../../environments/environment';
import { Input } from './input';
import { InputType } from './input-type';
import { PDFAnnotationData } from 'pdfjs-dist';
import { MatDialog } from '@angular/material/dialog';
import { SelectionDialogComponent } from './selection-dialog/selection-dialog.component';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { Entry } from '../entry';

@Component({
  selector: 'app-filler',
  templateUrl: './filler.component.html',
  styleUrls: ['./filler.component.scss']
})
export class FillerComponent implements OnInit {

  private readonly DPI_RATIO = 96 / 72;
  private readonly PAGE_SIZE = 1066;

  public document: Document;
  public loading: boolean;
  private pdfProxy: PDFDocumentProxy;

  public textInputList: Input[];
  public cbInputList: Input[];

  public dataInput: string;

  public form: FormGroup;

  public zoom = 1;

  public InputType = InputType;

  constructor(private route: ActivatedRoute,
              private router: Router,
              private documentService: DocumentService,
              private dialog: MatDialog,
              private fb: FormBuilder) {
    this.document = new Document();
    this.textInputList = [];
    this.cbInputList = [];
    this.form = this.fb.group({});
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

  save(): void {
    this.documentService.update(this.document).pipe(
      switchMap((value, index) => {
        this.document.entries = [];
        const values = this.form.value;
        for (let _key in values) {
          this.document.entries.push({ key: _key, value: values[_key], literal: false } as Entry);
        }

        return this.documentService.saveEntries(this.document.id, this.document.entries);
      })
    ).subscribe(resp => {
      this.loading = false;
    }, err => {
      console.error(err);
      this.loading = false;
    });
  }

  download() {
    // this.pdfProxy
  }

  get pdfSrc() {
    return `${environment.server}/pdf_documents/${this.document.id}/download`;
  }

  public loadComplete(pdf: PDFDocumentProxy): void {
    this.pdfProxy = pdf;
    this.loadPdfFields();
  }

  private loadPdfFields(): void {
    for (let i = 1; i <= this.pdfProxy.numPages; i++) {

      let currentPage: PDFPageProxy;
      this.pdfProxy.getPage(i).then((p: PDFPageProxy) => {
        currentPage = p;

        p.getAnnotations().then((annotations: any) => {
          annotations.filter(a => a.subtype === 'Widget').forEach(a => {
            a.fieldValue = 'test';
            console.log(a);

            const fieldRect = currentPage.getViewport({scale: this.DPI_RATIO})
              .convertToViewportRectangle(a.rect);

            this.addInput(a, fieldRect, i);
          });
        });
      });
    }
  }

  private addInput(annotation: PDFAnnotationData | any, rect: number[], page: number): void {
    const formControl = new FormControl(annotation.buttonValue || '');
    const input = new Input();
    input.name = annotation.fieldName;

    if (annotation.fieldType === 'Tx') {
      input.type = InputType.TEXT;
      input.value = annotation.buttonValue || '';

      this.textInputList.push(input);
    } else {
      if (annotation.fieldType === 'Btn' && !annotation.checkBox) {
        input.type = InputType.RADIO;
        input.value = annotation.buttonValue;
      }

      if (annotation.checkBox) {
        input.type = InputType.CHECKBOX;
        input.value = true;
        formControl.setValue(false);
      }

      this.cbInputList.push(input);
    }

    if (rect) {
      input.position.top = (rect[1] - (rect[1] - rect[3])) + ((page - 1) * this.PAGE_SIZE);
      input.position.left = rect[0];
      input.position.height = (rect[1] - rect[3]) * .9;
      input.position.width = (rect[2] - rect[0]);
    }

    this.form.addControl(annotation.fieldName, formControl);
  }

  getInputPosition(input: Input) {
    return {
      top: `${input.position.top}px`,
      left: `${input.position.left}px`,
      height: `${input.position.height}px`,
      width: `${input.position.width}px`,
    };
  }

  pickField(input: Input): void {
    this.dialog.open(SelectionDialogComponent, {
      width: '250px',
      data: { name: input.name, fields: this.document.dataFields}
    }).afterClosed().subscribe(resp => {
      if (resp !== '_cancelled') {
        this.form.get(input.name).setValue(resp);
      }
    });
  }

  loadDataInputFields(event) {
    this.document.dataFields = event.target.value.split('\n')[0].split(',');
  }
}
