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

var/list/first_names_male_upp = list("Badai","Mongkeemur","Alexei","Andrei","Artyom","Viktor","Xiangai","Ivan","Choban","Oleg", "Dayan", "Taghi", "Batu", "Arik", "Orda", "Ghazan", "Bala", "Gao", "Zhan", "Ren", "Hou", "Xue", "Serafim", "Luca", "Su", "György", "István", "Mihály", "Vladimir", "Aleksandr", "Fyodor", "Bhodar", "Qazem", "Łukasz", "Miłogost", "Radogost", "Uniegost", "Hostirad", "Hostimil", "Hostisvit", "Lubgost", "Gościsław",	"Vseslav", "Bohuměr", "Bronisław", "Česćiměr", "Dobysław", "Horisław", "Jaroměr", "Mirosław", "Mječisław", "Radoměr", "Stanij", "Stanisław", "Wjeleměr", "Wójsław")
var/list/first_names_female_upp = list("Altani","Cirina","Anastasiya","Saran","Wei","Oksana","Ren","Svena","Tatyana","Yaroslava", "Izabella", "Kata", "Krisztina", "Miruna", "Flori", "Lucia", "Anica", "Li", "Yimu", "Alona", "Hsiau-Li", "Xiaoling", "Erhong", "Baśka", "Angela", "Angelina", "Angja", "Ankica", "Biljana", "Bisera", "Bistra", "Blaga", "Blagica", "Blagorodna", "Verka", "Vladica", "Denica", "Živka", "Zlata", "Jagoda", "Letka", "Ljupka", "Mila", "Mirjana", "Mirka", "Rada", "Radmila", "Slavica", "Slavka", "Snežana", "Stojna", "Ubavka", "Jaromir", "Mscëwòj", "Subisłôw", "Swiãtopôłk", "Ji-Sun", "Chaeyong", "Chaewon", "Saerom", "Seoyeong", "Jiheon", "Hayoung")
var/list/last_names_upp = list("Azarov","Bogdanov","Barsukov","Golovin","Davydov","Khan","Noica","Barbu","Zhukov","Ivanov","Mihai","Kasputin","Belov", "Belova","Melnikov", "Vasilevsky", "Aleksander", "Halkovich", "Stanislaw", "Proca", "Zaituc", "Arcos", "Kubat", "Kral", "Volf", "Xun", "Jia", "Bachoń", "Wang", "Ji", "Xiang", "Zhang", "Mei", "Ma", "Kim", "Yi", "Ri", "Pak", "Chong", "Baek", "Kwon", "Hwang", "Roh", "Lee", "Song")

var/list/first_names_male_pmc = list("Owen","Luka","Nelson","Branson", "Tyson", "Leo", "Bryant", "Kobe", "Rohan", "Riley", "Aidan", "Watase","Egawa", "Hisakawa", "Koide", "Remy", "Martial", "Magnus", "Heiko", "Lennard")
var/list/first_names_female_pmc = list("Madison","Jessica","Anna","Juliet", "Olivia", "Lea", "Diane", "Kaori", "Beatrice", "Riley", "Amy", "Natsue","Yumi", "Aiko", "Fujiko", "Jennifer", "Ashley", "Mary", "Hitomi", "Lisa")
var/list/last_names_pmc = list("Bates","Shaw","Hansen","Black", "Chambers", "Hall", "Gibson", "Weiss", "Waller", "Burton", "Bakin", "Rohan", "Naomichi", "Yakumo", "Yosai", "Gallagher", "Hiles", "Bourdon", "Strassman", "Palau")

var/list/first_names_male_gladiator = list("Augustus", "Maximus", "Octavius", "Septimus", "Titus", "Brutus", "Caesar", "Justinian")
var/list/first_names_female_gladiator = list("Aelia", "Aquila", "Caecilia", "Camilla", "Claudia", "Flavia", "Martina", "Theodora")

var/list/first_names_male_dutch = list("Raymond", "Jesse", "Jack", "John", "Sam", "Aaron", "Charlie", "Ellis", "Nick", "Francis", "Louis")
var/list/first_names_female_dutch = list("Chelsea", "Mira", "Jessica", "Catherine", "Eliza", "Emma", "Ashley", "Annie", "Alicia", "Miranda", "Ellen")

var/list/monkey_names = list("Abu", "Aldo", "Bear", "Bingo", "Clyde", "Crystal", "Gordo", "George", "Koko", "Marcel", "Nim", "Geeves", "Nanu", "Rafiki", "Spike", "Banana", "Boots", "Bubbles", "Smiley", "Winston")

var/list/weapon_surnames = list("Adze", "Axe", "Bagh Nakha", "Bo", "Bola", "Bow", "Bowman", "Cannon", "Carbine", "Cestus", "Club", "Culverin", "Dagger", "Dao", "Derringer", "Dha", "Dussack", "Emeici", "Falchion", "Fan", "Flyssa", "Gauntlet", "Hammer", "Halberd", "Harquebus", "Hatchet", "Hwando", "Katar", "Kampilan", "Knuckles", "Lance", "Lancer", "Larim", "Maduvu", "Mace", "Maru", "Mauser", "Messer", "Mine", "Mubucae", "Nyepel", "Onager", "Pata", "Pike", "Ram", "Saber", "Seax", "Shamsir", "Sickle", "Sling", "Spear", "Spears", "Staff", "Sword", "Tekko")
