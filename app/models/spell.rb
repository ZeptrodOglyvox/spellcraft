class Spell < ApplicationRecord
    has_and_belongs_to_many :caster_classes
    has_and_belongs_to_many :schools

    attr_accessor :caster_class_ids

    before_validation :downcase_everything
    
    validate :has_caster_classes, :casting_time_is_legal, :range_is_legal, :components_are_legal, :duration_is_legal

    validates :name, :description, :casting_time, :range, :duration, :components, presence: true
    validates :level, presence: true, inclusion: {in: (0..9), message: 'Spell must be either a cantrip or have a level 1-9'}
    validates :school, presence: true, inclusion: {in: self.class.schools, message: 'Invalid School value.'}
    validates :concentration, inclusion: {in: [true, false], message: 'Invalid Concentration value.'}
    validates :ritual, inclusion: {in: [true, false], message: 'Invalid Ritual value.'}

    def self.schools
        ['Conjuration',  'Necromancy', 'Evocation', 'Abjuration', 'Transmutation', 'Divination', 'Enchantment', 'Illusion']
    end

    # TODO make school and class mandatory
    def casting_time_is_legal
        if casting_time
            specific = ['1 action', '1 bonus action', '1 reaction', 'special']
            time_units = /[1-9]\d* (round|second|minute|hour|day|week|month|year)s?/
            
            # TODO figure out pluralization if somehow you get '10 year' etc.
            if not (specific.include?(casting_time) or casting_time =~ time_units)
                errors.add(:casting_time, 'Please provide a valid casting time. (e.g. "1 bonus action", "1 day")')
            end
        end
    end

    def range_is_legal
        if range
            specific = ['self', 'touch', 'special', '1 foot', '1 mile']
            length_units = /[1-9]\d* (feet|miles)/
            
            if not (specific.include?(range) or range =~ length_units)
                errors.add(:range, 'Please provide a valid range. (e.g. "self", "62 feet")')
            end
        end
    end

    def components_are_legal
        if components
            components_list = components.split(', ')
            components_list.delete('V')
            components_list.delete('S')
            components_list.delete_if { |item| item =~ /M *(\(.*\))?/ }
            
            if not components_list.empty?
                errors.add(:components_list, 'The only allowed components are V, S and M, optionally with the material components\' description in parentheses.')
            end
        end
    end

    def duration_is_legal
        if duration
            specific = ['instantaneous', 'until dispelled', 'until triggered', 'until dispelled or triggered', 'special']
            time_units = /[1-9]\d* (round|second|minute|hour|day|week|month|year)s?/

            if not (specific.include?(duration) or duration =~ time_units)
                errors.add(:duration, 'Please specify a valid duration. (e.g. "instantaneous", "until dispelled", "10 days")')
            end

            if duration == 'instantaneous' and concentration
                errors.add(:duration, 'Concentration spell can\'t be instantaneous.')
            end
        end
    end

    def downcase_everything
        if [casting_time, range].all?
            casting_time.downcase!
            range.downcase!
        end
    end

    def has_caster_classes
        caster_class_ids.delete('')
        if caster_class_ids.empty?
            errors.add(:caster_class_ids, 'Spell must belong to at least one caster class.')
        end
    end
end
