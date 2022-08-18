class Slot < ApplicationRecord
    has_many :slot_collections
    SLOT_DURATION = 15 #minutes
    SLOT_MINUTES_OPTIONS = [0, 15, 30, 45]

    validates :total_capacity, :start_time, :end_time, presence: true
    validates :total_capacity, numericality: { only_integer: true, greater_than: 0 }
    validate :start_time_must_be_before_end_time
    validate :date_cannot_be_in_the_past
    validate :date_minutes
    validate :slot_not_taken

    scope :overlapping, ->(start_time, end_time) {
            where(["start_time <= ? and ? <= end_time", end_time, start_time ])
        }

    after_create :generate_slot_collections

    def generate_slot_collections
        capacities_to_be_alloted = total_capacity
        slot_collection_start_time = start_time

        available_slots_in_selected_duration.downto(1) do |available_slot|
            slot_capacity = capacities_to_be_alloted / available_slot
            slot_collection_end_time = slot_collection_start_time + SLOT_DURATION.minutes

            # create associated slot collection
            slot_collections.create(capacity: slot_capacity,
             start_time: slot_collection_start_time,
             end_time: slot_collection_end_time)

            slot_collection_start_time = slot_collection_end_time
            capacities_to_be_alloted -= slot_capacity
        end
    end

    def available_slots_in_selected_duration
        (time_duration_in_minutes / SLOT_DURATION).to_i
    end

    def time_duration_in_minutes
        time_duration / 1.minutes
    end

    def time_duration
        end_time - start_time
    end

    def as_json(options={})
        super(except: [:created_at, :updated_at],
            include: [slot_collections: { except: [:created_at, :updated_at]}]
        )
    end

    private

    def start_time_must_be_before_end_time
        if start_time.present? && end_time.present?
            errors.add(:start_time, :must_be_before_end_time) unless start_time < end_time
        end
    end

    def date_cannot_be_in_the_past
        if start_time.present? && start_time < Date.today
            errors.add(:start_time, :cant_be_in_past)
        end

        if end_time.present? && end_time < Date.today
            errors.add(:end_time, :cant_be_in_past)
        end
    end

    def date_minutes
        if start_time.present? && SLOT_MINUTES_OPTIONS.exclude?(start_time.min)
            errors.add(:start_time, :allowed_minutes_options, minutes: SLOT_MINUTES_OPTIONS.join(', '))
        end

        if end_time.present? && SLOT_MINUTES_OPTIONS.exclude?(end_time.min)
            errors.add(:end_time, :allowed_minutes_options, minutes: SLOT_MINUTES_OPTIONS.join(', '))
        end
    end

    def slot_not_taken
        if start_time.present? && end_time.present?
            errors.add(:start_time, :slot_taken) if Slot.overlapping(start_time, end_time).exists?
        end
    end
end
