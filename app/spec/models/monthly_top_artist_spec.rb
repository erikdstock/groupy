require 'rails_helper'

RSpec.describe MonthlyTopArtist, type: :model do
  describe 'associations' do
    %i(user artist).each do |association|
      it { should belong_to association }
    end
  end
end
