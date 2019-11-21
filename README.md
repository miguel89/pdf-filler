# PDF FILLER

## About

The goal of this application is to automatize PDF forms filling, as part of the [VanHackathon](https://vanhack.com).

After uploading a PDF, you can set you data fields and match the PDF fields with your data fields. Your data should be a CSV (comma seperated values) file, with the first row (header) indicating the field's name. After that, you paste your data into the Data field, save the changes, and you can download as a ZIP file with the PDF forms filled.

## Requirements

You can use Docker to run the application without any other requirement. Specific requirements are detailed in each application (frontend and backend).

* Docker
* Docker compose

## How to run

In the project's root, run

`docker-compose up`

## Stack

The application was build with **Angular 8**  in the frontend, **Ruby on Rails 6** in the backend and **MongoDB** as database.

## Known Issues

### Checkboxes and comboboxes

Due to time limitations, the application does not support checkboxes and comboboxes.

### Large PDF files

The application can get slow with large PDF files

## TODO

* Add support to checkboxes and comboboxes
* Improve usability
* Add support to fetch data from APIs
