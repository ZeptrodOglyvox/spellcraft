class AvailableSpell < ApplicationRecord
    belongs_to :character_specialization
    belongs_to :spell
end