require 'spec_helper'
require 'bot'

class Bot
  describe Brain do
    let(:brain) { Brain.new }

    specify do
      brain.move.should eq "C0"
      brain.move.should eq "C1"
      brain.move.should eq "C2"
    end

    specify do
      brain.move.should eq "C0"
      brain.move.should eq "C1"
      brain.move.should eq "C2"
      brain.move.should eq "A0"
    end

    specify do
      brain.see_opponent_move("A0")
      brain.move.should eq "C0"
      brain.move.should eq "C1"
      brain.move.should eq "C2"
      brain.move.should eq "B0"
    end

    specify do
      brain.see_opponent_move("C0")
      brain.move.should eq "B0"
      brain.move.should eq "B1"
      brain.move.should eq "B2"
    end

    specify do
      brain.see_opponent_move("C0")
      brain.move.should eq "B0"
      brain.see_opponent_move("C1")
      brain.move.should eq "C2"
    end

    specify do
      brain.see_opponent_move("A0")
      brain.move.should eq "C0"
      brain.see_opponent_move("A2")
      brain.move.should eq "A1"
    end

    specify do
      brain.see_opponent_move("B0")
      brain.see_opponent_move("C0")
      brain.move.should eq "A0"
      brain.move.should eq "A1"
      brain.move.should eq "A2"
    end
  end
end
