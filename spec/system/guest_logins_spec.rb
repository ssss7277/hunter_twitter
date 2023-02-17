require 'rails_helper'
include Sorcery::Controller

feature 'ゲストログイン機能', type: :system do

  it "のぞいてみるボタンを押すと自動的にゲストログインできる" do
    visit root_path
    click_button "のぞいてみる"
    expect(current_path).to eq(posts_path)
    expect(page).to have_content('ゲストとしてログインしました')
    # マイページでユーザーネームがゲストになっているか確認
    click_link "まいぺーじ"
    expect(page).to have_content('ゲスト')
  end
end
