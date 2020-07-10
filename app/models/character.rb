class Character < ApplicationRecord
    has_many :character_specializations
    belongs_to :user

    validates :name, :race, :user, presence: true

    RACES = [
        'Dragonborn', 'Hill Dwarf', 'Mountain Dwarf', 'Drow', 
        'High Elf', 'Wood Elf','Forest Gnome', 'Rock Gnome', 
        'Half-Elf', 'Half-Orc', 'Lightfoot Halfling', 'Stout Halfling',
        'Human', 'Tiefling'
    ]

    def self.all_races 
        RACES
    end
end
