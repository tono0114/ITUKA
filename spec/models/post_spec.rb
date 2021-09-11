require 'rails_helper'

RSpec.describe Post, "モデルに関するテスト", type: :model do
  describe 'バリデーションのテスト' do

    let!(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.build(:post, user_id: user.id) }

    context 'titleカラム'
    it '空欄でないこと' do
      post.title = ''
      expect(post).to be_invalid
      expect(post.errors[:title]).to include('を入力してください。')
    end
    
    it '20文字以内であること' do
      post.title = 'あいうえおかきくけこさしすせそたちつてとな'
      expect(post).to be_invalid
      expect(post.errors[:title])
    end
  end
end