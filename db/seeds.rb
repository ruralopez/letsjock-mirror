#Athletics -- id=1
Sport.create( :name=> 'Athletics' ,  :parent_id=> '' ,  :fullpath => '/1')

Sport.create( :name=> 'Speed' ,  :parent_id=> '1' ,  :fullpath => '/1/2')
Sport.create( :name=> '4x400' ,  :parent_id=> '2' ,  :fullpath => '/1/2/3')
Sport.create( :name=> '4x100' ,  :parent_id=> '2' ,  :fullpath => '/1/2/4')
Sport.create( :name=> '50m' ,  :parent_id=> '2' ,  :fullpath => '/1/2/5')
Sport.create( :name=> '100m' ,  :parent_id=> '2' ,  :fullpath => '/1/2/6')
Sport.create( :name=> '200m' ,  :parent_id=> '2' ,  :fullpath => '/1/2/7')
Sport.create( :name=> '400m' ,  :parent_id=> '2' ,  :fullpath => '/1/2/8')
Sport.create( :name=> '100hurdles' ,  :parent_id=> '2' ,  :fullpath => '/1/2/9')
Sport.create( :name=> '110hurdles' ,  :parent_id=> '2' ,  :fullpath => '/1/2/10')
Sport.create( :name=> '400hurdles' ,  :parent_id=> '2' ,  :fullpath => '/1/2/11')

Sport.create( :name=> 'Endurance' ,  :parent_id=> '1' ,  :fullpath => '/1/12')
Sport.create( :name=> '800m' ,  :parent_id=> '12' ,  :fullpath => '/1/12/13')
Sport.create( :name=> '1500m' ,  :parent_id=> '12' ,  :fullpath => '/1/12/14')
Sport.create( :name=> '5000m' ,  :parent_id=> '12' ,  :fullpath => '/1/12/15')
Sport.create( :name=> '10000m' ,  :parent_id=> '12' ,  :fullpath => '/1/12/16')
Sport.create( :name=> '3000obs' ,  :parent_id=> '12' ,  :fullpath => '/1/12/17')
Sport.create( :name=> 'Marathon' ,  :parent_id=> '12' ,  :fullpath => '/1/12/18')
Sport.create( :name=> 'Walk20' ,  :parent_id=> '12' ,  :fullpath => '/1/12/19')
Sport.create( :name=> 'Walk50' ,  :parent_id=> '12' ,  :fullpath => '/1/12/20')

Sport.create( :name=> 'Jump' ,  :parent_id=> '1' ,  :fullpath => '/1/21')
Sport.create( :name=> 'High Jump' ,  :parent_id=> '21' ,  :fullpath => '/1/21/22')
Sport.create( :name=> 'Long Jump' ,  :parent_id=> '21' ,  :fullpath => '/1/21/23')
Sport.create( :name=> 'Pole Vault' ,  :parent_id=> '21' ,  :fullpath => '/1/21/24')
Sport.create( :name=> 'Triple Jump' ,  :parent_id=> '21' ,  :fullpath => '/1/21/25')

Sport.create( :name=> 'Throw' ,  :parent_id=> '1' ,  :fullpath => '/1/26')
Sport.create( :name=> 'Hammer' ,  :parent_id=> '26' ,  :fullpath => '/1/26/27')
Sport.create( :name=> 'Discus' ,  :parent_id=> '26' ,  :fullpath => '/1/26/28')
Sport.create( :name=> 'Javalin' ,  :parent_id=> '26' ,  :fullpath => '/1/26/29')
Sport.create( :name=> 'Shot Put' ,  :parent_id=> '26' ,  :fullpath => '/1/26/30')

Sport.create( :name=> 'Combined' ,  :parent_id=> '1' ,  :fullpath => '/1/31')
Sport.create( :name=> 'Heptathlon' ,  :parent_id=> '31' ,  :fullpath => '/1/31/32')
Sport.create( :name=> 'Decathlon' ,  :parent_id=> '31' ,  :fullpath => '/1/31/33')

