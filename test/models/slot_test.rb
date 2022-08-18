require 'test_helper'

class SlotTest < ActiveSupport::TestCase
  test "should not create slot without required attributes" do
    slot = Slot.new
    assert slot.invalid?
    assert slot.errors.added? :total_capacity, :blank
    assert slot.errors.added? :start_time, :blank
    assert slot.errors.added? :end_time, :blank
  end

  test "should not create slot with negative total capacity" do
    slot = Slot.new(total_capacity: -5)
    assert slot.invalid?
    assert slot.errors.added? :total_capacity, :greater_than, count: 0
  end

  test "should not create slot with non integer total capacity" do
    slot = Slot.new(total_capacity: 5.1)
    assert slot.invalid?
    assert slot.errors.added? :total_capacity, :not_an_integer
  end

  test "should not create slot with start time before end time" do
    slot = Slot.new(start_time: 1.day.from_now, end_time: DateTime.now)
    assert slot.invalid?
    assert slot.errors.added? :start_time, :must_be_before_end_time
  end

  test "should not create slot with start time in the past" do
    slot = Slot.new(start_time: 1.day.ago)
    assert slot.invalid?
    assert slot.errors.added? :start_time, :cant_be_in_past
  end

  test "should not create slot with end time in the past" do
    slot = Slot.new(end_time: 1.day.ago)
    assert slot.invalid?
    assert slot.errors.added? :end_time, :cant_be_in_past
  end

  test "should not allow minutes other than specified in start time" do
    slot = Slot.new(start_time: DateTime.now.change({ min: 12}))
    assert slot.invalid?
    assert slot.errors.added? :start_time, :allowed_minutes_options, minutes: Slot::SLOT_MINUTES_OPTIONS.join(', ')
  end

  test "should not allow minutes other than specified in end time" do
    slot = Slot.new(end_time: DateTime.now.change({ min: 12}))
    assert slot.invalid?
    assert slot.errors.added? :end_time, :allowed_minutes_options, minutes: Slot::SLOT_MINUTES_OPTIONS.join(', ')
  end

  test "should not create slot with overlapping time" do
    slot = Slot.new(start_time: 1.day.from_now.change({ min: 15}), end_time: 1.day.from_now.change({ min: 30}))
    assert slot.invalid?
    assert slot.errors.added? :start_time, :slot_taken
  end

  test "should create slot with required attributes" do
    slot = Slot.new(total_capacity: 5,
      start_time: 1.day.from_now.change({ min: 0}),
      end_time: 1.day.from_now.change({ min: 30})
    )
    assert slot.valid?
  end
end
