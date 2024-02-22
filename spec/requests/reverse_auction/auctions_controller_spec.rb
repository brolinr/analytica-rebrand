require 'rails_helper'

RSpec.describe ReverseAuction::AuctionsController, type: :controller  do
  let(:company) { create(:company, :as_supplier) }
  let(:company_2) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company) }

  describe 'GET #new' do
    context 'when not logged in' do
      it 'redirects to sign in' do
        get :new
        expect(response).to redirect_to(new_company_session_path)
      end
    end

    context 'when logged in' do
      it 'does not redirect to sign in' do
        sign_in company
        get :new
        expect(response).not_to redirect_to(new_company_session_path)
      end
    end
  end

  describe 'POST #create' do
    before do
      @params = { auction: attributes_for(:auction) }
    end

    context 'not logged' do
      it 'should redirect user to sign in', :aggregate_failures do
        post :create, params: @params
        expect(response).to redirect_to(new_company_session_path)
        expect(flash[:alert]).not_to be_empty
      end

      it 'should not create an auction', :aggregate_failures do
        expect { post :create, params: @params }.not_to change(Auction, :count).from(0)
      end
    end

    context 'logged in' do
      before do
        sign_in company
        @params = { auction: attributes_for(:auction, company: nil) }
      end

      it 'should create auction', :aggregate_failures do
        expect { post :create, params: @params }.to change(Auction, :count).by(1)
        expect(response).not_to redirect_to(new_company_session_path)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'adding collaborators' do
      let(:params) do
        auction = attributes_for(:auction, company: nil)
        auction[:collaborator_ids] = [company_2.id]
        { auction: auction }
      end

      it 'creates collaborators and auction', :aggregate_failures do
        sign_in company
        expect { post :create, params: params }.to change(Auction, :count).from(0).to(1).and(
          change(Collaborator, :count).from(0).to(1)
        )
        expect(response).not_to redirect_to(new_company_session_path)
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let(:request) { put :update, params: { id: auction.id, auction: params } }
    before do
      auction
      sign_in(company)
    end

    context 'when logged in' do
      let(:params) { { title: 'New one' } }

      it 'updates title of auction', :aggregate_failures do
        expect { request }.to change { auction.reload.title }.to("New one")
        expect(response).not_to redirect_to(new_company_session_path)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'when updating collaborators' do
      let(:params) { { collaborator_ids: [company_2.id] } }

      it 'updates collaborators auction', :aggregate_failures do
        expect { request }.to change(Collaborator, :count).from(0).to(1)
        expect(response).not_to redirect_to(new_company_session_path)
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:request) { delete :destroy, params: { id: auction.id } }
    before do
      sign_in company
      auction
    end

    it 'should destroy auction', :aggregate_failures do
      expect { request }.to change(Auction, :count).from(1).to(0)
      expect(flash[:notice]).not_to be_empty
    end
  end
end
