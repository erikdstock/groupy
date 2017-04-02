require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe 'associations' do
    it { should have_many :monthly_top_artists }
  end
end
