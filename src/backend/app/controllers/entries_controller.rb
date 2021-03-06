class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show update destroy]

  # GET /entries
  def index
    render json: PdfDocument.find(params[:pdf_document_id]).entries
  end

  # GET /entries/1
  def show
    render json: @entry
  end

  # POST /entries
  def create
    @entry = Entry.new(entry_params)
    @entry.pdf_document = PdfDocument.find(params[:pdf_document_id])

    if @entry.save
      render json: @entry.pdf_document, status: :created, location: @entry.pdf_document
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # POST /entries
  def batch_create
    entries = []
    document = PdfDocument.find(params[:pdf_document_id])

    document.entries.destroy_all

    params[:entries].each do |it|
      entry = Entry.new(it.permit(:key, :value, :literal))
      entry.pdf_document = document
      entry.save
      entries << entry
    end

    render json: entries, status: :created
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      render json: @entry
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def entry_params
      params.require(:entry).permit(:key, :value, :literal)
    end
end
