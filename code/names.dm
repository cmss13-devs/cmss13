var/list/ai_names = file2list("config/names/ai.txt")
var/list/first_names_male = file2list("config/names/first_male.txt")
var/list/first_names_female = file2list("config/names/first_female.txt")
var/list/last_names = file2list("config/names/last.txt")
var/list/clown_names = file2list("config/names/clown.txt")
var/list/operation_titles = file2list("config/names/operation_title.txt")
var/list/operation_prefixes = file2list("config/names/operation_prefix.txt")
var/list/operation_postfixes = file2list("config/names/operation_postfix.txt")

var/list/verbs = file2list("config/names/verbs.txt")
//loaded on startup because of "
//would include in rsc if ' was used


var/list/first_names_male_clf = list("Alan","Jack","Bil","Jonathan","John","Shiro","Gareth","Clark","Sam", "Lionel", "Aaron", "Charlie", "Scott", "Winston", "Aidan", "Ellis", "Mason", "Wesley", "Nicholas", "Calvin", "Nishikawa", "Hiroto", "Chiba", "Ouchi", "Furuse", "Takagi", "Oba", "Kishimoto")
var/list/first_names_female_clf = list("Emma", "Adelynn", "Mary", "Halie", "Chelsea", "Lexie", "Arya", "Alicia", "Selah", "Amber", "Heather", "Myra", "Heidi", "Charlotte", "Oliva", "Lydia", "Tia", "Riko", "Ari", "Machida", "Ueki", "Mihara", "Noda")
var/list/last_names_clf = list("Hawkins","Rickshaw","Elliot","Billard","Cooper","Fox", "Barlow", "Barrows", "Stewart", "Morgan", "Green", "Stone", "Burr", "Hunt", "Yuko", "Gesshin", "Takanibu", "Tetsuzan", "Tomomi", "Bokkai", "Takesi")

var/list/first_names_male_colonist = list("Alan","Jack","Bil","Jonathan","John","Shiro","Gareth","Clark","Sam", "Lionel", "Aaron", "Charlie", "Scott", "Winston", "Aidan", "Ellis", "Mason", "Wesley", "Nicholas", "Calvin", "Nishikawa", "Hiroto", "Chiba", "Ouchi", "Furuse", "Takagi", "Oba", "Kishimoto")
var/list/first_names_female_colonist = list("Emma", "Adelynn", "Mary", "Halie", "Chelsea", "Lexie", "Arya", "Alicia", "Selah", "Amber", "Heather", "Myra", "Heidi", "Charlotte", "Ashley", "Raven", "Tori", "Anne", "Madison", "Oliva", "Lydia", "Tia", "Riko", "Ari", "Machida", "Ueki", "Mihara", "Noda")
var/list/last_names_colonist = list("Hawkins","Rickshaw","Elliot","Billard","Cooper","Fox", "Barlow", "Barrows", "Stewart", "Morgan", "Green", "Stone", "Titan", "Crowe", "Krantz", "Pathillo", "Driggers", "Burr", "Hunt", "Yuko", "Gesshin", "Takanibu", "Tetsuzan", "Tomomi", "Bokkai", "Takesi")

var/list/first_names_male_upp = list("Badai","Mongkeemur","Alexei","Andrei","Artyom","Viktor","Xangai","Ivan","Choban","Oleg", "Dayan", "Taghi", "Batu", "Arik", "Orda", "Ghazan", "Bala", "Gao", "Zhan", "Ren", "Hou", "Xue", "Serafim", "Luca", "Su", "György", "István", "Mihály")
var/list/first_names_female_upp = list("Altani","Cirina","Anastasiya","Saran","Wei","Oksana","Ren","Svena","Tatyana","Yaroslava", "Izabella", "Kata", "Krisztina", "Miruna", "Flori", "Lucia", "Anica", "Li", "Yimu")
var/list/last_names_upp = list("Azarov","Bogdanov","Barsukov","Golovin","Davydov","Khan","Noica","Barbu","Zhukov","Ivanov","Mihai","Kasputin","Belov","Melnikov", "Vasilevsky", "Aleksander", "Halkovich", "Stanislaw", "Proca", "Zaituc", "Arcos", "Kubat", "Kral", "Volf", "Xun", "Jia")

var/list/first_names_male_gladiator = list("Augustus", "Maximus", "Octavius", "Septimus", "Titus", "Brutus", "Caesar", "Justinian")
var/list/first_names_female_gladiator = list("Aelia", "Aquila", "Caecilia", "Camilla", "Claudia", "Flavia", "Martina", "Theodora")

var/list/first_names_male_dutch = list("Raymond", "Jesse", "Jack", "John", "Sam", "Aaron", "Charlie", "Ellis", "Nick", "Francis", "Louis")
var/list/first_names_female_dutch = list("Chelsea", "Mira", "Jessica", "Catherine", "Eliza", "Emma", "Ashley", "Annie", "Alicia", "Miranda", "Ellen")