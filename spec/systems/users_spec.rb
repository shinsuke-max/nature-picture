require 'rails_helper'

RSpec.describe 'users', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_with_microposts) { FactoryBot.create(:user_with_microposts) }

  describe "user show" do
    before do
      valid_login(user_with_microposts)
      visit user_path(user_with_microposts)
    end

    it "Micropostが表示されていること" do
      expect(page).to have_content("#{user_with_microposts.name}")
    end
  end	

  describe 'user create a new account' do
    context 'enter a valid values' do
      before do
        visit signup_path
        fill_in 'Name', with: 'testuser'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Create my account'
      end

      it 'gets an flash message' do
        expect(page).to have_selector('.alert-success', text: 'Welcome to the Sample App!')
      end
    end

    context 'enter an invalid value' do
      before do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        fill_in 'Confirmation', with: ''
        click_button 'Create my account'
      end

      subject { page }

      it 'gets an errors' do
        is_expected.to have_selector('#error_explanation')
        is_expected.to have_selector('.alert-danger', text: 'The form contains 4 errors.')
        is_expected.to have_content("Password can't be blank", count: 1)
      end

      #失敗したときのurl
      #it 'render to /signup url' do
      #  is_expected.to have_current_path '/signup'
      #end
    end
  end



  describe "ユーザー編集" do
    before do
      visit user_path(user)
      valid_login(user)
      click_link "Account"
      click_link "Settings"
    end

    scenario "ユーザーの編集に成功" do
      fill_in 'Name', with: 'EditTest'
      fill_in "Email", with: "edit@example.com"
      click_button "Save changes"

      expect(current_path).to eq user_path(user)
      expect(user.reload.name).to eq 'EditTest'
      expect(user.reload.email).to eq "edit@example.com"
    end

    context "ユーザーの編集に失敗" do
      scenario "ユーザーのEmail編集に失敗" do
        fill_in "Email", with: "bar@test"
        click_button "Save changes"

        expect(page).to have_selector('.alert-danger', text: 'The form contains 1 error.')
        expect(page).to have_content("Email is invalid")
        expect(user.reload.email).to_not eq "bar@test"
      end

      scenario "ユーザーのpassword編集に失敗" do
        fill_in "Password", with: 'test'
        fill_in "Confirmation", with: '1234'
        click_button "Save changes"

        expect(page).to have_selector('.alert-danger', text: 'The form contains 2 errors.')
      end
    end
  end

  describe "ユーザー削除" do
    context "Adminユーザーの場合" do
      scenario "ユーザーの削除に成功" do
        valid_login(user)
        click_link "Users"
        expect(page).to have_current_path '/users'
        #expect(page).to have_link('delete', href: user_path(User.second))
        expect(page).not_to have_link('delete', href: user_path(user))
        #expect {
          #click_link('delete', match: :first)
          #expect(page.driver.browser.switch_to.alert.text).to eq "You sure?"
          #page.driver.browser.switch_to.alert.accept
          #expect(page).to have_css("div.alert.alert-success", text: "User deleted")
        #}.to change(User, :count).by(-1)
      end
    end
  end
end
