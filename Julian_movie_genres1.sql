--Julian Smissaert 500859427--

Create table movie_genres( --maakt de table movie_genres aan)
id serial primary key,     --serial creert een id voor elke unieke rij en is de primary key)
movie_id bigint,            --maakt colom movie_id aan (bigint) wat betekent dat het groot numeriek veld is 
genre_id bigint,            --maakt colom genre_id aan (bigint) wat betekent dat het groot numeriek veld is 
foreign key (movie_id) references movie_info (movie_id),    --stelt dat movie_id foreign key is en refereert naar de movie_info table waar (movie_id) de primary key is
foreign key (genre_id) references genre_types (genre_id).   --stelt dat genre_id foreign key is en refereert naar de genre_types table waar (genre_id) de primary key is
)


with split_genres as ( --with zorgt voor tijdelijke table naam waar de genre_names gesplitst zijn) (string to array is ontkoppelt de genres waar komma staat ) (1e normalisatie)
select movie_id, trim(unnest(string_to_array(genre,','))) as genre_name -- selecteer movie_id (unnest = elke genre in de array krijgt zijn eigen rij.(trim)verwijdert spaties (en dit komt onder de colom naam genre_name)
from movie_info     -- haalt het uit movie_info table
)
Insert into movie_genres(movie_id, genre_id)    --nieuwe informatie toevoegen in movie_genres table (kolom aanmaken movie_id en genre_id)
select sg.movie_id, gt.genre_id --             --selecteer vmovie_id van split_genres table en genre_id van genre_types table
from split_genres sg                            --haalt de gegevens uit splitgenres table
join genre_types gt on sg.genre_name = gt.genre_name --maak een join met genre_types table waar de genre_name uit splitgenres table overeenkomt met de genre_name in genre_types table (zo wordt het juiste 'genre_id' gekoppeld aan het 'movie_id'.
                                                     -- Er is een unieke koppeling gecreëerd tussen movie_id en genre_id in de movie_genres tabel. De id-kolom is nu een unieke identificator voor elke rij, maar de combinatie van movie_id en genre_id koppelt een film aan een genre.
select * from movie_genres     

alter table movie_info                 --edit de table movie_info door de colom genre te verwijderen)
drop column genre                       -- "De genre-kolom is verwijderd uit de movie_info-tabel omdat genres nu via movie_id en genre_id in de movie_genres-tabel worden gekoppeld.



select * from movie_info 