#Badminton -- id=34
Sport.create( :name=> 'Badminton' ,  :parent_id=> '' ,  :fullpath => '/34')

#Basketball -- id=35
Sport.create( :name=> 'Basketball' ,  :parent_id=> '' ,  :fullpath => '/35')

#Handball -- id=36
Sport.create( :name=> 'Handball' ,  :parent_id=> '' ,  :fullpath => '/36')

#Boxing -- id=37
Sport.create( :name=> 'Boxing' ,  :parent_id=> '' ,  :fullpath => '/37')

#Canoeing -- id=38
Sport.create( :name=> 'Canoeing' ,  :parent_id=> '' ,  :fullpath => '/38')

#Cycling -- id=39
Sport.create( :name=> 'Cycling' ,  :parent_id=> '' ,  :fullpath => '/39')
Sport.create( :name=> 'Road' ,  :parent_id=> '39' ,  :fullpath => '/39/40')
Sport.create( :name=> 'Track' ,  :parent_id=> '39' ,  :fullpath => '/39/41')
Sport.create( :name=> 'Mountain' ,  :parent_id=> '39' ,  :fullpath => '/39/42')
Sport.create( :name=> 'BMX' ,  :parent_id=> '39' ,  :fullpath => '/39/43')

#Fencing -- id=44
Sport.create( :name=> 'Fencing' ,  :parent_id=> '' ,  :fullpath => '/44')
Sport.create( :name=> 'Epee' ,  :parent_id=> '44' ,  :fullpath => '/44/45')
Sport.create( :name=> 'Foil' ,  :parent_id=> '44' ,  :fullpath => '/44/46')

#Soccer -- id=47
Sport.create( :name=> 'Soccer' ,  :parent_id=> '' ,  :fullpath => '/47')
Sport.create( :name=> 'Five-a-Side' ,  :parent_id=> '47' ,  :fullpath => '/47/48')
Sport.create( :name=> 'Futsal' ,  :parent_id=> '47' ,  :fullpath => '/47/49')

#Gymnastics -- id=50
Sport.create( :name=> 'Gymnastics' ,  :parent_id=> '' ,  :fullpath => '/50')

Sport.create( :name=> 'Artistic' ,  :parent_id=> '50' ,  :fullpath => '/50/51')
Sport.create( :name=> 'Individual Complete' ,  :parent_id=> '50' ,  :fullpath => '/50/52')
Sport.create( :name=> 'Floor' ,  :parent_id=> '50' ,  :fullpath => '/50/53')
Sport.create( :name=> 'Floor Exercise' ,  :parent_id=> '50' ,  :fullpath => '/50/54')
Sport.create( :name=> 'Rings' ,  :parent_id=> '50' ,  :fullpath => '/50/55')
Sport.create( :name=> 'Vault' ,  :parent_id=> '50' ,  :fullpath => '/50/56')
Sport.create( :name=> 'Parallel Bars' ,  :parent_id=> '50' ,  :fullpath => '/50/57')
Sport.create( :name=> 'Pommel Horse' ,  :parent_id=> '50' ,  :fullpath => '/50/58')
Sport.create( :name=> 'Uneven Bars' ,  :parent_id=> '50' ,  :fullpath => '/50/59')
Sport.create( :name=> 'Balance Beam' ,  :parent_id=> '50' ,  :fullpath => '/50/60')

#Weightlifting -- id=61
Sport.create( :name=> 'Weightlifting' ,  :parent_id=> '' ,  :fullpath => '/61')

#Equestrian -- id=62
Sport.create( :name=> 'Equestrian' ,  :parent_id=> '' ,  :fullpath => '/62')

#Hockey -- id=63
Sport.create( :name=> 'Hockey' ,  :parent_id=> '' ,  :fullpath => '/63')

Sport.create( :name=> 'Field' ,  :parent_id=> '63' ,  :fullpath => '/63/64')
Sport.create( :name=> 'Roller' ,  :parent_id=> '63' ,  :fullpath => '/63/65')
Sport.create( :name=> 'Ice' ,  :parent_id=> '63' ,  :fullpath => '/63/66')

