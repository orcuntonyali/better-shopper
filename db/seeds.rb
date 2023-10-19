require 'mapbox-sdk'
Mapbox.access_token = ""

puts "Cleaning Records..."
Store.delete_all
Item.delete_all
User.delete_all

puts "Create the master user"
# Create the master user with default location in Rudi-Dutschke-Straße 26, 10969 Berlin
User.create!(name: 'Mark',
             surname: 'Schönberger',
             email: 'bettershopper@bettershopper.com',
             password: '123456',
             address: 'Rudi-Dutschke-Straße 26, 10969 Berlin',
             latitude: 52.506931,
             longitude: 13.391634
             )

# Create Stores with their real-world information
store_data = [
  ['EDEKA Ungefroren' ,52.513684 ,13.4060088, 'Fischerinsel 12, 10179 Berlin, Germany'],
  ['LIDL Leip' ,52.5103726499999 ,13.3950062221126, 'Leipziger Straße 42, 10117 Berlin, Germany'],
  ['EDEKA Annenstraße' ,52.507766 ,13.415128, 'Annenstraße 4 A, 10179 Berlin, Germany'],
  ['NETTO Supermarket' ,52.516746 ,13.420105,   'Schillingstraße 1 A, 10179 Berlin, Germany'],
  ['BerlinASIA LEBENSMITTEL' ,52.5115103 ,13.4165757,   'Brückenstraße 15A, 10179 Berlin, Germany'],
  ['REWE Litf' ,52.52233 ,13.4033909, 'Litfaß-Platz 4, 10178 Berlin, Germany'],
  ['NETTO Marken-Discount' ,52.4746327999999 ,13.4553717578071, 'Sonnenallee 215, 12059 Berlin, Germany'],
  ['LIDL Sonn' ,52.4753044 ,13.4513227, 'Sonnenallee 192, 12059 Berlin, Germany'],
  ['DÜZGÜN Supermarkt' ,52.4781326 ,13.4477401, 'Sonnenallee 163, 12059 Berlin, Germany'],
  ['KAUFLAND Berlin-Neukölln' ,52.4686178 ,13.442591, 'Karl-Marx-Straße 231, 12055 Berlin, Germany'],
  ['EUROGIDA' ,52.469888 ,13.4420344, 'Karl-Marx-Straße 225, 12055 Berlin, Germany'],
  ['BIO COMPANY' ,52.51066 ,13.4168797, 'Köpenicker Straße 103, 10179 Berlin, Germany'],
  ['ASIA LEBENSMITTEL' ,52.5115103 ,13.4165757,'Brückenstraße 15A, 10179 Berlin, Germany'],
  ['REWE TO GO BEI ARAL' ,52.5138544 ,13.421876, 'Holzmarktstraße 12/14, 10179 Berlin, Germany'],
  ['EDEKA Annenstraße' ,52.507766 ,13.415128, 'Annenstraße 4 A, 10179 Berlin, Germany'],
  ['ALDI Nord' ,52.5065406 ,13.4162889, 'Heinrich-Heine-Platz 8-12, 10179 Berlin, Germany'],
  ['KAUFLAND Storkower' ,52.5336384 ,13.4572219, 'Storkower Straße 139, 10407 Berlin, Germany'],
  ['NETTO Marken-Discount' ,52.5341078 ,13.4514365, 'Storkower Straße 126, 10407 Berlin, Germany'],
  ['SPAR EXPRESS' ,52.5341078 ,13.4514365, 'Storkower Straße 126, 10407 Berlin, Germany'],
  ['ALDI Nord' ,52.5265323 ,13.458277, 'Storkower Straße 176, 10369 Berlin, Germany'],
  ['MÄC-GEIZ' ,52.5411818 ,13.4405578, 'Storkower Straße 7, 10409 Berlin, Germany'],
  ['LIDL Kni' ,52.5344952 ,13.4461438, 'Kniprodestraße 26, 10407 Berlin, Germany'],
  ['KAUFLAND Herm' ,52.524014 ,13.46171, 'Hermann-Blankenstein-Straße 38, 10249 Berlin, Germany'],
  ['REWE Lan' ,52.5291187 ,13.4551573, 'Landsberger Allee 117, 10407 Berlin, Germany'],
  ['PENNY Hermm' ,52.5227409 ,13.464873, 'Hermann-Blankenstein-Straße 40, 10249 Berlin, Germany'],
  ['REWE City' ,52.4978714 ,13.2971416, 'Kurfürstendamm 142, 10709 Berlin, Germany'],
  ['PENNY Ku' ,52.498772 ,13.302941, 'Kurfürstendamm 156, 10709 Berlin, Germany'],
  ['GALERIA Markthalle' ,52.5036224 ,13.3328311, 'Kurfürstendamm 231, 10719 Berlin, Germany'],
  ['TC MARKT OPEN 24' ,52.4998394 ,13.3079665, 'Kurfürstendamm 166, 10707 Berlin, Germany'],
  ['EDELKORPB' ,52.4987072 ,13.2987243, 'Kurfürstendamm 96, 10709 Berlin, Germany'],
  ['REWE TO GO BEI ARAL Ku' ,52.49586865 ,13.287716290458, 'Kurfürstendamm 128, 10711 Berlin, Germany'],
  ['LIDL Knes' ,52.500475 ,13.321294, 'Knesebeckstraße 48, 10719 Berlin, Germany'],
  ['REWE Uhl' ,52.5009824 ,13.3248411, 'Uhlandstraße 30, 10719 Berlin, Germany'],
  ['AMERICANFOOD4U' ,52.5032784 ,13.3300767, 'Kurfürstendamm 225, 10719 Berlin, Germany'],
  ['EDEKA Knesebeckstraße' ,52.50040645 ,13.3223217648596, 'Knesebeckstraße 56-58, 10719 Berlin, Germany'],
  ['HIT' ,52.5055145 ,13.3305178, 'Kantstraße 7, 10623 Berlin, Germany']
]

store_data.each do |name, lat, long, address|
  Store.create!(name: name, latitude: lat, longitude: long, address: address)
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
