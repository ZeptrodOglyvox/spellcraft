class HomeController < ApplicationController
    def test
        @spell = Spell.new
        @spell.caster_class_ids = [1,2]
        render :test
    end

    def test2
        # @spell = Spell.new
        # @spell = 
        # render :test
    end
end
