Rails.application.routes.draw do
  resources :pdf_documents do
    resources :entries do
      post :batch_create, on: :new
    end
    get :download, on: :member
    post :upload, on: :new
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
