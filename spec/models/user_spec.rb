require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do

    let!(:other_user) { FactoryBot.create(:user) }
    let(:user) { FactoryBot.build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        expect(user).to be_invalid
        expect(user.errors[:name]).to include('を入力してください。')
      end
      
      it '一意性があること' do
        user.name = other_user.name
        expect(user).to be_invalid
        expect(user.errors[:name])
      end
      
      it '20文字以内であること' do
        user.name = 'あいうえおかきくけこさしすせそたちつてとな'
        expect(user).to be_invalid
        expect(user.errors[:name])
      end
    end

    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        expect(user).to be_invalid
        expect(user.errors[:email]).to include('を入力してください。')
      end
      
      it '一意性があること' do
        user.email = other_user.email
        expect(user).to be_invalid
        expect(user.errors[:email])
      end
    end

    context 'passwordカラム' do
      it '空欄でないこと' do
        user.password = ''
        expect(user).to be_invalid
        expect(user.errors[:password]).to include('を入力してください。')
      end
    end

    context 'password_confirmationカラム' do
      it '空欄でないこと' do
        user.password_confirmation = ''
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation])
      end
    end
  end
end