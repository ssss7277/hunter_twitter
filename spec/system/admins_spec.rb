require 'rails_helper'
include Sorcery::Controller

feature '管理者ログイン', type: :system do
  before do
    @admin = User.create(
      name: "admin",
      email: "admin@admin.jp",
      password: "admin",
      password_confirmation: "admin",
      role: "admin"
    )
  end

  let!(:user1) { create(:user, email: "user1@email.com") }

  let!(:post1) { create(:post, user: user1) }


  it "管理者のみログインできる" do
    visit root_path
    click_link "管理者としてログイン"
    fill_in 'Email', with: @admin.email
    fill_in 'Password', with: "admin"
    click_button "ログイン"
    # admin_users_pathに遷移しているか確認
    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content('管理者としてログインしました')
    # roleがadminになっているか確認
    user = User.find_by(role: 1)
    user.role = "admin"
  end

  it "管理者以外がadmin_posts_path/edit_admin_user_pathにアクセスしようとすると失敗する" do
    visit root_path
    click_link "管理者としてログイン"
    fill_in 'Email', with: user1.email
    fill_in 'Password', with: "12345678"
    click_button "ログイン"
    # admin_users_pathにアクセスしようとするとposts_pathに遷移する
    visit admin_users_path
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('管理者権限がありません')
    # edit_admin_user_pathにアクセスしようとするとposts_pathに遷移する
    visit edit_admin_user_path(post1)
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('管理者権限がありません')
  end

  it "管理者以外がadmin_posts_path/edit_admin_post_pathにアクセスしようとすると失敗する" do
    visit root_path
    click_link "管理者としてログイン"
    fill_in 'Email', with: user1.email
    fill_in 'Password', with: "12345678"
    click_button "ログイン"
    # admin_posts_pathにアクセスしようとするとposts_pathに遷移する
    visit admin_posts_path
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('管理者権限がありません')
    # edit_admin_post_pathにアクセスしようとするとposts_pathに遷移する
    visit edit_admin_post_path(post1)
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('管理者権限がありません')
  end
end

feature '管理者編集', type: :system do
  before do
    @admin = User.create(
      name: "admin",
      email: "admin@admin.jp",
      password: "admin",
      password_confirmation: "admin",
      role: "admin"
    )
  end

  let!(:user1) { create(:user, email: "user1@email.com") } 
  let!(:post1) { create(:post, user: user1) }


  it "管理者がユーザー情報を編集できる" do
    # ログイン処理
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with: "admin@admin.jp"
    fill_in 'Password', with: "admin"
    click_button "ログイン"
    # 編集画面に移動
    visit admin_users_path
    click_link "test"
    fill_in 'Name', with: "hogehoge"
    fill_in 'Email', with: "hogehogehoge@hoge.jp"
    click_button "更新する"
    # admin_users_pathに遷移しているか確認
    expect(current_path).to eq(admin_users_path)
    expect(page).to have_content('hogehoge')
    expect(page).to have_content('hogehogehoge@hoge.jp')
  end

  it "管理者がユーザー情報を削除できる" do
    # ログイン処理
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with: "admin@admin.jp"
    fill_in 'Password', with: "admin"
    click_button "ログイン"
    # 削除する前にPostモデルのレコードの数を確認する
    count = User.all.count
    # 編集画面に移動
    visit admin_users_path
    click_link "test"
    click_button "削除"
    # ユーザーを削除するとUserモデルのレコードの数が1減ることを確認する
    expect(User.all.count).to eq (count - 1)
    # admin_users_pathに遷移しているか確認
    expect(current_path).to eq(admin_users_path)
  end

  it "管理者が投稿を編集できる" do
    # ログイン処理
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with: "admin@admin.jp"
    fill_in 'Password', with: "admin"
    click_button "ログイン"
    # 編集画面に移動
    visit admin_posts_path
    click_link "はんたーはんたー"
    fill_in 'post_body', with: "ふがふが"
    click_button "更新する"
    # admin_users_pathに遷移しているか確認
    expect(current_path).to eq(admin_posts_path)
    expect(page).to have_content("ふがふが")
  end

  it "管理者がユーザー情報を削除できる" do
    # ログイン処理
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with: "admin@admin.jp"
    fill_in 'Password', with: "admin"
    click_button "ログイン"
    # 削除する前にPostモデルのレコードの数を確認する
    count = Post.all.count
    # 編集画面に移動
    visit admin_posts_path
    click_link "はんたーはんたー"
    click_button "削除"
    # ユーザーを削除するとUserモデルのレコードの数が1減ることを確認する
    expect(Post.all.count).to eq (count - 1)
    # admin_users_pathに遷移しているか確認
    expect(current_path).to eq(admin_posts_path)
  end
end
