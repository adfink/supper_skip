User.create(full_name: 'Rachel Warbelow', email_address: 'demo+rachel@jumpstartlab.com', password: 'password', screen_name: '')
User.create(full_name: 'Jeff', email_address: 'demo+jeff@jumpstartlab.com', password: 'password', screen_name: 'j3')
User.create(full_name: 'Jorge Tellez', email_address: 'demo+jorge@jumpstartlab.com', password: 'password', screen_name: 'novohispano')
User.create(full_name: 'Josh Cheek', email_address: 'demo+josh@jumpstartlab.com', password: 'password', screen_name: 'josh')

role1 = Role.create(name: "admin")
role2 = Role.create(name: "cook")
role3 = Role.create(name: "delivery person")

owner1 = User.create(full_name: 'Whitney Houston', email_address: 'whit@whit.com', password: 'password', screen_name: 'whit')
owner2 = User.create(full_name: 'Justin Timberlake', email_address: 'just@just.com', password: 'password', screen_name: 'just')
owner3 = User.create(full_name: 'Drew Carey', email_address: 'drew@drew.com', password: 'password', screen_name: 'drew')
owner4 = User.create(full_name: 'Michael Jackson', email_address: 'mj@mj.com', password: 'password', screen_name: 'mj')
owner5 = User.create(full_name: 'Winston Churchill', email_address: 'win@win.com', password: 'password', screen_name: 'winny')

restaurant1 = owner1.restaurants.create(name: "Edible Eatery", description: "Everything is edible! Even the napkins. Indulge all your omnivourous cravings.", display_name:"edible")
restaurant2 = owner2.restaurants.create(name: "Uncle Daves Dumpster Dive", description: "Our uncle's name is Dave.  He found this food a few days ago.  It's cheap.", display_name: "dumpy")
restaurant3 = owner3.restaurants.create(name: "Happy Tummies", description: "your tummy is like the most important organ in your body.  keep it happy. eat our food", display_name: "tummy")
restaurant4 = owner4.restaurants.create(name: "Beans Galore", description: "so many beans....probably too many",display_name: "beans")
restaurant5 = owner5.restaurants.create(name: "Kabab Land", description: "we take food and we put it on a stick, then you eat it.", display_name: "kabab")

owner1.user_roles.create(restaurant_id: restaurant1.id, role_id:1)
owner2.user_roles.create(restaurant_id: restaurant2.id, role_id:1)
owner3.user_roles.create(restaurant_id: restaurant3.id, role_id:1)
owner4.user_roles.create(restaurant_id: restaurant4.id, role_id:1)
owner5.user_roles.create(restaurant_id: restaurant5.id, role_id:1)

category_names = ["Appetizers", "Lunch", "Dinner", "Desserts", "Soups", "Salads", "Favorites"]

Restaurant.all.each do |restaurant|
  2.times do
    restaurant.categories.create(name: category_names.sample)
  end
end

restaurant1.items.create([
  {name: 'Rocky Mountain Oysters',   description: 'Traditional bull balls served thinly sliced, deep fried and with a side of cocktail sauce.', price: 6.50, status: 'active', image_file_name: "RockyMtnOysters4.jpg", category_id: [1]},
  {name: 'Flaming Cactus and Chips', description: 'Cactus from southern mexico mixed into our delicious cheese and served to your table on fire!', price: 6.00, status: 'active', image_file_name: "808-chili-cheese-nachos.jpg", category_id: [2]},
  {name: 'Creamy Artichoke & Spinach Dip', description: 'A local favorite, served with pretzel sticks and thick cut chips', price: 7.00, status: 'active', image_file_name: "sa-dip.jpg", category_id: [2]},
  {name: 'Guacamole, Salsa and Chips', description: 'Watch you server mix what you want into the best guacamole you have tasted all day.', price: 7.50, status: 'active', image_file_name: "Guacomole.jpg", category_id: [1, 2]},
  {name: 'Cheese Sticks', description: 'A house favorite. This is the one we struggle to keep the kitchen away from.', price: 5.50, status: 'retired', image_file_name: "baked-mexican-cheese-sticks-51-576x383.jpg", category_id: [1, 2]},
  ])


restaurant2.items.create([
  {name: 'Kilimanjaro Kale and Potato Soup', description: 'Fresh kale, a perfect blend of seasonings and potatoes from the mountainous region of Idaho', price: 9.50, status: 'active', image_file_name: "PotatoKaleSoup.jpg"},
  {name: 'Chili', description: 'This hearty dish is loaded with 4 types of beans and buffalo burger.', price: 10.99, status: 'active', image_file_name: "chili-22_(1).jpg"},
  {name: 'Himalayan Thukpa', description: 'A traditional dish straight from Nepal.', price: 10.00, status: 'active', image_file_name: "Thukpa_Ready_1.JPG"},
  {name: 'Southwestern Tortilla Soup', description: 'We discovered the recipe for this rather spicy soup deep in the heart of the Andes Mountains.', price: 8.50, status: 'retired', image_file_name: "tortilla_soup.jpg"},
  {name: 'Broccoli Cheese Soup', description: "The perfect light dish for the day when you want to stay warm but are not 'too' hungry.", price: 9.00, status: 'active', image_file_name: "broccoli-cheese-soup-1-550.jpg"},
  ])


