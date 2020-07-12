require_relative '../../lib/character_classes'

class CharacterSpecialization < ApplicationRecord
    has_many :available_spells
    has_many :spells, through: :available_spells, dependent: :destroy  # destroys the join entries, not the spells
    belongs_to :character 
    attr_accessor :should_add_default_spells
    before_save :add_default_spells, if: Proc.new{ @should_add_default_spells == '1' }
    
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

    def spells_by_level
        spells.inject(Hash.new{|h,k| h[k] = []}) { |ret, s| ret[s.level] << s; ret }
    end

    def user 
        character.user
    end

    def add_default_spells
        # TODO these will all probably come from the stock spell list
        # once that's a thing.

        def add_or_turn_default(spell_name, note)
            # Either associate the given spell with the specialization as default
            # or make it such if it is already in our spell list
            spl = Spell.find_by_name(spell_name)
            entry = available_spells.find_by_spell_id(spl.id)
            if entry
                entry.update(counts: false, note: note) 
            else 
                available_spells << AvailableSpell.create(
                    character_specialization_id: id, spell_id: spl.id, 
                    counts: false, note: note
                )
            end
        end

        # Detect the relevant default spells, if any. The important hashes here
        # are only race_spells and level_spells
        default_spells = YAML.load_file(ENV['DEFAULT_SPELL_DATA_PATH'])
        race_spells = default_spells['race'][character.race] 
        subclass_spells = default_spells['subclass'][subclass]
        level_spells = subclass_spells.select{|k,v| k <= level}.values if subclass_spells

        
        race_spells.each do |spell_name|
            add_or_upgrade_spell(spell_name, 'Default Race Spell.')
        end if race_spells

        if level_spells
            level_spells.each do |spell_name|
                add_or_upgrade_spell(spell_name, 'Default Class Spell.')
            end
        end
    end

    validates :character_class, presence: true, inclusion: {in: ALL_CLASSES, message: 'Invalid Class'}
    validate :subclass_is_valid
    validates :level, presence: true, inclusion: {in: (1..20), message: "Invalid level."}
    validates :spellcasting_ability_score, presence:true, inclusion: {in: (1..30), message: "Invalid ability score."}

    def subclass_is_valid
        if SUBCLASSES[character_class].nil? || !SUBCLASSES[character_class].include?(subclass)
            errors.add(:subclass, "#{subclass} is not a valid subclass of #{character_class}.")
        end
    end
end
