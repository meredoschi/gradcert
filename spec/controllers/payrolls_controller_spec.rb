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

RSpec.describe PayrollsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Payroll. As you add validations to Payroll, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PayrollsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def set_calculation_variables

    @all_annotations=Annotation.all
    @all_events=Event.all
    @all_registrations=Registration.all

  end

  describe "GET #index" do
    it "assigns all payrolls as @payrolls" do
      payroll = Payroll.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:payrolls)).to eq([payroll])
    end
  end

  describe "GET #show" do
    it "assigns the requested payroll as @payroll" do
      payroll = Payroll.create! valid_attributes
      get :show, {:id => payroll.to_param}, valid_session
      expect(assigns(:payroll)).to eq(payroll)
    end
  end

  describe "GET #new" do
    it "assigns a new payroll as @payroll" do
      get :new, {}, valid_session
      expect(assigns(:payroll)).to be_a_new(Payroll)
    end
  end

  describe "GET #edit" do
    it "assigns the requested payroll as @payroll" do
      payroll = Payroll.create! valid_attributes
      get :edit, {:id => payroll.to_param}, valid_session
      expect(assigns(:payroll)).to eq(payroll)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Payroll" do
        expect {
          post :create, {:payroll => valid_attributes}, valid_session
        }.to change(Payroll, :count).by(1)
      end

      it "assigns a newly created payroll as @payroll" do
        post :create, {:payroll => valid_attributes}, valid_session
        expect(assigns(:payroll)).to be_a(Payroll)
        expect(assigns(:payroll)).to be_persisted
      end

      it "redirects to the created payroll" do
        post :create, {:payroll => valid_attributes}, valid_session
        expect(response).to redirect_to(Payroll.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved payroll as @payroll" do
        post :create, {:payroll => invalid_attributes}, valid_session
        expect(assigns(:payroll)).to be_a_new(Payroll)
      end

      it "re-renders the 'new' template" do
        post :create, {:payroll => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #calculate" do

    it "computes the payroll" do
#      payroll = Payroll.create! valid_attributes
      payroll = FactoryBot.create(:payroll)
      puts payroll.name
      get :calculate, {:id => payroll.to_param}, valid_session
      set_calculation_variables
      puts "Registration count: "
      puts @registrations.count.to_s

    end

  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested payroll" do
        payroll = Payroll.create! valid_attributes
        put :update, {:id => payroll.to_param, :payroll => new_attributes}, valid_session
        payroll.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested payroll as @payroll" do
        payroll = Payroll.create! valid_attributes
        put :update, {:id => payroll.to_param, :payroll => valid_attributes}, valid_session
        expect(assigns(:payroll)).to eq(payroll)
      end

      it "redirects to the payroll" do
        payroll = Payroll.create! valid_attributes
        put :update, {:id => payroll.to_param, :payroll => valid_attributes}, valid_session
        expect(response).to redirect_to(payroll)
      end
    end

    context "with invalid params" do
      it "assigns the payroll as @payroll" do
        payroll = Payroll.create! valid_attributes
        put :update, {:id => payroll.to_param, :payroll => invalid_attributes}, valid_session
        expect(assigns(:payroll)).to eq(payroll)
      end

      it "re-renders the 'edit' template" do
        payroll = Payroll.create! valid_attributes
        put :update, {:id => payroll.to_param, :payroll => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested payroll" do
      payroll = Payroll.create! valid_attributes
      expect {
        delete :destroy, {:id => payroll.to_param}, valid_session
      }.to change(Payroll, :count).by(-1)
    end

    it "redirects to the payrolls list" do
      payroll = Payroll.create! valid_attributes
      delete :destroy, {:id => payroll.to_param}, valid_session
      expect(response).to redirect_to(payrolls_url)
    end
  end

end
