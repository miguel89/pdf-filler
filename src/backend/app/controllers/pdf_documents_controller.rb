require 'pdf_forms'
require 'csv'
require 'zip'

class PdfDocumentsController < ApplicationController
  before_action :set_document, only: %i[show update destroy download fill]

  PDFTK_PATH = '/usr/bin/pdftk'
  ORIGINAL_FILE_NAME = 'original.pdf'
  RESULT_FILE_NAME = "result_%s.pdf"
  FINAL_FILE_NAME = 'final.zip'

  # GET /documents
  def index
    @pdf_documents = PdfDocument.all

    render json: @pdf_documents
  end

  # GET /documents/1
  def show
    render json: @pdf_document
  end

  # POST /documents
  def create
    @pdf_document = PdfDocument.new(document_params)

    if @pdf_document.save
      render json: @pdf_document, status: :created, location: @pdf_document
    else
      render json: @pdf_document.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /documents/1
  def update
    if @pdf_document.update(document_params)
      render json: @pdf_document
    else
      render json: @pdf_document.errors, status: :unprocessable_entity
    end
  end

  # DELETE /documents/1
  def destroy
    @pdf_document.destroy
  end

  def upload
    pdf_document = PdfDocument.new

    pdf_document.file = params[:pdf]
    pdf_document.name = params[:pdf].original_filename.split('.')[0..-2].join

    if pdf_document.save
      render json: pdf_document, status: :created, location: pdf_document
    else
      render json: pdf_document.errors, status: :unprocessable_entity
    end
  end

  def download
    content = @pdf_document.file.read

    if stale?(etag: content, public: true)
      send_data content, type: @pdf_document.file.file.content_type, disposition: 'inline'
      expires_in 0, public: true
    end
  end

  def fill
    data = CSV.parse(@pdf_document.data, headers: true)

    original = save_into_disk(@pdf_document.file.read, ORIGINAL_FILE_NAME)
    result_file_names = []

    data.each_with_index do |row, idx|
      result_file_names << create_pdf(original, row.to_h, idx)
    end

    result = create_final_or_zip(result_file_names)
    content = result.nil? ? nil : result.read
    ct = content_type(result)

    if stale?(etag: content, public: true)
      send_data content,
                type: ct, disposition: 'inline', filename: 'pdf_complete.zip'
      expires_in 0, public: true
    end

  ensure
    original.close
    result&.close
    File.delete(ORIGINAL_FILE_NAME) if File.exist?(ORIGINAL_FILE_NAME)
    File.delete(FINAL_FILE_NAME) if File.exist?(FINAL_FILE_NAME)
  end

  private

  def save_into_disk(content, file_name)
    file = File.new(file_name, 'w')
    file.set_encoding('ASCII-8BIT')
    file.write(content)
    file.close

    File.open(ORIGINAL_FILE_NAME, 'r')
  end

  def create_pdf(original, data, idx)
    pdftk = PdfForms.new(PDFTK_PATH)
    file_name = RESULT_FILE_NAME % idx
    replace = {}

    @pdf_document.entries.each do |entry|
      replace[entry.key] = data[entry.value] if data[entry.value]
    end

    pdftk.fill_form original, file_name, replace, flatten: true

    file_name
  end

  def create_final_or_zip(file_names)
    Zip::File.open(FINAL_FILE_NAME, Zip::File::CREATE) do |zipfile|
      file_names.each do |filename|
        zipfile.add(filename, File.open(filename, 'r'))
      end
    end
    file_names.each do |filename|
      File.delete(filename) if File.exist?(filename)
    end

    File.open(FINAL_FILE_NAME, 'r')
  end

  def content_type(file)
    if file.path.split('.')[-1] == 'pdf'
      'application/pdf'
    else
      'application/zip'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @pdf_document = PdfDocument.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def document_params
    params.require(:pdf_document).permit(:name, :data, dataFields: [])
  end
end
