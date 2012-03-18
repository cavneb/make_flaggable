require 'spec_helper'

describe Flagging do
  describe "attributes should be white listed" do
    it { should allow_mass_assignment_of(:flaggable) }
    it { should allow_mass_assignment_of(:flagger) }
    it { should allow_mass_assignment_of(:flag) }
  end
end

