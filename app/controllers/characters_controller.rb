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

        if @character.save
            redirect_to @character, notice: 'Character Created'
        else
            render :new
        end
    end

    def show
        @character = find_character_by_id(params[:id])
        if @character.nil?
            flash[:error] = 'Character not found'
            redirect_back fallback_location: :root
        end
    end

    def edit
        @character = find_character_by_id(params[:id])
    end

    def update
        @character = find_character_by_id(params[:id])
        @character.assign_attributes(character_params)

        if @character.save
            redirect_to @character, notice: 'Character Updated'
        else
            render :edit
        end
    end

    def destroy
        @character = find_character_by_id(params[:id])
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
            character_specializations_attributes: 
                [:id, :character_class, :subclass, :level, :spellcasting_ability_score, :_destroy]
        )
        ret[:user] = current_user
        ret
    end

    def find_character_by_id(id)
        ret = Character.find_by_id(id)
        if ret && ret.user != current_user
            flash[:error] = 'You must be the character\'s creator to access this method.'
            redirect_to :root
        end
        ret
    end
end

