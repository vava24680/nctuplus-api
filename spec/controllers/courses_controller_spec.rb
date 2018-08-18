require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe CoursesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Course. As you add validations to Course, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    FactoryBot.attributes_for :course
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:current_user) { FactoryBot.create :user }
  before(:each) do
    request.headers.merge! current_user.create_new_auth_token
  end

  describe 'GET #index' do
    it 'returns a success response' do
      course = Course.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      course = Course.create! valid_attributes
      get :show, params: { id: course.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {{ rollcall_frequency: 3 }}

      it 'updates the requested course' do
        course = Course.create! valid_attributes
        put :update, params: { id: course.to_param, course: new_attributes }
        course.reload
        expect(course.rollcall_frequency).to eq(3)
      end

      it 'renders a JSON response with the course' do
        course = Course.create! valid_attributes

        put :update, params: { id: course.to_param, course: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'POST #rating' do
    let(:rating) { FactoryBot.attributes_for :course_rating, category: 1 }
    let(:new_rating) { FactoryBot.attributes_for :course_rating, category: 1 }

    it 'create user rating for course' do
      course = Course.create! valid_attributes
      post :rating, params: { course_id: course.id, **rating }
      expect(response).to have_http_status(:created)
      expect(course.course_ratings.size).to eq 1
    end
    it 'update user rating if a course rating already exists' do
      course = Course.create! valid_attributes

      post :rating, params: { course_id: course.id, **rating }
      expect(response).to have_http_status(:created)

      response_json = JSON.parse(response.body).symbolize_keys
      expect(response_json).to have_key(:id)

      id = response_json[:id]
      expect(current_user.course_ratings.find(id).score).to eq(rating[:score])

      post :rating, params: { course_id: course.id, **new_rating }
      expect(response).to have_http_status(:created)

      current_user.reload
      expect(current_user.course_ratings.find(id).score).to eq(new_rating[:score])
    end
  end

end
