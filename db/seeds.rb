# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

search_one = {
  text: "What's going on?",
  type: "Song"
  }
s1 = 51272
s2 = 880523
s3 = 31721
s4 = 2326824

Tag.create(context: "1990s",
            key_words: ["boy bands", "Britney Spears", "N'Sync",
                        "skateboarding", "fruit-by-the-foot", "hot pockets",
                        "jean jackets", "jeans", "hotdogs", "carefree days"],
                        )
