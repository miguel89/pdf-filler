import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

export interface DialogData {
  name: string;
  fields: string[];
}

@Component({
  selector: 'app-selection-dialog',
  templateUrl: './selection-dialog.component.html',
  styleUrls: ['./selection-dialog.component.scss']
})
export class SelectionDialogComponent implements OnInit {

  public fields: string[];
  public name: string;
  public selected: string;

  constructor(public dialogRef: MatDialogRef<SelectionDialogComponent>,
              @Inject(MAT_DIALOG_DATA) public data: DialogData) {
    this.fields = this.data.fields;
    this.name = this.data.name;
  }

  ngOnInit() {
  }

  onNoClick(): void {
    this.dialogRef.close('_cancelled');
  }

  save() {
    this.dialogRef.close(this.selected);
  }
}
