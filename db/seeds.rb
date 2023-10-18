require 'mapbox-sdk'
Mapbox.access_token = ""

puts "Cleaning Records..."
Store.delete_all
Item.delete_all
User.delete_all

puts "Create the master user"
# Create the master user with default location in Rudi-Dutschke-Straße 26, 10969 Berlin
User.create!(name: 'better',
             surname: 'shopper',
             email: 'bettershopper@bettershopper.com',
             password: '123456',
             latitude: 52.506931,
             longitude: 13.391634
             )

# Create Stores with their real-world information
store_data = [
  ['EDEKA Ungefroren' ,52.513684 ,13.4060088],
  ['LIDL Leip' ,52.5103726499999 ,13.3950062221126],
  ['EDEKA Annenstraße' ,52.507766 ,13.415128],
  ['NETTO Supermarket' ,52.516746 ,13.420105],
  ['BerlinASIA LEBENSMITTEL' ,52.5115103 ,13.4165757],
  ['REWE Litf' ,52.52233 ,13.4033909],
  ['NETTO Marken-Discount' ,52.4746327999999 ,13.4553717578071],
  ['LIDL Sonn' ,52.4753044 ,13.4513227],
  ['DÜZGÜN Supermarkt' ,52.4781326 ,13.4477401],
  ['KAUFLAND Berlin-Neukölln' ,52.4686178 ,13.442591],
  ['EUROGIDA' ,52.469888 ,13.4420344],
  ['BIO COMPANY' ,52.51066 ,13.4168797],
  ['ASIA LEBENSMITTEL' ,52.5115103 ,13.4165757],
  ['REWE TO GO BEI ARAL' ,52.5138544 ,13.421876],
  ['EDEKA Annenstraße' ,52.507766 ,13.415128],
  ['ALDI Nord' ,52.5065406 ,13.4162889],
  ['KAUFLAND Storkower' ,52.5336384 ,13.4572219],
  ['NETTO Marken-Discount' ,52.5341078 ,13.4514365],
  ['SPAR EXPRESS' ,52.5341078 ,13.4514365],
  ['ALDI Nord' ,52.5265323 ,13.458277],
  ['MÄC-GEIZ' ,52.5411818 ,13.4405578],
  ['LIDL Kni' ,52.5344952 ,13.4461438],
  ['KAUFLAND Herm' ,52.524014 ,13.46171],
  ['REWE Lan' ,52.5291187 ,13.4551573],
  ['PENNY Hermm' ,52.5227409 ,13.464873],
  ['REWE Kurf' ,52.4978714 ,13.2971416],
  ['PENNY Ku' ,52.498772 ,13.302941],
  ['GALERIA Markthalle' ,52.5036224 ,13.3328311],
  ['TC MARKT OPEN 24' ,52.4998394 ,13.3079665],
  ['EDELKORPB' ,52.4987072 ,13.2987243],
  ['REWE TO GO BEI ARAL Ku' ,52.49586865 ,13.287716290458],
  ['LIDL Knes' ,52.500475 ,13.321294],
  ['REWE Uhl' ,52.5009824 ,13.3248411],
  ['AMERICANFOOD4U' ,52.5032784 ,13.3300767],
  ['EDEKA Knesebeckstraße' ,52.50040645 ,13.3223217648596],
  ['HIT' ,52.5055145 ,13.3305178]
]

store_data.each do |name, lat, long|
  Store.create!(name: name, latitude: lat, longitude: long)
end

# Create Items with fictional prices

items_with_images = {
  'zucchini' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543623/Better%20Shopper/zucchini.jpg',
  'sausage' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543622/Better%20Shopper/sausage.jpg',
  'stew_meat' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543622/Better%20Shopper/stew_meat.jpg',
  'spinach' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543621/Better%20Shopper/spinach.jpg',
  'spaghetti' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543621/Better%20Shopper/spaghetti.jpg',
  'salad' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543620/Better%20Shopper/salad.jpg',
  'red_apple' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543619/Better%20Shopper/red_apple.jpg',
  'raspberry' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543618/Better%20Shopper/raspberry.jpg',
  'potato' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543618/Better%20Shopper/potato.jpg',
  'plant_based_milk' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543617/Better%20Shopper/plant_based_milk.jpg',
  'pear' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543616/Better%20Shopper/pear.jpg',
  'pasta' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543616/Better%20Shopper/pasta.jpg',
  'pack_salad' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543615/Better%20Shopper/pack_salad.jpg',
  'pack_pepper' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543614/Better%20Shopper/pack_pepper.jpg',
  'onion' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543614/Better%20Shopper/onion.jpg',
  'minced_meat' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543613/Better%20Shopper/minced_meat.jpg',
  'corn'  => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543613/Better%20Shopper/corn.jpg',
  'milk' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543612/Better%20Shopper/milk.jpg',
  'lemon' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543612/Better%20Shopper/lemon.jpg',
  'hot_pepper' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543611/Better%20Shopper/hot_pepper.jpg',
  'hamburger' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543610/Better%20Shopper/hamburger.jpg',
  'green_apple' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543610/Better%20Shopper/green_apple.jpg',
  'grapefruit' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543609/Better%20Shopper/grapefruit.jpg',
  'grape' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543609/Better%20Shopper/grape.jpg',
  'garlic' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543608/Better%20Shopper/garlic.jpg',
  'egg' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543608/Better%20Shopper/egg.jpg',
  'chicken_breast' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543607/Better%20Shopper/chicken_breast.jpg',
  'chicken_thigh' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543607/Better%20Shopper/chicken_thigh.jpg',
  'cherry_tomato' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543606/Better%20Shopper/cherry_tomato.jpg',
  'carrot' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543606/Better%20Shopper/carrot.jpg',
  'blackberry' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543605/Better%20Shopper/blackberry.jpg',
  'avocado' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543605/Better%20Shopper/avocado.jpg',
  'banana' => 'https://res.cloudinary.com/dw4vy98yd/image/upload/v1697543605/Better%20Shopper/banana.jpg'
}

stores = Store.all

items_with_images.each do |item_name, image_url|
  stores.each do |store|
    Item.create!(name: item_name, image_url: image_url, store: store, unit_price: rand(1.0..5.0).round(2))
    puts "Created #{item_name}, #{store.name}"
  end
end
