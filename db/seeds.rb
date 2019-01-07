# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

include SongSearchHelper

going_On_ids = [
  31721,
  51128,
  51272,
  880523,
  2326824
]
search_one = {
    text: "What's going on?",
    search_type: "Song"
    }

search = Search.create!(search_one)
going_On_ids.each do |id|
  Song.find_or_create_by(id: id)
  sync_song_and_search(id, search.id)
  SongWorker.confirm_referents_sync_song_and_find_trends(id)
  SearchWorker.new(search.id).create_keywords
end

bacon_ids = [68399]
search_two = {
  text: "bacon",
  search_type: "Song"
  }
search = Search.create(search_two)
bacon_ids.each do |id|
  Song.find_or_create_by(id: id)
  sync_song_and_search(id, search.id)
  SongWorker.confirm_referents_sync_song_and_find_trends(id)
  SearchWorker.new(search.id).create_keywords
  end

love_ids = [299177, 2263909, 2890553, 2342329, 3047141, 81672, 3944360, 3047141, 3047141, 1572772, 1572772]
search_three = {
  text: "love",
  search_type: "Song"
}
search = Search.create(search_three)
love_ids.each do |id|
  Song.find_or_create_by(id: id)
  sync_song_and_search(id, search.id)
  SongWorker.confirm_referents_sync_song_and_find_trends(id)
  SearchWorker.new(search.id).create_keywords
end

nsync_ids = [115478, 122037, 436280, 427373, 455498, 103200]
search_four = {
  text: "nysnc",
  search_type: "Song"
}
search = Search.create(search_four)
nsync_ids.each do |id|
  Song.find_or_create_by(id: id)
  sync_song_and_search(id, search.id)
  SongWorker.confirm_referents_sync_song_and_find_trends(id)
  SearchWorker.new(search.id).create_keywords
end

brit_ids = [218073, 110982, 2479757, 48169, 2832442, 193709, 3988]
search_five = {
  text: 'britney spears',
  search_type: "Song"
}
search = Search.create(search_five)
brit_ids.each do |id|
  Song.find_or_create_by(id: id)
  sync_song_and_search(id, search.id)
  SongWorker.confirm_referents_sync_song_and_find_trends(id)
  SearchWorker.new(search.id).create_keywords
end



Tag.create(context: "1990s",
            key_words: ["boy bands", "Britney Spears", "N'Sync",
                        "skateboarding", "fruit-by-the-foot", "hot pockets",
                        "jean jackets", "jeans", "hotdogs", "carefree days"]
                    )

Tag.create(context: "Ice Cream", key_words: [
    "soft",
    "milk",
    "sugar",
    'ice',
    "summers",
    "vanilla",
    "chocolate",
    "cream",
])

Tag.create(context: "Women's Fashion", key_words: [
  "Coco Chanel",
  "Donna Karan",
  "Giorgio Armani",
  "Calvin Klein",
  "Donatella Versace",
  "Ralph Lauren",
  "Christian Dior",
  "Tom Ford",
])

Tag.create( context: "Powerful People", key_words: [
    "Michael Bloomberg",
    "Warren Buffett",
    "Emmanuel Macron",
    "Mohammad Bin Salman Al Saud",
     "Jerome H. Powell",
    "Xi Jinping",
    "Vladimir Putin",
    "Donald Trump",
    "Angela Merkel",
    ]
    )

 Tag.create( context: "environmental words", key_words: [
  "green",
  "wind",
  "solar",
  "natural",
  "global",
  "globe",
  "protection",
  "conservation",
  "stewardship",
  "peace",
  "nature",
  "world",
  "environment",
  "environmental",
  "plants",
  "animals",
  "clean",
  "water",
])

TagWorker.find_or_create_potential_tags_and_post_trends
