class SpellsController < ApplicationController
    before_action :require_authentication

    def index
        @spells = Spell.all # .where('user_id = ? or user_id IS NULL', current_user.id)
    end

    def new
        @spell = Spell.new
    end

    def create
        @spell = Spell.new(spell_params)
        @spell.user = current_user
        if add_caster_classes(@spell) and @spell.save
            # TODO change to spell show
            redirect_to @spell, notice: "Spell #{spell_params[:name]} created successfully."
        else
            puts "HERE: " + @spell.caster_class_ids.inspect
            render :new
        end            
    end

    def show 
        @spell = get_spell_by_id(params[:id])
        
        if @spell.nil?
            flash.now[:error] = 'Spell id does not exist.'
            render :root
        end
    end

    def edit
        @spell = get_spell_by_id(params[:id])
        @spell.caster_class_ids = @spell.caster_classes.ids

        if @spell.nil?
            flash[:error] = 'Invalid spell id.'
            redirect_back fallback_location: :root
        end
    end

    def update
        @spell = Spell.get_spell_by_id(params[:id])

        @spell.assign_attributes(spell_params)

        if add_caster_classes(@spell) and @spell.save 
            redirect_to @spell, notice: 'Spell updated.'
        else
            render :edit
        end
    end

    def destroy
        @spell = get_spell_by_id(params[:id])
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
        ret = params.require(:spell).permit(*SPELL_ATTRIBUTES)
        ret[:caster_class_ids].delete("")
        ret[:caster_class_ids].map! {|x| x.to_i }
        ret
    end

    def add_caster_classes(spell)
        begin
            classes = CasterClass.find(spell_params[:caster_class_ids])
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

    def get_spell_by_id(id)
        spell = Spell.find_by_id(id)
        if spell and spell.user != current_user
            flash[:error] = 'You must be the spell\'s creator to access this page.'
            redirect_to :root
        end
        spell
    end
end
