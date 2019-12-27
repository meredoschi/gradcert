# frozen_string_literal: true

class TestingAbility
  include CanCan::Ability

  def initialize(_user)
    can :read, User
    can :comment, User
    cannot :destroy, User
  end
end

describe 'CanCan custom RSpec::Matchers' do
  subject(:ability) { TestingAbility.new(user) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  it { should have_abilities(:read, other_user) }
  it { should have_abilities(:comment, other_user) }
  it { should have_abilities({ destroy: false }, other_user) }
  it { should have_abilities([:read], other_user) }
  it { should have_abilities(%i[read comment], other_user) }
  it { should have_abilities({ read: true }, other_user) }
  it { should have_abilities({ read: true, comment: true }, other_user) }
  it { should have_abilities({ read: true, destroy: false }, other_user) }
  it { should have_abilities({ read: true, comment: true, destroy: false }, other_user) }
  it { should not_have_abilities(:destroy, other_user) }
  it { should not_have_abilities([:destroy], other_user) }

  # These should all expect failure intentionally, to catch false positives.
  let(:expected_error) { RSpec::Expectations::ExpectationNotMetError }
  it { expect { should have_abilities(:destroy, other_user) }.to raise_error(expected_error) }
  it { expect { should have_abilities([:destroy], other_user) }.to raise_error(expected_error) }
  it {
    expect { should have_abilities(%i[read destroy], other_user) }
      .to raise_error(expected_error)
  }
  it {
    expect { should have_abilities({ read: true, destroy: true }, other_user) }
      .to raise_error(expected_error)
  }
  it {
    expect { should have_abilities({ read: false, destroy: false }, other_user) }
      .to raise_error(expected_error)
  }
  it {
    expect { should have_abilities({ read: false, destroy: true }, other_user) }
      .to raise_error(expected_error)
  }
  it {
    expect { should not_have_abilities(%i[read destroy], other_user) }
      .to raise_error(expected_error)
  }
  it {
    expect { should not_have_abilities({ destroy: false }, other_user) }
      .to raise_error(ArgumentError)
  }

  # Never use should_not with have_abilities.
end
