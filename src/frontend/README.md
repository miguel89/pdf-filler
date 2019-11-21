# PdfFiller

## About

Frontend Application built with Angular 8

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 8.3.19.

## How to run

Make sure that the backend is up and running. You can configure the backend url at `src/environments/`

### Using docker

* `docker build -t pdf-filler-front .`
* `docker run -p 4200:4200 pdf-filler-front`

The application will be available at [localhost](http://localhost)

### Manually

Make sure you have node instaled

* `npm install`
* `ng serve`

The application will be available at [localhost:4200](http://localhost:4200)

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.
