class PdfDocument
  include Mongoid::Document
  field :name, type: String
  field :dataFields, type: Array
  field :data, type: String
  mount_uploader :file, PdfDocumentUploader

  embeds_many :entries
  accepts_nested_attributes_for :entries
end
