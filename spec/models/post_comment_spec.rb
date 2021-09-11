require 'rails_helper'

RSpec.describe PostComment, type: :model do
  describe 'バリデーションのテスト' do

    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post) }
    let(:post_comment) { FactoryBot.build(:post_comment, user_id: user.id, post_id: post.id) }

    context 'commentカラム' do
      it '空欄でないこと' do
        post_comment.comment = ''
        expect(post_comment).to be_invalid
        expect(post_comment.errors[:comment]).to include('を入力してください。')
      end
    end
  end
end
