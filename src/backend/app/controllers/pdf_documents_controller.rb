class PdfDocumentsController < ApplicationController
  before_action :set_document, only: %i[show update destroy download]

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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @pdf_document = PdfDocument.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def document_params
    params.require(:pdf_document).permit(:name, :file)
  end
end
