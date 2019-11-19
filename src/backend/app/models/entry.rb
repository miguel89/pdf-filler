class Entry
  include Mongoid::Document
  field :key, type: String
  field :value, type: String
  field :literal, type: Mongoid::Boolean

  embedded_in :pdf_document
end
