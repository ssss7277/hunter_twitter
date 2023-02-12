require 'rails_helper'

feature '新規登録', type: :feature do
  scenario '新規登録が成功する' do
    visit login_path
    click_link '新規登録'
    expect(current_path).to eq(new_user_path)
    #ユーザー情報の入力
    fill_in "Name", with: "test"
    fill_in "Email", with: "test@example"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "登録"
    #結果確認
    expect(current_path).to eq(home_path)
    expect(page).to have_content('ユーザー登録が完了しました')
    new_user = User.order(:id).last
    expect(new_user.name).to eq("test")
    expect(new_user.email).to eq("test@example")
  end

  scenario '新規登録が失敗する' do
    # 入力前後でuser数に変化がないか確認
    expect change(User, :count).from(0).to(0)
    visit login_path
    click_link '新規登録'
    expect(current_path).to eq(new_user_path)
    #ユーザー情報の入力
    fill_in "Name", with: "test"
    fill_in "Email", with: "test@example"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "aaaaaaaa"
    click_button "登録"
    #結果確認
    expect(current_path).to eq(new_user_path)
    expect(page).to have_content('入力内容に誤りがあります')
    expect(page).to have_field 'Name', with: "test"
    expect(page).to have_field 'Email', with: "test@example"
    expect change(User, :count).by(0)
  end
end

feature 'ログイン', type: :feature do
  before do
    @user = FactoryBot.create(:user)
  end

  scenario 'ログインに成功する' do
    visit login_path
    expect(page).to have_content('ログイン')
    #ユーザー情報の入力
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "12345678"
    click_button "ログイン"
    #結果確認
    expect(current_path).to eq(home_path)
    expect(page).to have_content('ログインしました')
    new_user = User.order(:id).last
    expect(new_user.name).to eq("test")
    expect(new_user.email).to eq("test@example")
  end

  scenario 'ログインに失敗するがemailが正しい場合保持される' do
    visit login_path
    expect(page).to have_content('ログイン')
    #ユーザー情報の入力
    fill_in 'Email', with:  @user.email
    fill_in 'Password', with: ""
    click_button "ログイン"
    #結果確認
    expect(current_path).to eq(login_path)
    expect(page).to have_content('メールアドレス,またはパスワードが間違っています。')
    expect(page).to have_field 'Email', with: @user.email
    # ログインしないとできない操作が不可能か確認
    visit home_path
    expect(current_path).to eq(login_path)
  end

  scenario 'ログインに失敗する' do
    visit login_path
    expect(page).to have_content('ログイン')
    #ユーザー情報の入力
    fill_in 'Email', with: ""
    fill_in 'Password', with: ""
    click_button "ログイン"
    #結果確認
    expect(current_path).to eq(login_path)
    expect(page).to have_content('メールアドレス,またはパスワードが間違っています。')
    # ログインしないとできない操作が不可能か確認
    visit home_path
    expect(current_path).to eq(login_path)
  end

end
