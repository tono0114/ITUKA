require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }

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
      it '投稿のタイトルが表示されリンク先が正しい' do
        find('.post-link').click
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '検索ボタンが存在する' do
        expect(page).to have_button '検索'
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

    context '検索機能のテスト' do
      it '正しく検索され、リダイレクト先が正しい' do
        click_on '検索'
        expect(current_path).to eq '/posts/search'
        expect(page).to have_content post.title
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
        expect(page).to have_selector '.grey-heart'
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

    context '投稿削除のテスト' do
      before do
        click_link '削除する'
      end

      it '正しく削除される' do
        click_link '削除する'
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先がユーザ詳細画面になっている' do
        click_link '削除する'
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '戻るボタンを押すと、投稿詳細画面に遷移する' do
        click_link '戻る'
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it 'ユーザ画像が表示される' do
        expect(page).to have_selector('img[src$="user_no_image.png"]')
      end
      it 'ユーザのニックネームが表示される' do
        expect(page).to have_content user.name
      end
      it 'フォローボタンが表示される' do
        expect(page).to have_css '.yes-follow'
      end
      it '検索ボタンが表示される' do
        expect(page).to have_button '検索'
      end
    end

    context 'フォロー機能のテスト' do
      before do
        click_link 'Follow', match: :first
      end

      it 'フォローができる' do
        expect(page).to have_css '.no-follow'
        expect(user.following_user.count).to eq(1)
      end
      it 'フォローが解除できる' do
        click_link 'Unfollow', match: :first
        expect(page).to have_css '.yes-follow'
        expect(user.following_user.count).to eq(0)
      end
    end
    
    context '検索機能のテスト' do
      it '正しく検索され、リンク先が正しい' do
        click_on '検索'
        expect(current_path).to eq '/users/search'
        expect(page).to have_content user.name
      end
    end
  end

  describe 'ユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it 'プロフィール画像が表示される' do
        expect(page).to have_selector('img[src$="user_no_image.png"]')
      end
      it 'ニックネームが表示される' do
        expect(page).to have_content user.name
      end
      it '自己紹介が表示される' do
        expect(page).to have_content user.introduction
      end
      it 'フォロー人数が表示される' do
        expect(page).to have_content user.following_user.count
      end
      it 'フォロワー人数が表示される' do
        expect(page).to have_content user.follower_user.count
      end
      it '編集ボタンが表示され、リンク先が正しい' do
        click_link '編集する'
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it 'ユーザの投稿が表示される' do
        expect(page).to have_selector('img[src$="post_no_image.png"]')
      end
    end
  end

  describe 'ユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
    end

    context '編集成功のテスト' do
      before do
        @user_old_image_id = user.image_id
        @user_old_name = user.name
        @user_old_email = user.email
        @user_old_introduction = user.introduction
        expect {
          find('input[type = "file"]').click
          attach_file 'images[]', 'app/assets/images/post_no_image.png'
          fill_in 'user[image_id]', with: ''
        }
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 20)
        click_button '更新する'
      end

      it 'プロフィール画像が正しく更新される' do
        expect(user.reload.image_id).not_to eq @user_old_image_id
      end
      it 'ニックネームが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'メールアドレスが正しく更新される' do
        expect(user.reload.email).not_to eq @user_old_email
      end
      it '自己紹介が正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
      it 'リダイレクト先がユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context '退会のテスト' do
      before do
        click_link '退会する'
      end

      it '正しく退会処理される' do
        click_link '退会する'
        expect(User.where(id: user.id).count).to eq 0
      end
      it '退会後のリダイレクト先が正しい' do
        click_link '退会する'
        expect(current_path).to eq '/'
      end
      it '戻るボタンを押すとユーザ詳細画面に遷移する' do
        click_link '戻る'
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end