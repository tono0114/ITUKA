require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { FactoryBot.create(:relationship) }
  describe '保存できるかのテスト' do
    context '保存できる場合' do
      it 'follower_idとfollowed_idがあれば保存できる' do
        expect(relationship).to be_valid
      end
    end

    context '保存できない場合' do
      it 'follower_idがnilであれば保存できない' do
        relationship.follower_id = nil
        relationship.valid?
        expect(relationship.errors[:follower_id])
      end

      it 'followed_idがnilであれば保存できない' do
        relationship.followed_id = nil
        relationship.valid?
        expect(relationship.errors[:followed_id])
      end
    end

    context '一意性であるか' do
      it 'follower_idとfollowed_idの組み合わせは一意でなければ保存できない' do
        relationship2 = build(:relationship, follower_id: relationship.follower_id, followed_id: relationship.followed_id)
        relationship2.valid?
        expect(relationship2.errors[:follower_id])
      end

      it 'follower_idが同じでもfollowed_idが違えば保存できる' do
        relationship2 = build(:relationship, follower_id: relationship.follower_id)
        expect(relationship2).to be_valid
      end

      it 'followed_idが同じでもfollower_idが違えば保存できる' do
        relationship2 = build(:relationship, followed_id: relationship.followed_id)
        expect(relationship2).to be_valid
      end
    end
  end

  describe 'アソシエーションのテスト' do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context '仮装モデルfollowerとのアソシエーション' do
      let(:target) { :follower }

      it 'followerとの関連付けはbelongs_toであること' do
        expect(association.macro).to eq :belongs_to
      end
    end

    context '仮装モデルfollowedとのアソシエーション' do
      let(:target) { :followed }

      it 'followedとの関連付けはbelongs_toであること' do
        expect(association.macro).to eq :belongs_to
      end
    end
  end
end
