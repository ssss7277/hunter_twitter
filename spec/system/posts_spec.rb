require 'rails_helper'
include Sorcery::Controller

feature 'つぶやき投稿機能', type: :system do
  let!(:user1) { create(:user, email: "user1@email.com") } 

  it "投稿できる" do
    # ログイン処理
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with:  user1.email
    fill_in 'Password', with: "12345678"
    click_button "ログイン"
    visit posts_path
    expect(current_path).to eq(posts_path)
    # 新規投稿画面に移動
    click_link "しんきとうこう"
    expect(current_path).to eq(new_post_path)
    expect(page).to have_content('全角ひらがなでつぶやいてください')
    # 投稿内容の入力
    fill_in 'post_body', with: "ほげほげ"
    click_button "登録"
    #結果確認
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('ほげほげ')
  end

  it "ひらがな以外は投稿できない" do
    # ログイン処理
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with:  user1.email
    fill_in 'Password', with: "12345678"
    click_button "ログイン"
    visit posts_path
    expect(current_path).to eq(posts_path)
    # 新規投稿画面に移動
    click_link "しんきとうこう"
    expect(current_path).to eq(new_post_path)
    expect(page).to have_content('全角ひらがなでつぶやいてください')
    # 英語の投稿内容の入力
    fill_in 'post_body', with: "hogehoge"
    click_button "登録"
    #結果確認
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('入力内容に誤りがあります')
    # 漢字の投稿内容の入力
    visit new_post_path
    fill_in 'post_body', with: "保気保気"
    click_button "登録"
    #結果確認
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('入力内容に誤りがあります')
  end

  it 'ログインしていないと新規投稿画面には遷移できない' do
    # 投稿ページに移動する
    visit new_post_path
    # login画面に遷移することを確認する
    expect(current_path).to eq(login_path)
  end
end

feature '編集機能', type: :system do
  let!(:user1) { create(:user, email: "user1@email.com") } 
  let!(:user2) { create(:user, email: "user2@email.com") } 

  let!(:post1) { create(:post, user: user1) } 
  let!(:post2) { create(:post, user: user2) } 
  
  it 'ログインしたユーザーは自分が投稿した投稿の編集ができる' do
    # ログイン処理
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with:  user1.email
    fill_in 'Password', with: "12345678"
    click_button "ログイン"
    visit posts_path
    expect(current_path).to eq(posts_path)
    # 自身の投稿であるpost1を編集するボタンがあることを確認する
    expect(page).to have_content('へんしゅう'), href: edit_post_path(post1)
    # 編集ページへ遷移する
    visit edit_post_path(post1)
    # すでに投稿済みの内容がフォームに入っていることを確認する
    expect(find('#post_body').value).to eq(post1.body)
    # 投稿内容を編集する
    fill_in 'post_body', with: "#{post1.body}ふがふが"
    click_button "更新する"
    # 編集完了画面に遷移したことを確認する
    expect(current_path).to eq(posts_path)
    # トップページには先ほど変更した内容の投稿が存在することを確認する
    expect(page).to have_content("#{post1.body}ふがふが")
end

  it 'ログインしたユーザーは自分以外が投稿した投稿の編集画面には遷移できない' do
    # ログインする
    visit login_path
    expect(page).to have_content('ログイン')
    fill_in 'Email', with:  user1.email
    fill_in 'Password', with: "12345678"
    click_button "ログイン"
    visit posts_path
    expect(current_path).to eq(posts_path)

    # user2の投稿一覧ページに移動する
    visit user_path(user2)
    # 他人の投稿には編集ボタンがないことを確認する
    expect(page).to have_no_content('へんしゅう')
  end

  it 'ログインしていないと投稿の編集画面には遷移できない' do
    # 投稿ページに移動する
    visit edit_post_path(post1)
    # login画面に遷移することを確認する
    expect(current_path).to eq(login_path)
  end

end

feature '削除機能', type: :system do
  let!(:user1) { create(:user, email: "user1@email.com") } 
  let!(:user2) { create(:user, email: "user2@email.com") } 

  let!(:post1) { create(:post, user: user1) } 
  let!(:post2) { create(:post, user: user2) } 

  context '投稿の削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿した投稿の削除ができる' do
      # ログイン
      visit login_path
      expect(page).to have_content('ログイン')
      fill_in 'Email', with:  user1.email
      fill_in 'Password', with: "12345678"
      click_button "ログイン"

      # 削除する前にPostモデルのレコードの数を確認する
      count = Post.all.count
      # 削除ボタンをクリックする
      visit user_path(user1)
      expect(current_path).to eq(user_path(user1))
      expect(page).to have_content('さくじょ'), href: post_path(post1)
      click_on 'さくじょ', match: :first
      # 投稿を削除するとPostモデルのレコードの数が1減ることを確認する
      expect(Post.all.count).to eq (count - 1)
      # ユーザーページ画面に遷移したことを確認する
      expect(current_path).to eq(user_path(user1))
    end
  end

  context '投稿が削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿した内容の削除ができない' do
      # usre1がログイン
      visit login_path
      expect(page).to have_content('ログイン')
      fill_in 'Email', with:  user1.email
      fill_in 'Password', with: "12345678"
      click_button "ログイン"
      # user2の投稿一覧ページに移動する
      visit user_path(user2)
      # 他人の投稿には編集ボタンがないことを確認する
      expect(page).to have_no_content('へんしゅう')
    end
    it 'ログインしていないと投稿の削除ボタンがない' do
      # 投稿ページに移動する
      visit edit_post_path(post1)
      # login画面に遷移することを確認する
      expect(current_path).to eq(login_path)
    end
  end
end

RSpec.describe "いいね機能", type: :system do
  let!(:user1) { create(:user, email: "user1@email.com") } 

  let!(:post1) { create(:post, user: user1) } 

  describe '#create,#destroy' do
    it 'ユーザーが投稿をいいね、いいね解除できる' do
      # ログイン
      visit login_path
      expect(page).to have_content('ログイン')
      fill_in 'Email', with:  user1.email
      fill_in 'Password', with: "12345678"
      click_button "ログイン"

      # 投稿詳細ページに遷移する
      visit posts_path
      count = Favorite.all.count

      # いいねをするボタンを押す
      click_button "♡"
      expect(page).to have_content('❤︎')
      expect(Favorite.all.count).to eq (count + 1)

      # いいねを解除する
      click_button "❤︎"
      expect(page).to have_content('♡')
      expect(Favorite.all.count).to eq (count)
    end
   end
end
