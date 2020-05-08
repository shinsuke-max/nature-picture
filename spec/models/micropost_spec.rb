require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { user.microposts.build(content: "TestTest", user_id: user.id) }

  subject(:my_post) { build(:micropost, user: user) }

  describe "Micropost" do
    it "should be valid" do
      expect(micropost).to be_valid
    end

    it "Contentの値が空の場合Micropostは存在しない" do
      micropost.update_attributes(content: " ", user_id: user.id)
      expect(micropost).to be_invalid
    end

    it "カラムが最新順に並んでいるか" do
      create(:microposts, :micropost1, created_at: 5.minutes.ago )
      create(:microposts, :micropost2, created_at: 5.hours.ago )
      micropost3 = create(:microposts, :micropost3, created_at: Time.zone.now )
      expect(Micropost.first).to eq micropost3
    end
  end

  describe "user_id" do
    it "UserはMicropostを作成したユーザーを返すこと" do
      expect(my_post.user).to eq user
    end

    it "user_idが存在しない場合Micropostも存在しない" do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end
  end

  describe "content" do
    it "contentが140以上の場合存在しない" do
      micropost.content = "y" * 140
      expect(micropost).to be_valid
      micropost.content = "y" * 141
      expect(micropost).to be_invalid
    end
  end

  describe "validation" do
    describe "presence" do
      it { is_expected.to validate_presence_of :user_id }
      it { is_expected.to validate_presence_of :content }
    end

    describe "characters" do
      it { is_expected.to validate_length_of(:content).is_at_most(140) }
    end
  end

end
