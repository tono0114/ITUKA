# frozen_string_literal: true

# require 'rails_helper'

# describe '投稿のテスト' do
#   let!(:post) { create(:post, title:'hoge', country:'huga', text:'hogehoge') }
#   describe '一覧画面のテスト' do
#     before do
#       visit posts_path
#     end
#     context '表示の確認' do
#       it '投稿されたものが表示されているか' do
#         expect(page).to have_content 'post.image_id'
#         expect(page).to have_content 'post.title'
#       end
#       it '検索ボタンが存在するか' do
#         expect(page).to have_button '検索'
#       end
#       it '新規投稿のリンク(+ボタン)が存在するか' do
#         expect(page).to have_link '', href: new_post_path
#       end
#     end
#   end

#   describe '投稿画面のテスト' do
#     before do
#       visit new_post_path
#     end
#     context '表示の確認' do
#       it '投稿ボタンが表示されているか' do
#         expect(page).to have_button '投稿する'
#       end
#       it 'new_post_pathが"/posts/new"であるか' do
#         expect(current_path).to eq('/posts/new')
#       end
#     end
#     context '投稿処理のテスト' do
#       it '投稿に成功しサクセスメッセージは表示されるか' do
#         fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
#         fill_in 'post[country]', with: Faker::Lorem.characters(number:5)
#         fill_in 'post[text]', with: Faker::Lorem.characters(number:20)
#         click_button '投稿する'
#         expect(page).to have_content '投稿しました。'
#       end
#       it '投稿に失敗する' do
#         click_button '投稿する' do
#           expect(page).to have_content 'Titleを入力してください。'
#           expect(current_path).to eq('/posts/new')
#         end
#       it '投稿後のリダイレクト先は正しいか' do
#         fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
#         fill_in 'post[country]', with: Faker::Lorem.characters(number:5)
#         fill_in 'post[text]', with: Faker::Lorem.characters(number:20)
#         click_button '投稿する'
#         expect(page).to have_current_path post_path(Post.last)
#       end
#     end
#     # context '投稿削除のテスト' do
#     #   it '投稿の削除' do
#     #     expect{ post.destroy }.to change{ Post.count }.by(-1)
#     #   end
#     # end
#   end

#   describe '詳細画面のテスト' do
#     before do
#       visit post_path(post)
#     end
#     context '表示の確認' do
#       it '投稿のタイトル、国、テキストが画面に表示されているか' do
#         expect(page).to have_content post.title
#         expect(page).to have_content post.country
#         expect(page).to have_content post.text
#       end
#       it '編集リンクが存在しているか' do
#         edit_link = find_all('a')[0]
#         expect(edit_link.native.inner_text).to match(/edit/i)
#         expect(page).to heve_link '編集する'
#       end
#       it 'コメントボタンが存在しているか' do
#         expect(page).to have_button 'コメントする'
#       end
#     end
#     context 'リンクの遷移先の確認' do
#       it '"編集する"の遷移先は編集画面か' do
#         edit_link = find_all('a')
#       end
#     end
#   end
# end