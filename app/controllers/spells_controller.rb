class SpellsController < ApplicationController
    def new
        @spell = Spell.new
    end

    def create
        creation_params = params.require(:spell).permit(*SPELL_ATTRIBUTES)

        @spell = Spell.new(creation_params)

        if @spell.save
            # TODO change to spell show
            redirect_to :root, notice: "Spell #{creation_params[:name]} created successfully."
        else
            render :new
        end
    end

    private

    SPELL_ATTRIBUTES = [
        :name, :description, :casting_time, :range, :duration, 
        :components, :level, :concentration, :ritual
    ]

    SPELL_LEVELS = ('1'..'9').to_a.unshift('Cantrip')
end