#Judo -- id=67
Sport.create( :name=> 'Judo' ,  :parent_id=> '' ,  :fullpath => '/67')

#Wrestling -- id=68
Sport.create( :name=> 'Wrestling' ,  :parent_id=> '' ,  :fullpath => '/68')

#Swimming -- id=69
Sport.create( :name=> 'Swimming' ,  :parent_id=> '' ,  :fullpath => '/69')

Sport.create( :name=> 'Synchronized' ,  :parent_id=> '69' ,  :fullpath => '/69/70')
Sport.create( :name=> '10k' ,  :parent_id=> '69' ,  :fullpath => '/69/71')

Sport.create( :name=> 'Freestyle' ,  :parent_id=> '69' ,  :fullpath => '/69/72')
Sport.create( :name=> '50m' ,  :parent_id=> '72' ,  :fullpath => '/69/72/73')
Sport.create( :name=> '100m' ,  :parent_id=> '72' ,  :fullpath => '/69/72/74')
Sport.create( :name=> '200m' ,  :parent_id=> '72' ,  :fullpath => '/69/72/75')
Sport.create( :name=> '400m' ,  :parent_id=> '72' ,  :fullpath => '/69/72/76')
Sport.create( :name=> '1500m' ,  :parent_id=> '72' ,  :fullpath => '/69/72/77')
Sport.create( :name=> '4x200' ,  :parent_id=> '72' ,  :fullpath => '/69/72/78')
Sport.create( :name=> '4x100' ,  :parent_id=> '72' ,  :fullpath => '/69/72/79')

Sport.create( :name=> 'Backstroke' ,  :parent_id=> '69' ,  :fullpath => '/69/80')
Sport.create( :name=> '100m' ,  :parent_id=> '80' ,  :fullpath => '/69/80/81')
Sport.create( :name=> '200m' ,  :parent_id=> '80' ,  :fullpath => '/69/80/82')

Sport.create( :name=> 'Breaststroke' ,  :parent_id=> '69' ,  :fullpath => '/69/83')
Sport.create( :name=> '100m' ,  :parent_id=> '83' ,  :fullpath => '/69/83/84')
Sport.create( :name=> '200m' ,  :parent_id=> '83' ,  :fullpath => '/69/83/85')

Sport.create( :name=> 'Butterfly' ,  :parent_id=> '69' ,  :fullpath => '/69/86')
Sport.create( :name=> '100m' ,  :parent_id=> '86' ,  :fullpath => '/69/86/87')
Sport.create( :name=> '200m' ,  :parent_id=> '86' ,  :fullpath => '/69/86/88')

Sport.create( :name=> 'Medley' ,  :parent_id=> '69' ,  :fullpath => '/69/89')
Sport.create( :name=> '200m' ,  :parent_id=> '89' ,  :fullpath => '/69/89/90')
Sport.create( :name=> '400m' ,  :parent_id=> '89' ,  :fullpath => '/69/89/91')
Sport.create( :name=> '4x100' ,  :parent_id=> '89' ,  :fullpath => '/69/89/92')

#Rowing -- id=93
Sport.create( :name=> 'Rowing' ,  :parent_id=> '' ,  :fullpath => '/93')

Sport.create( :name=> 'M1X' ,  :parent_id=> '93' ,  :fullpath => '/93/94')
Sport.create( :name=> 'M2X' ,  :parent_id=> '93' ,  :fullpath => '/93/95')
Sport.create( :name=> 'M4X' ,  :parent_id=> '93' ,  :fullpath => '/93/96')
Sport.create( :name=> 'M2-' ,  :parent_id=> '93' ,  :fullpath => '/93/97')
Sport.create( :name=> 'M4-' ,  :parent_id=> '93' ,  :fullpath => '/93/98')
Sport.create( :name=> 'M8+' ,  :parent_id=> '93' ,  :fullpath => '/93/99')
Sport.create( :name=> 'LM2X' ,  :parent_id=> '93' ,  :fullpath => '/93/100')
Sport.create( :name=> 'LM4X' ,  :parent_id=> '93' ,  :fullpath => '/93/101')

