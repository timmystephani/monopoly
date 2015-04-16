# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# first delete all
BoardSpace.all.each do |bs|
  bs.delete
end

board_spaces = [
  {
    name: 'GO', 
    position: 0
  },
  {
    name: 'Community Chest', 
    position: 2
  },
  {
    name: 'Community Chest', 
    position: 17
  },
  {
    name: 'Community Chest', 
    position: 33
  },
  {
    name: 'Income Tax', 
    position: 4
  },
  {
    name: 'Chance', 
    position: 7
  },
  {
    name: 'Chance', 
    position: 22
  },
  {
    name: 'Chance', 
    position: 36
  },
  {
    name: 'Visiting Jail', 
    position: 10
  },
  {
    name: 'Free Parking', 
    position: 20
  },
  {
    name: 'Go to Jail', 
    position: 30
  },
  {
    name: 'Luxury Tax', 
    position: 38
  },
]

BoardSpace.create(board_spaces)

properties = [
  {
    name: 'Meditterean Avenue',
    position: 1,
    purchase_price: 60,
    rent_price: 2
  },
  {
    name: 'Baltic Avenue',
    position: 3,
    purchase_price: 60,
    rent_price: 4
  },
  {
    name: 'Oriental Avenue',
    position: 6,
    purchase_price: 100,
    rent_price: 6
  },
  {
    name: 'Vermont Avenue',
    position: 8,
    purchase_price: 100,
    rent_price: 6
  },
  {
    name: 'Connecticut Avenue',
    position: 9,
    purchase_price: 120,
    rent_price: 8
  },
  {
    name: 'St. Charles Place',
    position: 11,
    purchase_price: 180,
    rent_price: 14
  },
  {
    name: 'States Avenue',
    position: 13,
    purchase_price: 140,
    rent_price: 10
  },
  {
    name: 'Virginia Avenue',
    position: 14,
    purchase_price: 160,
    rent_price: 12
  },
  {
    name: 'St. James Place',
    position: 16,
    purchase_price: 180,
    rent_price: 14
  },
  {
    name: 'Tennessee Avenue',
    position: 18,
    purchase_price: 180,
    rent_price: 14
  },
  {
    name: 'New York Avenue',
    position: 19,
    purchase_price: 200,
    rent_price: 16
  },
  {
    name: 'Kentucky Avenue',
    position: 21,
    purchase_price: 220,
    rent_price: 18
  },
  {
    name: 'Indiana Avenue',
    position: 23,
    purchase_price: 220,
    rent_price: 18
  },
  {
    name: 'Illionis Avenue',
    position: 24,
    purchase_price: 240,
    rent_price: 20
  },
  {
    name: 'Atlantic Avenue',
    position: 26,
    purchase_price: 260,
    rent_price: 22
  },
  {
    name: 'Ventor Avenue',
    position: 27,
    purchase_price: 260,
    rent_price: 22
  },
  {
    name: 'Marvin Gardens',
    position: 29,
    purchase_price: 280,
    rent_price: 22
  },
  {
    name: 'Pacific Avenue',
    position: 31,
    purchase_price: 300,
    rent_price: 26
  },
  {
    name: 'North Carolina Avenue',
    position: 32,
    purchase_price: 300,
    rent_price: 26
  },
  {
    name: 'Pennsylvania Avenue',
    position: 34,
    purchase_price: 320,
    rent_price: 28
  },
  {
    name: 'Park Place',
    position: 37,
    purchase_price: 350,
    rent_price: 35
  },
  {
    name: 'Boardwalk',
    position: 39,
    purchase_price: 400,
    rent_price: 50
  },
  {
    name: 'Electric Company',
    position: 12,
    purchase_price: 150,
    rent_price: 10
  },
  {
    name: 'Water Works',
    position: 28,
    purchase_price: 150,
    rent_price: 10
  }
]

Property.create(properties)

railroads = [
  {
    name: 'Reading Railroad', 
    position: 5,
    purchase_price: 200
  },
  {
    name: 'Pennsylvania Railroad', 
    position: 15,
    purchase_price: 200
  },
  {
    name: 'B&O Railroad', 
    position: 25,
    purchase_price: 200
  },
  {
    name: 'Short Line Railroad', 
    position: 35,
    purchase_price: 200
  }
]

RailRoad.create(railroads)