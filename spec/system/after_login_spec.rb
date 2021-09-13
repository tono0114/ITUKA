require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit login_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログインする'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンク内容の確認' do
      subject { current_path }

      it 'MyPageリンクを押すと、マイページに遷移する' do
        click_link 'MyPage'
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Postsリンクを押すと、投稿一覧画面に遷移する' do
        click_link 'Posts'
        is_expected.to eq '/posts'
      end
      it 'Usersリンクを押すとユーザ一覧画面に遷移する' do
        click_link 'Users'
        is_expected.to eq '/users'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      # it '自分の投稿と他人の投稿のタイトルのリンクがそれぞれ正しい' do
      #   expect(post.title).to have_link href: post_path(post)
      #   expect(page).to have_link other_post.title, href: post_path(other_post)
      # end
      it '自分の投稿と他人の投稿のタイトルが表示される' do
        expect(page).to have_content post.title
        expect(page).to have_content other_post.title
      end
      it '検索ボタンが存在する' do
        expect(page).to have_button '検索'
      end
    end
  end

  describe '投稿画面のテスト' do
    before do
      visit new_post_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/new'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[country]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[text]', with: Faker::Lorem.characters(number: 20)
        expect {
          find('input[type = "file"]').click
          attach_file 'images[]', 'app/assets/images/post_no_image.png'
          fill_in 'post[image_id]', with: ''
        }
      end

      it '自分の新しい投稿が正しく保存され、サクセスメッセージが表示される' do
        expect { click_button '投稿する' }.to change(user.posts, :count).by(1)
        expect(page).to have_content '投稿しました。'
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button '投稿する'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '投稿した画像が表示される' do
        expect(page).to have_selector('img[src$="post_no_image.png"]')
      end
      it 'コメントの数が表示される' do
        expect(page).to have_content post.post_comments.count
      end
      it 'いいねのボタンと数が表示される' do
        expect(page).to have_selector '.fas'
        expect(page).to have_content post.favorites.count
      end
      it 'ユーザネームが表示され、リンク先が正しい' do
        expect(page).to have_link user.name, href: user_path(post.user)
      end
      it 'Titleが表示される' do
        expect(page).to have_content post.title
      end
      it 'countryが表示される' do
        expect(page).to have_content post.country
      end
      it 'textが表示される' do
        expect(page).to have_content post.text
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集する', href: edit_post_path(post)
      end
      it 'コメント送信用フォームと送信ボタンが表示される' do
        expect(page).to have_field 'post_comment[comment]'
        expect(page).to have_button 'コメントする'
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集する'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context 'いいね機能のテスト', js: true do
      it 'いいねされる' do
        find('.grey-heart').click
        expect(page).to have_css '.red-heart'
        expect(post.favorites.count).to eq(1)
      end
      it 'いいねが解除される' do
        find('.grey-heart').click
        find('.red-heart').click
        expect(page).to have_css '.grey-heart'
        expect(post.favorites.count).to eq(0)
      end
    end

    context 'コメント機能のテスト' do
      before do
        fill_in 'post_comment[comment]', with: 'あいうえお'
      end

      it 'コメントが保存される' do
        click_button 'コメントする'
        expect(post.post_comments.count).to eq(1)
      end
      it 'コメントが削除される' do
        click_button 'コメントする'
        click_link '削除する'
        expect(post.post_comments.count).to eq(0)
      end
    end
  end

  describe '投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_image_id = post.image_id
        @post_old_title = post.title
        @post_old_country = post.country
        @post_old_text = post.text
        expect {
          find('input[type = "file"]').click
          attach_file 'images[]', 'app/assets/images/user_no_image.png'
          fill_in 'post[image_id]', with: ''
        }
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[country]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[text]', with: Faker::Lorem.characters(number: 20)
        click_button '更新する'
      end

      it '画像が正しく更新される' do
        expect(post.reload.image_id).not_to eq @post_old_image_id
      end
      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'countryが正しく更新される' do
        expect(post.reload.country).not_to eq @post_old_country
      end
      it 'textが正しく更新される' do
        expect(post.reload.text).not_to eq @post_old_text
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end
end