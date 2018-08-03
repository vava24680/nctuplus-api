Rails.application.routes.draw do
  resources :course_ratings
  mount_devise_token_auth_for 'User', at: 'auth'
  scope 'api' do
    scope 'v1' do
      get 'colleges', to: 'colleges#index', as: :colleges_path
      get 'departments', to: 'departments#index', as: :departments_path
      get 'teachers', to: 'teachers#index', as: :teachers_path
      get 'semesters', to: 'semesters#index', as: :semesters_path
      resources :users, only: [:index]
      resources :bulletins
      resources :books
      resources :permanent_courses, only: [:index, :show]
      resources :courses, only: [:index, :show, :update]
      resources :past_exams
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
