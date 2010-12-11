require 'test_helper'

class AlerterTest < ActiveSupport::TestCase

  test "should result as alerted if alert date is null" do
    assert meetings(:alerted_one).alerted?
  end

  test "should result as not alerted if alert date is not null" do
    assert !meetings(:to_send).alerted?
  end

end