restaurant3.items.create([
  {name: 'Ranier Ribeye',             description: 'Only the best beef is never frozen and marinated in our world famous marinade. Served with Mashed Potatoes.', price: 14.99, status: 'active', image_file_name: "ribeye.jpg"},
  {name: 'The Mount McKinley Salad', description: 'People have traversed high ranges to get a taste of our Mckinley salad. This dish is sure to bring you back again.', price: 11.99, status: 'active', image_file_name: "salad.jpg"},
  {name: '5 Alarm Burger', description: 'Turn up the heat with jalapenos, pepper jack cheese, grilled onions and our house buffalo sauce.', price: 9.99, status: 'active', image_file_name: "Giraffas_BrutusBurger.jpg"},
  {name: 'Rack of Ribs', description: 'Our ribs are slow smoked and practically fall off the bone. Basted in our house special BBQ sauce.', price: 15.99, status: 'active', image_file_name: "full_rack_of_ribs.jpg"},
  {name: 'Curry Vegabowl', description: 'Inspired by a hiking trip in India, this dish will make your tastebuds tingle', price: 12.99, status: 'active', image_file_name: "vegetarian-curry-fresh-bowl-vancouver-1024x768.jpg"},
          ])


restaurant4.items.create([
  {name: 'Peach Crisp with Vanilla Ice Cream', description: 'Our peach crisp is so good its illegal on most mountain tops.', price: 6.99, status: 'active', image_file_name: "peach_cobbler.jpg"},
  {name: 'Carrot Cake', description: 'A good hearty dessert that will last you till morning.', price: 5.99, status: 'retired', image_file_name: "traditional-cakes-cute-white-and-brown-carrot-cake-decorating-idea-with-white-cream-orange-carrot-accent-with-celery-and-silver-fork-fancy-carrot-cake-decorating-ideas.jpg"},
  {name: 'Rhubarb Pie', description: 'Rhubarb grows wild and sometimes you can pick some while hiking. You do that and we will show you how to turn it into pie.', price: 5.99, status: 'active', image_file_name: "Rhubarb_pie.jpg"},
  {name: 'Hot Chocolate Supreme', description: 'We mix three types of chocolate and also build your mug out of chocalate so you can eat that too!', price: 8.99, status: 'active', image_file_name: "Gourmet-Hot-Cocoa-Rocky-Road-Hot-Chocolate.jpg"},
  {name: 'Homemade Caramel Fondue', description: '', price: 5.00, status: 'active', image_file_name: "Gourmet-Hot-Cocoa-Rocky-Road-Hot-Chocolate.jpg"}
])

restaurant5.items.create([
    {name: 'Ice Cream Kabab', description: 'Its ice cream on a stick. We didnt know it was possible either.  Just eat it', price: 65.99, status: 'active', image_file_name: "peach_cobbler.jpg"},
    {name: 'Carrot Cake Kabab', description: 'A good hearty dessert that will last you till morning.', price: 5.99, status: 'retired', image_file_name: "traditional-cakes-cute-white-and-brown-carrot-cake-decorating-idea-with-white-cream-orange-carrot-accent-with-celery-and-silver-fork-fancy-carrot-cake-decorating-ideas.jpg"},
    {name: 'Rhubarb Pie Kabab', description: 'Rhubarb grows wild and sometimes you can pick some while hiking. You do that and we will show you how to turn it into pie.', price: 5.99, status: 'active', image_file_name: "Rhubarb_pie.jpg"},
    {name: 'Hot Chocolate Supreme...Kabab', description: 'We mix three types of chocolate and also build your mug out of chocalate so you can eat that too! And then we put a stick through it so we can call it a kabab', price: 8.99, status: 'active', image_file_name: "Gourmet-Hot-Cocoa-Rocky-Road-Hot-Chocolate.jpg"},
    {name: 'Homemade Caramel Fondue Kabab. Its on a stick, dont ask questions', description: '', price: 5.00, status: 'active', category_ids: [], image_file_name: "Gourmet-Hot-Cocoa-Rocky-Road-Hot-Chocolate.jpg"}
  ])




order1  = Order.create(status: 'ordered',     user_id: 4)
order2  = Order.create(status: 'ordered',     user_id: 4)
order3  = Order.create(status: 'canceled',    user_id: 4)
order4  = Order.create(status: 'canceled',    user_id: 4)
order5  = Order.create(status: 'paid',        user_id: 4)
order6  = Order.create(status: 'paid',        user_id: 4)
order7  = Order.create(status: 'completed',   user_id: 4)
order8  = Order.create(status: 'completed',   user_id: 4)
order9  = Order.create(status: 'completed',   user_id: 4)
order10 = Order.create(status: 'completed',   user_id: 4)

order1.order_items.create(item_id:  1, quantity: 2)
order2.order_items.create(item_id:  1, quantity: 2)
order3.order_items.create(item_id:  1, quantity: 2)
order4.order_items.create(item_id:  1, quantity: 2)
order5.order_items.create(item_id:  1, quantity: 2)
order6.order_items.create(item_id:  1, quantity: 2)
order7.order_items.create(item_id:  1, quantity: 2)
order8.order_items.create(item_id:  1, quantity: 2)
order9.order_items.create(item_id:  1, quantity: 2)
order10.order_items.create(item_id: 1, quantity: 2)
