import { Entry } from './entry';

export class Document {
  public id: string;
  public name: string;
  public file: any;
  public dataFields: string[];
  public data: string;
  public entries: Entry[];
}
