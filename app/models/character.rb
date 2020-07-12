class Character < ApplicationRecord
    has_many :character_specializations, dependent: :destroy, autosave: true
    accepts_nested_attributes_for :character_specializations, allow_destroy: true
    belongs_to :user
    
    RACES = [
        'Dragonborn', 'Hill Dwarf', 'Mountain Dwarf', 'Drow', 
        'High Elf', 'Wood Elf','Forest Gnome', 'Rock Gnome', 
        'Half-Elf', 'Half-Orc', 'Lightfoot Halfling', 'Stout Halfling',
        'Human', 'Tiefling'
    ]

    validates :name, :race, :user, presence: true
    validates :race, inclusion: {in: RACES, message: 'Invalid race'}
    validates_associated :character_specializations
    validate :unique_classes

    def self.all_races 
        RACES
    end

    def spells
        character_specializations.map(&:spells).flatten
    end

    def unique_classes
        arr = character_specializations.map(&:character_class)
        counts = arr.inject(Hash.new(0)) { |counts, cls|  counts[cls] += 1; counts}
        counts.select! { |_,v| v > 1 }
        if counts.any?
            errors.add(:character_specializations, "The following classes have been selected more than once: #{counts.keys.join(',')}")
        end
    end
end
