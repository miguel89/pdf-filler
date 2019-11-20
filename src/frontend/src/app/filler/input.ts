import { InputType } from './input-type';
import { InputPosition } from './input-position';

export class Input {

  constructor() {
    this.position = new InputPosition();
  }

  name: string;
  type: InputType;
  value: any;
  position: InputPosition;
}
