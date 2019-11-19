class PdfDocument
  include Mongoid::Document
  field :name, type: String
  field :file, type: String
  embeds_many :entries
  accepts_nested_attributes_for :entries
end