#Diving -- id=102
Sport.create( :name=> 'Diving' ,  :parent_id=> '' ,  :fullpath => '/102')

Sport.create( :name=> 'Synchronized' ,  :parent_id=> '102' ,  :fullpath => '/102/103')
Sport.create( :name=> '3m' ,  :parent_id=> '103' ,  :fullpath => '/102/103/104')
Sport.create( :name=> '10m' ,  :parent_id=> '103' ,  :fullpath => '/102/103/105')

Sport.create( :name=> 'Individual' ,  :parent_id=> '102' ,  :fullpath => '/102/106')
Sport.create( :name=> '3m' ,  :parent_id=> '106' ,  :fullpath => '/102/106/107')
Sport.create( :name=> '10m' ,  :parent_id=> '106' ,  :fullpath => '/102/106/108')

#Taekwondo -- id=109
Sport.create( :name=> 'Taekwondo' ,  :parent_id=> '' ,  :fullpath => '/109')

#Tennis -- id=110
Sport.create( :name=> 'Tennis' ,  :parent_id=> '' ,  :fullpath => '/110')
Sport.create( :name=> 'Singles' ,  :parent_id=> '110' ,  :fullpath => '/110/111')
Sport.create( :name=> 'Doubles' ,  :parent_id=> '110' ,  :fullpath => '/110/112')

#Table Tennis -- id=113
Sport.create( :name=> 'TableTennis' ,  :parent_id=> '' ,  :fullpath => '/113')
Sport.create( :name=> 'Singles' ,  :parent_id=> '113' ,  :fullpath => '/113/114')
Sport.create( :name=> 'Doubles' ,  :parent_id=> '113' ,  :fullpath => '/113/115')

#Shooting -- id=116
Sport.create( :name=> 'Shooting' ,  :parent_id=> '' ,  :fullpath => '/116')

Sport.create( :name=> 'Rifle' ,  :parent_id=> '116' ,  :fullpath => '/116/117')
Sport.create( :name=> '3pos' ,  :parent_id=> '117' ,  :fullpath => '/116/117/118')
Sport.create( :name=> '50down' ,  :parent_id=> '117' ,  :fullpath => '/116/117/119')
Sport.create( :name=> '10air' ,  :parent_id=> '117' ,  :fullpath => '/116/117/120')

Sport.create( :name=> 'Pistol' ,  :parent_id=> '116' ,  :fullpath => '/116/121')
Sport.create( :name=> '50m' ,  :parent_id=> '121' ,  :fullpath => '/116/121/122')
Sport.create( :name=> '25m' ,  :parent_id=> '121' ,  :fullpath => '/116/121/123')
Sport.create( :name=> '10m' ,  :parent_id=> '121' ,  :fullpath => '/116/121/124')

Sport.create( :name=> 'Trap' ,  :parent_id=> '116' ,  :fullpath => '/116/125')
Sport.create( :name=> 'DoubleTrap' ,  :parent_id=> '116' ,  :fullpath => '/116/126')
Sport.create( :name=> 'Skeet' ,  :parent_id=> '116' ,  :fullpath => '/116/127')

#Archery -- id=128
Sport.create( :name=> 'Archery' ,  :parent_id=> '' ,  :fullpath => '/128')
Sport.create( :name=> 'Individual' ,  :parent_id=> '128' ,  :fullpath => '/128/129')
Sport.create( :name=> 'Teams' ,  :parent_id=> '128' ,  :fullpath => '/128/130')

#Triathlon -- id=131
Sport.create( :name=> 'Triathlon' ,  :parent_id=> '' ,  :fullpath => '/131')

#Sailing -- id=132
Sport.create( :name=> 'Sailing' ,  :parent_id=> '' ,  :fullpath => '/132')

