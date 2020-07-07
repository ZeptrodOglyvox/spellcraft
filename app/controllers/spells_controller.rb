class SpellsController < ApplicationController
    def index
        @spells = Spell.all
    end

    def new
        @spell = Spell.new
    end

    def create
        @spell = Spell.new(spell_params)
        if add_caster_classes(@spell) and @spell.save
            # TODO change to spell show
            redirect_to @spell, notice: "Spell #{spell_params[:name]} created successfully."
        else
            render :new
        end            
    end

    def show 
        @spell = Spell.find_by_id(params[:id])
        
        if @spell.nil?
            flash.now[:error] = 'Spell id does not exist.'
            render :root
        end
    end

    def edit
        @spell = Spell.find_by_id(params[:id])

        if @spell.nil?
            flash[:error] = 'Invalid spell id.'
            redirect_back fallback_location: :root
        end
    end

    def update
        @spell = Spell.find_by_id(params[:id])

        @spell.assign_attributes(spell_params)

        if add_caster_classes(@spell) and @spell.save 
            redirect_to @spell, notice: 'Spell updated.'
        else
            render :edit
        end
    end

    def destroy
        @spell = Spell.find_by_id(params[:id])
        if @spell.nil?
            flash[:error] = 'Invalid spell id.'
        else 
            @spell.destroy
            flash[:notice] = "Spell '#{@spell.name}' deleted."
        end
        redirect_back fallback_location: :root
    end

    private

    SPELL_ATTRIBUTES = [
        :name, :description, :casting_time, :range, :duration, :school,
        :components, :level, :concentration, :ritual, caster_class_ids: []
    ]

    def spell_params
        params.require(:spell).permit(*SPELL_ATTRIBUTES)
    end

    def add_caster_classes(spell)
        begin
            classes = CasterClass.find(class_ids)
        rescue ActiveRecord::RecordNotFound
            flash[:error] = "Requested invalid class ids: #{ids}"
            nil
        else
            classes.each do |c|
                if not spell.caster_classes.include?(c)
                    spell.caster_classes << c
                end
            end
            true
        end
    end

    def class_ids 
        ret = spell_params[:caster_class_ids]
        ret.delete("")
        ret.map {|x| x.to_i }
        ret
    end

end
