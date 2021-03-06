# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Spell.create([
    {
        name: 'Fireball', level: 3, description: 'A very good spell.', 
        casting_time: '1 ActIon', range: '30 feet', components: 'V, M (a rat\'s tail)',
        duration: 'instantaneous', concentration: true, ritual: false
    }
])

