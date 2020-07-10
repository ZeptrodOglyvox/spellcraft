class CharactersController < ApplicationController
    before_action :require_authentication
    
    def index
        @characters = current_user.characters
    end
    
    def new
        @character = Character.new
    end

    def create 
        @character = Character.new(character_params)
        @character.user = current_user
        @character.character_specializations << CharacterSpecialization(character_specialization_params)
        if @character.save
            redirect_to :root, notice: 'Character Created'
        else
            render :new
        end
    end

    private

    def character_params
        params.require(:character).permit(:name, :race)
    end
end
