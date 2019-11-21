# README

## About

This application was built using **Ruby on Rails 6** and **MongoDB**. It provides an API to store and fetch data and PDF files.

## Dependencies

* Ruby 2.6.5
* Ruby on Rails 6.0.1
* mongodb
* [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/)
 * [bcprv](https://www.bouncycastle.org/java.html) (optional, for encrypted PDF files)

## How to run

Make sure that the MongoDB server is runnig at localhost:27017 with default user/password. You can set the mongodb configuration at `app/config/mongid.yml`

### Using docker

* `docker build -t pdf-filler-back .`
* `docker run -p 3000:3000 pdf-filler-back`

### Manually

Make sure you have ruby instaled

* `bundle install`
* `rails s`


The API will be acessible at [localhost:3000](http://localhost:3000)