require 'test_helper'

class TaskTest < ActiveSupport::TestCase


  test "should not save without description" do
    task = Task.new
    assert_not task.save, "Saved task without description"
  end
  

end
