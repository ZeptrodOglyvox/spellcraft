class CharacterSpecialization < ApplicationRecord
    has_many :spells, through: :available_spells
    has_many :caster_classes

    ALL_CLASSES = [
        'Wizard', 'Arcane Trickster'
    ]

    def self.all_classes 
        ALL_CLASSES
    end
end
