require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'バリデーションのテスト' do

    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:favorite) { FactoryBot.build(:favorite) }

    it 'user_idとpost_idがあれば保存できる' do
      expect(favorite).to be_valid
    end

    it 'user_idがなければ無効である' do
      favorite = build(:favorite, user_id: nil)
      expect(favorite).to be_invalid
    end

    it 'post_idがなければ無効である' do
      favorite = build(:favorite, post_id: nil)
      expect(favorite).to be_invalid
    end

    it 'post_idが同じでもuser_idが違えば保存できる' do
      favorite = create(:favorite)
      expect(FactoryBot.create(:favorite, post_id: favorite.post_id)).to be_valid
    end

    it 'user_idが同じでもpost_idが違えば保存できる' do
      favorite = create(:favorite)
      expect(FactoryBot.create(:favorite, user_id: favorite.user_id)).to be_valid
    end

    it 'post_idとuser_idの組み合わせは一意でなければ保存できない' do
      favorite2 = build(:favorite, post_id: favorite.post_id, user_id: favorite.user_id)
      favorite2.valid?
      expect(favorite2.errors[:post_id])
    end
  end
end