Sport.create( :name=> 'RS=>X' ,  :parent_id=> '132' ,  :fullpath => '/132/133')
Sport.create( :name=> 'Laser' ,  :parent_id=> '132' ,  :fullpath => '/132/134')
Sport.create( :name=> '470' ,  :parent_id=> '132' ,  :fullpath => '/132/135')
Sport.create( :name=> 'Star' ,  :parent_id=> '132' ,  :fullpath => '/132/136')
Sport.create( :name=> '49er' ,  :parent_id=> '132' ,  :fullpath => '/132/137')
Sport.create( :name=> 'Finn' ,  :parent_id=> '132' ,  :fullpath => '/132/138')

#Volleyball -- id=139
Sport.create( :name=> 'Volleyball' ,  :parent_id=> '' ,  :fullpath => '/139')
Sport.create( :name=> 'BeachVolleyball' ,  :parent_id=> '' ,  :fullpath => '/140')

#Waterpolo -- id=141
Sport.create( :name=> 'Waterpolo' ,  :parent_id=> '' ,  :fullpath => '/141')

#Rugby -- id=142
Sport.create( :name=> 'Rugby' ,  :parent_id=> '' ,  :fullpath => '/142')

#Skiing -- id=143
Sport.create( :name=> 'Skiing' ,  :parent_id=> '' ,  :fullpath => '/143')
Sport.create( :name=> 'Jump' ,  :parent_id=> '143' ,  :fullpath => '/143/144')
Sport.create( :name=> 'Slalom' ,  :parent_id=> '143' ,  :fullpath => '/143/145')

#Snowboard -- id=146
Sport.create( :name=> 'Snowboard' ,  :parent_id=> '' ,  :fullpath => '/146')

#American Football -- id=147
Sport.create( :name=> 'AmericanFootball' ,  :parent_id=> '' ,  :fullpath => '/147')

#Chess -- id=148
Sport.create( :name=> 'Chess' ,  :parent_id=> '' ,  :fullpath => '/148')

#Golf -- id=149
Sport.create( :name=> 'Golf' ,  :parent_id=> '' ,  :fullpath => '/149')

#Baseball -- id=150
Sport.create( :name=> 'Baseball' ,  :parent_id=> '' ,  :fullpath => '/150')

#Climbing -- id=151
Sport.create( :name=> 'Climbing' ,  :parent_id=> '' ,  :fullpath => '/151')
Sport.create( :name=> 'Wall' ,  :parent_id=> '151' ,  :fullpath => '/151/152')
Sport.create( :name=> 'Mountaineering' ,  :parent_id=> '151' ,  :fullpath => '/151/153')

#Cheerleader -- id=154
Sport.create( :name=> 'Cheerleader' ,  :parent_id=> '' ,  :fullpath => '/154')

#Karate -- id=155
Sport.create( :name=> 'Karate' ,  :parent_id=> '' ,  :fullpath => '/155')

#Bowling -- id=156
Sport.create( :name=> 'Bowling' ,  :parent_id=> '' ,  :fullpath => '/156')

#Cross Country -- id=157
Sport.create( :name=> 'CrossCountry' ,  :parent_id=> '' ,  :fullpath => '/157')

#Skin Diving -- id=158
Sport.create( :name=> 'SkinDiving' ,  :parent_id=> '' ,  :fullpath => '/158')

#Lacrosse -- id=159
Sport.create( :name=> 'Lacrosse' ,  :parent_id=> '' ,  :fullpath => '/159')

#Rodeo -- id=160
Sport.create( :name=> 'Rodeo' ,  :parent_id=> '' ,  :fullpath => '/160')

#Squash -- id=161
Sport.create( :name=> 'Squash' ,  :parent_id=> '' ,  :fullpath => '/161')

#Raquetball -- id=162
Sport.create( :name=> 'Raquetball' ,  :parent_id=> '' ,  :fullpath => '/162')

#Softball -- id=163
Sport.create( :name=> 'Softball' ,  :parent_id=> '' ,  :fullpath => '/163')
