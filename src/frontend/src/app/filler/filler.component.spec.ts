import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { FillerComponent } from './filler.component';

describe('FillerComponent', () => {
  let component: FillerComponent;
  let fixture: ComponentFixture<FillerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ FillerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FillerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
