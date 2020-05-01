require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET #index" do
    context "ログイン済みのユーザーとして" do
      it "正しく表示されているか" do
        sign_in_as user
        get users_path
        expect(response).to have_http_status 200
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトされること" do
        get users_path
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #show' do
    context "ログイン済みのユーザーとして" do
      it "responds successfully" do
        sign_in_as user
        get user_path(user)
        expect(response).to have_http_status 200
      end
    end

    context "ログインしていないユーザーの時" do
      it "ログイン画面にリダイレクトされること" do
        get user_path(user)
        expect(response).to redirect_to login_path
      end
    end
  end


  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status 200
    end
  end

  describe 'POST #create' do
    context 'valid request' do
      it 'adds a user' do
        expect do
          post users_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      context 'adds a user' do
        before { post users_path, params: { user: attributes_for(:user) } }
        subject { response }
        it { is_expected.to redirect_to user_path(User.last) }
        it { is_expected.to have_http_status 302 }
        it '登録後にログインしている状態か' do
          expect(is_logged_in?).to be_truthy
        end
      end
    end

    context 'invalid request' do
      let(:user_params) do
        attributes_for(:user, name: '',
                              email: 'user@invalid',
                              password: '',
                              password_confirmation: '')
      end

      it 'does not add a user' do
        expect do
          post users_path, params: { user: user_params }
        end.to change(User, :count).by(0)
      end
    end
  end

  describe "GET #edit" do
    context "ログイン済みのユーザーとして" do
      it "responds successfully" do
        sign_in_as user
        get edit_user_path(user)
        expect(response).to have_http_status 200
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトされること" do
        get edit_user_path(user)
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path
      end
    end

    context "違うユーザーでログインした時" do
      it "root_parhにリダイレクトされること" do
        sign_in_as other_user
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    context "認可されたユーザーとして" do
      it "ユーザを更新できること" do
        user_params = FactoryBot.attributes_for(:user, name: "TestName")
        sign_in_as user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq "TestName"
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面にレダイレクト" do
        user_params = FactoryBot.attributes_for(:user, name: "TestName")
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path
      end
    end

    context "異なるユーザーの場合" do
      it "ユーザーを更新できないこと" do
        user_params = FactoryBot.attributes_for(:user, name: "TestName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq other_user.name
      end

      it "root_pathにリダイレクトされること" do
        user_params = FactoryBot.attributes_for(:user, name: "TestName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    context "Adminユーザーとして" do
      it "ユーザーを削除できること" do
        sign_in_as user
        expect {
          delete user_path(user), params: { id: user.id }
        }.to change(User, :count).by(-1)
      end
    end

    context "Adminユーザーでない場合" do
      it "ホーム画面にリダイレクトすること" do
        sign_in_as other_user
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to users_path
      end
    end

    context "ログインせず削除" do
      it "return a 302 response" do
        delete user_path(user), params: { id: user.id }
        expect(response).to have_http_status 302
      end

      it "ログインページにリダイレクト" do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to login_path
      end
    end
  end
end
