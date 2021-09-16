require 'rails_helper'

describe 'ユーザー登録前' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it '新規登録ボタンが存在する' do
        expect(page).to have_link '新規会員登録'
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit about_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      subject { page }

      it 'タイトルロゴが表示される' do
        is_expected.to have_selector '#header-logo'
      end
      it 'Aboutリンクが表示される' do
        is_expected.to have_link 'About'
      end
      it 'ログインリンクが表示される' do
        is_expected.to have_link 'ログイン'
      end
      it '新規登録リンクが表示される' do
        is_expected.to have_link '新規登録'
      end
    end

    context 'リンク内容の確認' do
      subject { current_path }

      it 'タイトルロゴをクリックするとトップページに遷移する' do
        find('#header-logo').click
        is_expected.to eq '/'
      end
      it 'Aboutリンクを押すと、アバウト画面に遷移する' do
        click_link 'About'
        is_expected.to eq '/about'
      end
      it 'ログインリンクを押すと、ログイン画面に遷移する' do
        click_link 'ログイン'
        is_expected.to eq '/login'
      end
      it '新規登録リンクを押すと、新規登録画面に遷移する' do
        click_link '新規登録'
        is_expected.to eq '/signup'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit signup_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/signup'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく登録される' do
        expect{ click_button '登録する' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、投稿一覧画面になっている' do
        click_button '登録する'
        expect(current_path).to eq '/posts'
      end
    end
  end
end

describe 'ユーザ登録後' do
  describe 'ユーザログインのテスト' do
    let(:user) { create(:user) }

    before do
      visit login_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/login'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログインする'
      end

      it 'ログイン後のリダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログインする'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit login_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログインする'
    end

    context '表示内容の確認' do
      subject { page }

      it 'タイトルロゴが表示され、トップページへのリンクになっている' do
        is_expected.to have_selector '#header-logo'
        find('#header-logo').click
        expect(current_path).to eq '/'
      end
      it 'MyPageリンクが表示される' do
        is_expected.to have_link 'MyPage'
      end
      it 'Postsリンクが表示される' do
        is_expected.to have_link 'Posts'
      end
      it 'Usersリンクが表示される' do
        is_expected.to have_link 'Users'
      end
      it 'Logoutリンクが表示される' do
        is_expected.to have_link 'Logout'
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit login_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログインする'
      click_link 'Logout'
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてログイン画面へのリンクが存在する' do
        expect(page).to have_link 'ログイン'
      end
      it 'ログアウト後のリダイレクト先が、トップ画面になっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end