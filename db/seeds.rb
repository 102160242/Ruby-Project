# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
r = Random.new
### Add User ###
User.create(name: Faker::Name.name, email: "admin@gmail.com", password: "123456", admin: true)
200.times do |n|
    User.create(name: Faker::Name.name, email: "exampleuser#{n+1}@gmail.com", password: "123456", admin: false)
end

### Add followers for each User ###
count_u = User.count
count_u.times do |n|
    User.find(n+1).followers << User.where("users.id <> #{n+1}").order("RANDOM()").limit(r.rand(0..20))
end

### Add word ###
2000.times do |n|
    word_class = r.rand(1..4)
    stt = r.rand(1..8)
    ipas = ["ɪnˈteɡ.rə.ti", "ɪnˈhɑːns", "səˈfɪs.tɪ.keɪ.tɪd", "ˈæk.ses", "ɪˈfekt", "ˈkɑːn.tekst"]
    w = Word.new
    w.ipa = ipas[rand(ipas.size)]
    w.word = Faker::Creature::Animal.name
    w.meaning = Faker::Quote.most_interesting_man_in_the_world
    w.word_class = word_class
    w.image.attach(io: File.open(File.join(Rails.root, "app/assets/images/example/#{stt}.jpg")), filename: "#{stt}.jpg")
    w.save
end
### Add category ###
15.times do |n|
    stt = r.rand(1..8)
    c = Category.new
    c.name = Faker::Nation.capital_city
    c.image.attach(io: File.open(File.join(Rails.root, "app/assets/images/example/#{stt}.jpg")), filename: "#{stt}.jpg")
    c.save
end

### Add word to Category ###
total_w = Word.count
total_c = Category.count
total_w.times do |n|
    c = Category.find(r.rand(1..total_c))
    w = Word.find(n+1).categories
    w << c if(!w.include?(c)) 
end

### Add Question + Answer ###
1000.times do |n|
    q = Question.create(question_content: Faker::TvShows::GameOfThrones.quote, category_id: r.rand(1..total_c))
    if q.valid?
        right_answer = Random.new.rand(0..3)
        4.times do |k|
            if k == right_answer
                Answer.create(question_id: q.id, answer_content: Faker::TvShows::GameOfThrones.character, right_answer: true)
            else
                Answer.create(question_id: q.id, answer_content: Faker::TvShows::GameOfThrones.character, right_answer: false)
            end
        end   
    end
end
