require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    visit login_path
  end

  describe 'ログインが有効になること' do
    let!(:user) { create(:user, email: 'sample@example.com', password: 'password') }
    before do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end
    subject { page }

    it 'ログイン有効時のページレイアウト確認' do
      is_expected.to have_current_path user_path(user)
      is_expected.to_not have_link nil, href: login_path
      click_link 'Account'
      is_expected.to have_link 'Profile', href: user_path(user)
      is_expected.to have_link 'Log out', href: logout_path
    end

    it 'ログアウトのテスト' do
      click_link 'Account'
      click_link 'Log out'
      is_expected.to have_current_path root_path
      is_expected.to have_link 'Log in', href: login_path
      is_expected.to_not have_link 'Account'
      is_expected.to_not have_link nil, href: logout_path
      is_expected.to_not have_link nil, href: user_path(user)
    end
  end

  describe 'ログインが無効になること' do
    before do
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      click_button 'Log in'
    end
    subject { page }

    it 'フラッシュメッセージを表示' do
      is_expected.to have_selector('.alert-danger', text: 'Invalid email/password combination')
      is_expected.to have_current_path login_path
    end

    context '違うページにアクセスした時' do
      before { visit root_path }
      it 'フラッシュメッセージが消えること' do
        is_expected.to_not have_selector('.alert-danger', text: 'Invalid email/password combination')
      end
    end
  end
end
