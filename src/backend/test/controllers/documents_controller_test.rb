require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pdf_document = documents(:one)
  end

  test "should get index" do
    get pdfDocuments_url, as: :json
    assert_response :success
  end

  test "should create document" do
    assert_difference('Document.count') do
      post pdfDocuments_url, params: {pdf_document: {file: @pdf_document.file, name: @pdf_document.name } }, as: :json
    end

    assert_response 201
  end

  test "should show document" do
    get pdfDocument_url(@pdf_document), as: :json
    assert_response :success
  end

  test "should update document" do
    patch pdfDocument_url(@pdf_document), params: {pdf_document: {file: @pdf_document.file, name: @pdf_document.name } }, as: :json
    assert_response 200
  end

  test "should destroy document" do
    assert_difference('Document.count', -1) do
      delete pdfDocument_url(@pdf_document), as: :json
    end

    assert_response 204
  end
end
