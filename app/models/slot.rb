class Slot < ApplicationRecord
    has_many :slot_collections
    SLOT_MINUTES_OPTIONS = [0, 15, 30, 45]

    validates :total_capacity, :start_time, :end_time, presence: true
    validates :total_capacity, numericality: { only_integer: true, greater_than: 0 }
    validate :start_time_must_be_before_end_time
    validate :date_cannot_be_in_the_past
    validate :date_minutes

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
end
