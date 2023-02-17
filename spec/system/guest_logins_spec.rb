require 'rails_helper'
include Sorcery::Controller

feature 'ゲストログイン機能', type: :system do

  it "のぞいてみるボタンを押すと自動的にゲストログインできる" do
    visit root_path
    click_button "のぞいてみる"
    expect(current_path).to eq(posts_path)
    # roleがguestになっているか確認
    user = User.find_by(role: 2)
    user.role = "guest"
  end
end
