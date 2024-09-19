--Julian Smissaert 500859427--

Create table genre_types(. --tabel aanmaken genre_types)
genre_id serial primary key,   --genre_id wordt de primary key van de table en is id (serial betekent elke unieke rij een oplopend id nummer krijgt)
genre_name varchar(255) unique not null. --genre_name colom wordt aangemaakt waarbij de namen kunnen verschillen tot 255 tekens en de value uniek moet zijn en niet leeg mag zijn
)

with split_genres as (  --(with = tijdelijke table die aangemaakt wordt) (voor 1 nf) (string to array zorgt voor het splitsen van de genres op basis van de ,)
select trim(unnest(string_to_array(genre, ','))) as genre_name --  (unnest) elke genre in de array krijgt zijn eigen rij.(trim) verwijdert spaties
from movie_info    --van de movie_info table
)
insert into genre_types (genre_name) --nieuwe data toevoegen in de table genre_types onder de colomn genre_name)
select distinct genre_name -- je wilt geen duplicaten hebben in de genre, waardoor er alleen maar uniek genres erin worden geplaatst)
from split_genres. -- je haalt het uit de aangemaakte tabel waar de genre 1 voor 1 in colom staan door 1e normalisatie)
where genre_name is not null. --lege waardes worden genegeerd )

select * from genre_types -- selecteer alle data uit de genre_types tabel
