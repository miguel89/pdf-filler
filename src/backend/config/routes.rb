Rails.application.routes.draw do
  resources :pdf_documents do
    resources :entries
    get :download, on: :member
    post :upload, on: :member
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
