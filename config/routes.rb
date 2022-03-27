# frozen_string_literal: true

# Gradcert::Application.routes.draw do # March 2022 - Rails 5.1.7 update
Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users

  get 'absentreports/show'
  get 'admissions/edit'
  get 'admissions/index'
  get 'annotationreports/show'
  get 'payrollcalculation/clear'
  get 'payrollcalculation/show'
  get 'producestatements/show'
  get 'reports/annotations'
  get 'welcome/index'

  post 'reports/displayregistrations'

  resources :academiccategories
  resources :admissions, except: %i[new create destroy]
  resources :annotations
  resources :assessments
  resources :assignments
  resources :bankbranches
  resources :characteristics
  resources :colleges
  resources :contacts, except: [:new]
  resources :councils
  resources :countries
  resources :coursenames
  resources :courses
  resources :degreetypes
  resources :events
  resources :feedbacks
  resources :healthcareinfos
  resources :institutions
  resources :institutiontypes
  resources :leavetypes
  resources :makeupschedules
  resources :methodologies
  resources :municipalities
  resources :permissions
  resources :placesavailables
  resources :professionalareas
  resources :professionalfamilies
  resources :professionalspecialties
  resources :professions
  resources :programnames
  resources :programs
  resources :programsituations
  resources :regionaloffices
  resources :registrations
  resources :researchcenters
  resources :roles
  resources :rosters
  resources :scholarships
  resources :schoolnames
  resources :schools
  resources :schoolterms
  resources :schooltypes
  resources :stateregions
  resources :states
  resources :streetnames
  resources :students
  resources :supervisors
  resources :taxations
  resources :users

  # ------------------------------

  resources :bankpayments do
    member do
      get 'report'
      get 'totalreport'
      get 'producestatements'
      get 'statementspdf'
    end
  end

  resources :payrolls do
    member do
      get 'calculate'
      get 'clear'
      get 'report' # redirects to separate controller below
      get 'absences' #  ditto
      resource :annotationreports, only: [:show]
      resource :absentreports, only: [:show]
    end
  end

  resources :statements

  #  resources :statements do
  #    member do
  #      get 'report'
  #    end
  #  end
end
