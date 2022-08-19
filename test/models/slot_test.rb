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
      start_time: 2.days.from_now.change({ min: 0}),
      end_time: 2.days.from_now.change({ min: 30})
    )
    assert slot.valid?
  end

  test "should create slot collections after creating slot" do
    st = 7.days.from_now.change({ min: 0})
    et = 7.days.from_now.change({ min: 30})
    slot = Slot.create(total_capacity: 5,
      start_time: st,
      end_time: et
    )

    # check the associated slot collections are created
    assert slot.slot_collections.exists?

    # for mentioned duration i.e. 30 minutes,
    # with 15 minutes slot duration, it should create 2 slot collections
    assert_equal slot.slot_collections.count, 2

    # check values of corresponding fields
    first_slot_collection = slot.slot_collections.first
    assert_equal first_slot_collection[:slot_id], slot.id
    assert_equal first_slot_collection[:capacity], 2
    assert_equal first_slot_collection[:start_time], st
    assert_equal first_slot_collection[:end_time], st + Slot::SLOT_DURATION.minutes

    second_slot_collection = slot.slot_collections.last
    assert_equal second_slot_collection[:slot_id], slot.id
    assert_equal second_slot_collection[:capacity], 3
    assert_equal second_slot_collection[:start_time], st + Slot::SLOT_DURATION.minutes
    assert_equal second_slot_collection[:end_time], et
  end
end
