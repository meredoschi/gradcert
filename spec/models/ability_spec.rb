# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'
# Copied from -->
# https://github.com/ryanb/railscasts/blob/master/spec/models/ability_spec.rb

describe 'Ability' do
  #
  #   describe "as guest" do
  #     before(:each) do
  #       @ability = Ability.new(nil)
  #     end
  #
  #     it "can only view and create users" do
  #       @ability.should be_able_to(:login, :users)
  #       @ability.should be_able_to(:show, :users)
  #       @ability.should be_able_to(:create, :users)
  #       @ability.should be_able_to(:unsubscribe, :users)
  #       @ability.should_not be_able_to(:update, :users)
  #     end
  #
  #     it "can only view episodes which are published" do
  #       @ability.should be_able_to(:index, :episodes)
  #       @ability.should be_able_to(:show, Factory.build(:episode, :published_at => 2.days.ago))
  #       @ability.should_not be_able_to(:show, Factory.build(:episode,
  #          :published_at => 2.days.from_now))
  #       @ability.should_not be_able_to(:create, :episodes)
  #       @ability.should_not be_able_to(:update, :episodes)
  #       @ability.should_not be_able_to(:destroy, :episodes)
  #     end
  #
  #     it "can access any info pages" do
  #       @ability.should be_able_to(:access, :info)
  #     end
  #
  #     it "can create feedbacks" do
  #       @ability.should be_able_to(:create, :feedbacks)
  #     end
  #
  #     it "cannot even create comments" do
  #       @ability.should_not be_able_to(:create, :comments)
  #       @ability.should_not be_able_to(:update, :comments)
  #       @ability.should_not be_able_to(:destroy, :comments)
  #       @ability.should_not be_able_to(:index, :comments)
  #     end
  #   end
  #
  #   describe "as normal user" do
  #     before(:each) do
  #       @user = Factory(:user)
  #       @ability = Ability.new(@user)
  #     end
  #
  #     it "can update himself, but not other users" do
  #       @ability.should be_able_to(:show, User.new)
  #       @ability.should be_able_to(:login, :users)
  #       @ability.should be_able_to(:logout, :users)
  #       @ability.should be_able_to(:create, :users)
  #       @ability.should be_able_to(:update, @user)
  #       @ability.should_not be_able_to(:update, User.new)
  #       @ability.should_not be_able_to(:ban, :users)
  #     end
  #
  #     it "can create feedback" do
  #       @ability.should be_able_to(:create, :feedback)
  #     end
  #
  #     it "can access any info pages" do
  #       @ability.should be_able_to(:access, :info)
  #     end
  #   end
  #

  describe 'as admin' do
    it 'can access all' do
      user = FactoryBot.create(:user, :admin)
      ability = Ability.new(user)
      expect(ability).to be_able_to(:access, :all)
    end
  end

  describe 'as papmanager' do
    it 'can crud all' do
      user = FactoryBot.create(:user, :papmgr)
      ability = Ability.new(user)
      #    schoolterm = FactoryBot.create(:schoolterm)
      expect(ability).to be_able_to(:crud, :all)
    end
  end

  describe 'as paplocaladmin' do
    let(:user) { FactoryBot.create(:user, :paplocaladm) }
    let(:payroll) { FactoryBot.create(:payroll) }
    let(:schoolterm) { FactoryBot.create(:schoolterm) }

    let(:registration) { FactoryBot.create(:registration) }
    let(:schoolyear) { FactoryBot.create(:schoolyear) }
    let(:program) { FactoryBot.create(:program) }
    let(:programname) { FactoryBot.create(:programname) }
    let(:student) { FactoryBot.create(:student) }
    let(:contact) { FactoryBot.create(:contact) }

    it 'can not crud all' do
      ability = Ability.new(user)
      expect(ability).not_to be_able_to(:crud, :all)
    end

    it '-dataentrypermitted? on the 28th' do
      pending('At least one payroll must exist in the database (seeded or created via the UI).')
      latest_payroll = Payroll.latest.first
      latest_term = Schoolterm.latest

      print 'Latest payroll: '
      puts latest_payroll.name
      print 'Latest term: '
      puts latest_term.name

      # ***********************************************************************
      # http://stackoverflow.com/questions/1215245/how-to-fake-time-now

      now = Time.parse('2017-04-28 00:10:00')
      allow(Time).to receive(:now) { now }

      # ***********************************************************************

      data_entry_permitted = latest_payroll.dataentrypermitted?

      expect(data_entry_permitted).to be true

      puts data_entry_permitted
    end

    it '-dataentrypermitted? not on the 3rd' do
      pending('At least one payroll must exist in the database (seeded or created via the UI).')

      #    user = FactoryBot.create(:user, :paplocaladm )
      #    payroll = FactoryBot.create(:payroll)
      #    schoolterm=FactoryBot.create(:schoolterm)

      latest_payroll = Payroll.latest.first
      latest_term = Schoolterm.latest

      print 'Latest payroll: '
      puts latest_payroll.name
      print 'Latest term: '
      puts latest_term.name

      # ***********************************************************************
      # http://stackoverflow.com/questions/1215245/how-to-fake-time-now

      now = Time.parse('2017-05-3 00:00:02')
      allow(Time).to receive(:now) { now }

      # ***********************************************************************

      data_entry_permitted = latest_payroll.dataentrypermitted?

      expect(data_entry_permitted).to be false

      puts data_entry_permitted
    end

    it '-dataentrypermitted? on latest payroll' do
      pending('At least one payroll must exist in the database (seeded or created via the UI).')

      #    user = FactoryBot.create(:user, :paplocaladm )
      #    payroll = FactoryBot.create(:payroll)

      latest_payroll = Payroll.latest.first
      #    latest_term=Schoolterm.latest

      print 'Latest payroll: '
      puts latest_payroll.name

      data_entry_status = latest_payroll.dataentrypermitted?

      expect(latest_payroll.dataentrypermitted?).to eq(data_entry_status)

      #  print "Latest term: "
      # puts latest_term.name
    end
  end
end
