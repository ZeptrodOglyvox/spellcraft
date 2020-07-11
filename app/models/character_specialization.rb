require_relative '../../lib/character_classes'

class CharacterSpecialization < ApplicationRecord
    has_many :available_spells
    has_many :spells, through: :available_spells, dependent: :destroy  # destroys the join entries, not the spells
    
    SUBCLASSES = CharacterClasses.get_all # TODO this is probably reloaded from the file all the time.
    ALL_CLASSES = SUBCLASSES.keys

    def self.all_classes 
        ALL_CLASSES
    end
    
    def self.subclasses
        SUBCLASSES
    end

    def self.all_subclasses
        SUBCLASSES.values.flatten
    end

    validates :character_class, presence: true, inclusion: {in: ALL_CLASSES, message: 'Invalid Class'}
    validate :subclass_is_valid
    validates :level, presence: true, inclusion: {in: (1..20), message: "Invalid level."}
    validates :spellcasting_ability_score, presence:true, inclusion: {in: (1..30), message: "Invalid ability score."}

    def subclass_is_valid
        if SUBCLASSES[character_class].nil? || 
            !SUBCLASSES[character_class].include?(subclass)
            errors.add(:subclass, "#{subclass} is not a valid subclass of #{character_class}.")
        end
    end
end
