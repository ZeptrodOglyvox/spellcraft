class CharactersController < ApplicationController
    before_action :require_authentication
    
    def index
        @characters = current_user.characters
    end
    
    def new
        @character = Character.new
        @character.character_specializations << CharacterSpecialization.new
        @character.character_specializations << CharacterSpecialization.new
    end

    def create 
        @character = Character.new(character_params) 
        # apparently nested fields are automatically created if params are given for them

        if @character.save
            redirect_to @character, notice: 'Character Created'
        else
            render :new
        end
    end

    def show
        @character = find_by_id(Character, params[:id])
        if @character.nil?
            flash[:error] = 'Character not found'
            redirect_back fallback_location: :root
        end
    end

    def edit
        @character = find_by_id(Character, params[:id])
    end

    def update
        @character = find_by_id(Character, params[:id])
        # TODO If update form is left unchanged, before_save callbacks don't execute
        # presumably because saving is avoided. Find a way to force save or the callback execution

        if @character.update(character_params)
            redirect_to @character, notice: 'Character Updated'
        else
            render :edit
        end
    end

    def edit_spells
        @charspec = find_by_id(CharacterSpecialization, params[:id])
        @spells = @charspec.spells
    end

    def update_spells
        @charspec = find_by_id(CharacterSpecialization, params[:id])
        @charspec.spells = Spell.where(id: params[:character_specialization][:spell_ids])

        if @charspec.save
            redirect_to @charspec.character, notice: 'Spells updated.'
        else
            render :edit_spells
        end
    end

    def destroy
        @character = find_by_id(Character, params[:id])
        if @character
            flash[:notice] = "Character #{@character.name} deleted."
            @character.destroy
        else
            flash[:error] = "Requested deletion of invalid character with id #{params[:id]}."
        end
        redirect_to :root
    end

    private

    def character_params
        ret = params.require(:character).permit(
            :name, :race,  
            character_specializations_attributes: [
                :id, :character_class, :subclass, :level, :spellcasting_ability_score, 
                :should_add_default_spells, :_destroy
            ]
        )
        ret[:user] = current_user
        ret
    end

    def find_by_id(model, id)
        ret = model.find_by_id(id)
        if ret && ret.user != current_user
            flash[:error] = 'You must be the character\'s creator to access this method.'
            redirect_to :root
        end
        ret
    end
end
