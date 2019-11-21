require 'pdf_forms'
require 'csv'

class PdfDocumentsController < ApplicationController
  before_action :set_document, only: %i[show update destroy download fill]

  ORIGINAL_FILE_NAME = 'original.pdf'
  RESULT_FILE_NAME = 'result.pdf'

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

    original = File.new(ORIGINAL_FILE_NAME, 'w')
    original.set_encoding('ASCII-8BIT')
    original.write(@pdf_document.file.read)

    data.each do |row|
      create_pdf(original, row.to_h)
    end

    result = File.open(RESULT_FILE_NAME, 'r')
    content = result.nil? ? nil : result.read

    if stale?(etag: content, public: true)
      send_data content, type: @pdf_document.file.file.content_type, disposition: 'inline'
      expires_in 0, public: true
    end

    result&.close
    original.close

    File.delete(ORIGINAL_FILE_NAME) if File.exist?(ORIGINAL_FILE_NAME)
    File.delete(RESULT_FILE_NAME) if File.exist?(RESULT_FILE_NAME)
  end

  private

  def create_pdf(original, data)
    pdftk = PdfForms.new('/usr/bin/pdftk')
    replace = {}

    @pdf_document.entries.each do |entry|
      replace[entry.key] = data[entry.key] if data[entry.key]
    end

    pdftk.fill_form original, RESULT_FILE_NAME, replace, :flatten => true
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @pdf_document = PdfDocument.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def document_params
    params.require(:pdf_document).permit(:name, :data, :dataFields => [])
  end
end
