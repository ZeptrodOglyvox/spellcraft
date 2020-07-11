class Character < ApplicationRecord
    has_many :character_specializations, dependent: :destroy, autosave: true
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

    def self.all_races 
        RACES
    end
end
