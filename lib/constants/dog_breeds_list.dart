


var get_dog_breeds_list =  ['Abruzzenhund', 'Affenpinscher', 'Afghan Hound', 'Africanis',
  'Aidi', 'Ainu Dog', 'Airedale Terrier', 'Akbash Dog', 'Akitas', 'Akita (American)', 'Akita Inu (Japanese)',
  'Alano Español', 'Alapaha Blue Blood Bulldog', 'Alaskan Husky', 'Alaskan Klee Kai', 'Alaskan Malamute', 'Alopekis',
  'Alpine Dachsbracke', 'American Allaunt', 'American Alsatian', 'American Black and Tan Coonhound', 'American Blue Gascon Hound',
  'American Blue Lacy', 'American Bull Molosser', 'American Bulldog', 'American Bullnese', 'American Bully', 'American Cocker Spaniel',
  'American English Coonhound', 'American Eskimo Dog', 'American Foxhound', 'American Hairless Terrier', 'American Indian Dog',
  'American Lo-Sze Pugg ™', 'American Mastiff', 'American Mastiff (Panja)', 'American Pit Bull Terrier', 'American Staffordshire Terrier',
  'American Staghound', 'American Toy Terrier', 'American Water Spaniel', 'American White Shepherd', 'Anatolian Shepherd Dog', 'Andalusian Podenco',
  'Appenzell Mountain Dog', 'Ariegeois', 'Argentine Dogo', 'Armenian Gampr', 'Atlas Terrier', 'Australian Bandog', 'Australian Bulldog', 'Australian Cattle Dog',
  'Australian Cobberdog', 'Australian Kelpie', 'Australian Koolie', 'Australian Labradoodle', 'Australian Shepherd', 'Australian Stumpy Tail Cattle Dog',
  'Australian Terrier', 'Austrian Shorthaired Pinscher', 'Azawakh', 'Banter Bulldogge', 'Barbet', 'Basenji', 'Basset Artesien Normand', 'Basset Bleu de Gascogne',
  'Basset Fauve de Bretagne', 'Basset Hound', 'Bavarian Mountain Hound', 'Beagle', 'Beagle Harrier', 'Bearded Collie', 'Beauceron', 'Bedlington Terrier',
  'Belgian Griffons', 'Belgian Mastiff', 'Belgian Shepherd Groenendael', 'Belgian Shepherd Laekenois', 'Belgian Shepherd Malinois', 'Belgian Shepherd Tervuren',
  'Belgrade Terrier', 'Bergamasco', 'Berger Blanc Suisse', 'Berger des Picard', 'Berger des Pyrénées', 'Bernese Mountain Dog', 'Bhagyari Kutta', 'Bichon Frise',
  'Bichon Havanais', 'Biewer', 'Black and Tan Coonhound', 'Black Forest Hound', 'Black Mouth Cur', 'Black Norwegian Elkhound', 'Black Russian Terrier',
  'Bleus de Gascogne', 'Bloodhound', 'Blue Heeler', 'Blue Lacy', 'Blue Picardy Spaniel', 'Bluetick Coonhound', 'Boerboel', 'Bohemian Shepherd',
  'Bohemian Terrier', 'Bolognese', 'Bonsai Bulldogge', 'Border Collie', 'Border Terrier', 'Borzoi', 'Bosnian-Herzegovinian Sheepdog - Tornjak',
  'Boston Terrier', 'Bouvier des Flandres', 'Boxer', 'Boykin Spaniel', 'Bracco Italiano', 'Braque du Bourbonnais', 'Brazilian Terrier', 'Briard',
  'Brittany Spaniel', 'Briquet', 'Broholmer', 'Brussels Griffon', 'Bukovina Sheepdog', 'Buldogue Campeiro', 'Bull Terrier', 'Bully Kutta', 'Bulldog',
  'Bullmastiff', 'Cairn Terrier', 'Cajun Squirrel Dog', 'Cambodian Razorback Dog', 'Canaan Dog', 'Canadian Eskimo Dog', 'Canadian Inuit Dog', 'Canary Dog',
  'Cane Corso Italiano', 'Canis Panther', 'Canoe Dog', 'Cão da Serra da Estrela', 'Cão da Serra de Aires', 'Cão de Castro Laboreiro', 'Cão de Fila de São Miguel',
  'Caravan Hound', 'Carlin Pinscher', 'Carolina Dog', 'Carpathian Sheepdog', 'Catahoula Leopard Dog', 'Catalan Sheepdog', 'Cardigan Welsh Corgi',
  'Caucasian Ovtcharka', 'Cavalier King Charles Spaniel', 'Central Asian Ovtcharka', 'Cesky Fousek', 'Cesky Terrier', 'Chart Polski',
  'Chesapeake Bay Retriever', "Chien D'Artois", "Chien De L' Atlas", 'Chihuahua', 'Chin', 'Chinese Chongqing Dog', 'Chinese Crested',
  'Chinese Foo Dog', 'Chinese Imperial Dog', 'Chinese Shar-Pei', 'Chinook', 'Chow Chow', 'Cierny Sery', "Cirneco Dell'Etna", 'Clumber Spaniel',
  'Cocker Spaniel', 'Collie (Rough and Smooth)', 'Continental Bulldog', 'Continental Toy Spaniel', 'Corgi', 'Coton de Tulear', 'Cretan Hound',
  'Croatian Sheepdog', 'Curly-Coated Retriever', 'Czechoslovakian Wolfdog', 'Czesky Terrier', 'Dachshund', 'Dakotah Shepherd', 'Dalmatian',
  'Dandie Dinmont Terrier', 'Danish Broholmer', 'Danish-Swedish Farmdog', 'Denmark Feist', 'Deutsch Drahthaar', 'Deutscher Wachtelhund', 'Dingo',
  'Doberman Pinscher', 'Dogo Argentino', 'Dogue de Bordeaux', 'Dorset Olde Tyme Bulldogge', 'Drentse Patrijshond', 'Drever', 'Dutch Shepherd Dog',
  'Dutch Smoushond', 'East-European Shepherd', 'East Siberian Laika', 'English Bulldog', 'English Cocker Spaniel', 'English Coonhound',
  'English Foxhound', 'English Pointer', 'English Setter', 'English Shepherd', 'English Springer Spaniel', 'English Toy Spaniel', 'Entlebucher Sennenhund',
  'Estonian Hound', 'Estrela Mountain Dog', 'Eurasier', 'Farm Collie', 'Fauve de Bretagne', 'Feist', 'Field Spaniel', 'Fila Brasileiro', 'Finnish Hound',
  'Finnish Lapphund', 'Finnish Spitz', 'Flat-Coated Retriever', 'Foxhound', 'Fox Terrier', 'French Brittany Spaniel', 'French Bulldog', 'French Mastiff',
  'French Pointing Dog', 'French Spaniel', 'Galgo Español', 'German Hunt Terrier', 'German Longhaired Pointer', 'German Pinscher', 'German Sheeppoodle',
  'German Shepherd Dog', 'German Shorthaired Pointer', 'German Spitz', 'German Spitz Giant', 'German Spitz Medium', 'German Spitz Small',
  'German Wirehaired Pointer', 'Giant Maso Mastiff', 'Giant Schnauzer', 'Glen of Imaal Terrier', 'Golddust Yorkshire Terrier', 'Golden Retriever',
  'Gordon Setter', 'Grand Griffon Vendeen', 'Great Dane', 'Great Pyrenees', 'Greater Swiss Mountain Dog', 'Greek Hound', 'Greek Sheepdog',
  'Greenland Dog', 'Greyhound', 'Griffon Nivernais', 'Groenendael', 'Grosser Münsterlander Vorstehhund', 'Guatemalan Bull Terrier',
  'Hairless Khala', 'Halden Hound', 'Hamilton Hound', 'Harrier', 'Havanese', 'Hawaiian Poi Dog', 'Hellenikos Ichnilatis', 'Himalayan Sheepdog',
  'Hokkaido Dog', 'Hovawart', 'Hungarian Kuvasz', 'Hungarian Puli', 'Hungarian Wire-haired Pointing Dog', 'Husky', 'Ibizan Hound', 'Icelandic Sheepdog',
  'Inca Hairless Dog', 'Irish Red and White Setter', 'Irish Setter', 'Irish Staffordshire Bull Terrier', 'Irish Terrier', 'Irish Water Spaniel', 'Irish Wolfhound', 'Istrian Shorthaired Hound', 'Italian Greyhound', 'Italian Hound', 'Italian Spinoni', 'Jack Russell Terrier', 'Japanese Spaniel (Chin)', 'Japanese Spitz', 'Japanese Terrier', 'Jindo', 'Kai Dog', 'Kangal Dog', 'Kangaroo Dog', 'Karabash', 'Karakachan', 'Karelian Bear Dog', 'Karst Shepherd', 'Keeshond', 'Kelb Tal-Fenek', 'Kemmer Feist', 'Kerry Blue Terrier', 'King Charles Spaniel', 'King Shepherd', 'Kishu Ken', 'Klein Poodle', 'Kokoni', 'Komondor', 'Kooikerhondje', 'Koolie', 'Korean Dosa Mastiff', 'Krasky Ovcar', 'Kugsha Dog', 'Kunming Dog', 'Kuvasz', 'Kyi-Leo®', 'Labrador Husky', 'Labrador Retriever', 'Lagotto Romagnolo', 'Lakeland Terrier', 'Lakota Mastino', 'Lancashire Heeler', 'Landseer', 'Lapinporokoira', 'Lapphunds', 'Large Münsterländer', 'Larson Lakeview Bulldogge', 'Latvian Hound', 'Leavitt Bulldog', 'Leonberger', 'Lhasa Apso', 'Lithuanian Hound', 'Llewellin Setter', 'Louisiana Catahoula Leopard Dog', 'Löwchen (Little Lion Dog)', 'Lucas Terrier', 'Lundehund', 'Majestic Tree Hound', 'Maltese', 'Mammut Bulldog', 'Manchester Terrier', 'Maremma Sheepdog', 'Markiesje', 'Mastiff', 'McNab', 'Mexican Hairless', 'Mi-Ki', 'Middle Asian Ovtcharka', 'Miniature American Eskimo', 'Miniature Australian Bulldog', 'Miniature Australian Shepherd', 'Miniature Bull Terrier', 'Miniature Fox Terrier', 'Miniature Pinscher', 'Miniature Poodle', 'Miniature Schnauzer', 'Miniature Shar-Pei', 'Mioritic Sheepdog', 'Moscow Toy Terrier', 'Moscow Vodolaz', 'Moscow Watchdog', 'Mountain Cur', 'Mountain Feist', 'Mountain View Cur', 'Moyen Poodle', 'Mucuchies', 'Mudi', 'Munsterlander', 'Native American Indian Dog', 'Neapolitan Mastiff', 'Nebolish Mastiff', 'New Guinea Singing Dog', 'New Zealand Heading Dog', 'New Zealand Huntaway', 'Newfoundland', 'Norrbottenspets', 'Norfolk Terrier', 'North American Miniature Australian Shepherd', 'Northern Inuit Dog', 'Norwegian Buhund', 'Norwegian Elkhound', 'Norwegian Lundehund', 'Norwich Terrier', 'Nova Scotia Duck-Tolling Retriever', "Ol' Southern Catchdog", 'Old Danish Chicken Dog', 'Old English Mastiff', 'Old English Sheepdog (Bobtail)', 'Olde Boston Bulldogge', 'Olde English Bulldogge', 'Olde Victorian Bulldogge', 'Original English Bulldogge', 'Original Mountain Cur', 'Otterhound', 'Otto Bulldog', 'Owczarek Podhalanski', 'Pakistani Bull Dog (Gull Dong)', 'Pakistani Bull Terrier (Pakistani Gull Terr)', 'Pakistani Mastiff (Pakisani Bully Kutta)', 'Pakistani Shepherd Dog (Bhagyari Kutta)', 'Panda Shepherd', 'Papillon', 'Parson Russell Terrier', 'Patterdale Terrier', 'Pekingese', 'Pembroke Welsh Corgi', 'Perdiguero de Burgos', 'Perro Cimarron', 'Perro de Presa Canario', 'Perro de Presa Mallorquin', 'Perro Dogo Mallorquin', 'Perro Ratonero Andaluz', 'Peruvian Inca Orchid (PIO)', 'Petit Basset Griffon Vendeen', 'Petit Bleu de Gascogne', 'Petit Brabancon', 'Pharaoh Hound', 'Phu Quoc Ridgeback Dog', 'Pit Bull Terrier', 'Plott Hound', 'Plummer Hound', 'Pocket Beagle', 'Podenco Ibicenco', 'Pointer', 'Polish Hound', 'Polish Tatra Sheepdog', 'Polish Lowland Sheepdog', 'Pomeranian', 'Poodle', 'Porcelaine', 'Portuguese Hound', 'Portuguese Pointer', 'Portuguese Sheepdog', 'Portuguese Water Dog', 'Posavac Hound', 'Potsdam Greyhound', 'Prazsky Krysavik', 'Presa Canario', 'Pudelpointer', 'Pug', 'Puli (Pulik)', 'Pumi', 'Pyrenean Mastiff', 'Pyrenean Mountain Dog', 'Pyrenean Shepherd', 'Queensland Heeler', 'Queen Elizabeth Pocket Beagle', 'Rafeiro do Alentejo', 'Rajapalayam', 'Rampur Greyhound', 'Rat Terrier', 'Redbone Coonhound', 'Red-Tiger Bulldog', 'Rhodesian Ridgeback', 'Roman Rottweiler', 'Rottweiler', 'Rough Collie', 'Rumanian Sheepdog', 'Russian Bear Schnauzer', 'Russian Hound', 'Russian Spaniel', 'Russian Toy', 'Russian Tsvetnaya Bolonka', 'Russian Wolfhound', 'Russo-European Laika', 'Saarlooswolfhond', 'Sabueso Español', 'Sage Ashayeri', 'Saint Bernard', 'Saluki', 'Samoyed', 'Sarplaninac', 'Schapendoes', 'Schipperke', 'Schnauzer', 'Scotch Collie', 'Scottish Deerhound', 'Scottish Terrier (Scottie)', 'Sealydale Terrier', 'Sealyham Terrier', 'Segugio Italiano', 'Shar-Pei', 'Shetland Sheepdog (Sheltie)', 'Shiba Inu', 'Shih Tzu', 'Shikoku', 'Shiloh Shepherd', 'Siberian Husky', 'Siberian Laika', 'Silken Windhound', 'Silky Terrier', 'Simaku', 'Skye Terrier', 'Sloughi', 'Slovakian Hound', 'Slovakian Rough Haired Pointer', 'Slovensky Cuvac', 'Slovensky Hrubosrsty Stavac', 'Slovensky Kopov', 'Smalandsstovare', 'Small Bernese Hound', 'Small Greek Domestic Dog', 'Small Jura Hound', 'Small Lucerne Hound', 'Small Munsterlander', 'Small Schwyz Hound', 'Small Swiss Hound', 'Smooth Collie', 'Smooth Fox Terrier', 'Soft Coated Wheaten Terrier', 'South Russian Ovtcharka', 'Spanish Bulldog', 'Spanish Mastiff', 'Spanish Water Dog', 'Spinone Italiano', 'Springer Spaniel', 'Stabyhoun', 'Staffordshire Bull Terrier', 'Standard American Eskimo', 'Standard Poodle', 'Standard Schnauzer', "Stephens' Stock Mountain Cur", 'Sussex Spaniel', 'Swedish Vallhund', 'Swiss Laufhund', 'Swiss Shorthaired Pinscher', 'Taigan', 'Tamaskan Dog', 'Teacup Poodle', 'Teddy Roosevelt Terrier', 'Telomian', 'Tenterfield Terrier', 'Tepeizeuintli', 'Thai Bangkaew Dog', 'Thai Ridgeback', 'The Carolina Dog', 'Tibetan Mastiff', 'Tibetan Spaniel', 'Tibetan Terrier', 'Titan Bull-Dogge', 'Titan Terrier', 'Tornjak', 'Tosa Inu', 'Toy American Eskimo', 'Toy Fox Terrier', 'Toy Manchester Terrier', 'Toy Poodle', 'Transylvanian Hound', 'Treeing Tennessee Brindle', 'Treeing Walker Coonhound', 'Tuareg Sloughi', 'Utonagan', 'Victorian Bulldog', 'Villano de Las Encartaciones', 'Vizsla', 'Vucciriscu', 'Weimaraner', 'Welsh Corgi', 'Welsh Sheepdog', 'Welsh Springer Spaniel', 'Welsh Terrier', 'West Highland White Terrier (Westie)', 'West Siberian Laika', 'Wetterhoun', 'Wheaten Terrier', 'Whippet', 'White English Bulldog', 'White German Shepherd', 'White Swiss Shepherd', 'Wire Fox Terrier', 'Wirehaired Pointing Griffon', 'Wirehaired Vizsla', 'Xoloitzcuintle', 'Yorkshire Terrier', 'Yugoslavian Hound'];