TestHumpyardForm::Application.routes.draw do |map|
  resources :elements do
    collection do
      get :options_new
    end
    member do
      get :options_edit
    end
  end
end
