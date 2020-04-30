require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  let!(:user) { create(:user) }
  describe 'POST #create' do
    it 'ログインが成功し正しくリダイレクトされているか確認' do
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect(response).to redirect_to user_path(user)
      expect(is_logged_in?).to be_truthy
    end
  end
end
